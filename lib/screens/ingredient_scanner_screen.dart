import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/dynamic_rule_service.dart';

class IngredientScannerScreen extends StatefulWidget {
  final String scannedBarcode;

  const IngredientScannerScreen({super.key, required this.scannedBarcode});

  @override
  State<IngredientScannerScreen> createState() =>
      _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen> {
  bool _isProcessing = false;
  Map<String, dynamic>? _extractedData;
  final ImagePicker _picker = ImagePicker();

  Future<void> _scanLabel() async {
    try {
      // 1. Open Camera
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      setState(() {
        _isProcessing = true;
        _extractedData = null;
      });

      // 2. Send to our API
      final data = await DynamicRuleService.analyzeProductLabel(
        File(image.path),
      );

      // 3. Update UI
      if (mounted) {
        setState(() {
          _extractedData = data;
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error reading label: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Scan Ingredients",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF8CC63F)),
                  const SizedBox(height: 20),
                  Text(
                    "Analyzing the label...",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ],
              )
            : _extractedData != null
            ? _buildResultView()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.document_scanner,
                    size: 80,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Take a clear photo of the Ingredients list and Nutritional table.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _scanLabel,
                    icon: const Icon(Icons.camera_alt, color: Colors.black),
                    label: Text(
                      "Open Camera",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8CC63F),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildResultView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Extraction Successful!",
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _extractedData.toString(),
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Save this data to Firestore!
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8CC63F),
              ),
              child: Text(
                "Looks Good - Continue",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
