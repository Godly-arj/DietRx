import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, "products.db");

    var exists = await databaseExists(path);

    if (!exists) {
      print("Copying database from assets...");
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load(
          join("assets", "database", "products.db"),
        );
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes, flush: true);
        print("Database copied successfully!");
      } catch (e) {
        print("Error copying database: $e");
      }
    } else {
      print("Database already exists at: $path");
    }

    return await openDatabase(path, readOnly: false);
  }

  Future<Map<String, dynamic>?> getProduct(String barcode) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAlternatives(
    String categoryString,
  ) async {
    final db = await database;

    if (categoryString.isEmpty) return [];

    // 1. Split the string by commas to get the hierarchy
    List<String> tags = categoryString.split(',');

    if (tags.isEmpty) return [];

    // 2. Grab the LAST tag
    String mostSpecificTag = tags.last.trim();

    print(
      "Searching for alternatives with specific tag: '$mostSpecificTag'",
    );

    // 3. Query the DB for products that share this EXACT specific tag
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'categories LIKE ?',
      whereArgs: ['%$mostSpecificTag%'],
      limit: 50,
    );

    return maps;
  }

  // --- SCAN HISTORY METHODS ---
  // 1. Create the history table if it doesn't exist
  Future<void> _ensureHistoryTableExists() async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT,
        name TEXT,
        image_url TEXT,
        status TEXT,
        scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // 2. Save a new scan to history
  Future<void> saveScanHistory(String barcode, String name, String? imageUrl, String status) async {
    final db = await database;
    await _ensureHistoryTableExists();
    
    await db.insert('scan_history', {
      'barcode': barcode,
      'name': name,
      'image_url': imageUrl,
      'status': status,
    });
  }

  // 3. Fetch all scan history
  Future<List<Map<String, dynamic>>> getScanHistory() async {
    final db = await database;
    await _ensureHistoryTableExists();
    return await db.query('scan_history', orderBy: 'scanned_at DESC');
  }
}