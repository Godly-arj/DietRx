import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scan_result.dart';

class ResultScreen extends StatelessWidget {
  final ScanResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // 1. Determine Theme Colors & Texts based on status
    Color primaryColor;
    Color pillColor;
    Color pillTextColor;
    String pillText;
    List<String> descriptionPoints = [];

    if (result.isMissingData) {
      primaryColor = const Color(0xFFD97706);
      pillColor = const Color(0xFFFCD34D);
      pillTextColor = const Color(0xFF92400E);
      pillText = "UNKNOWN STATUS";
      descriptionPoints = [
        "Nutrition facts are missing from our database.",
        "We couldn't verify specific nutrients needed for your health profile.",
        "Please read the physical label carefully before consuming.",
      ];
    } else if (result.isSafe) {
      primaryColor = const Color(0xFF4C7B33);
      pillColor = const Color(0xFF8CC63F);
      pillTextColor = Colors.white;
      pillText = "SAFE TO EAT";
      descriptionPoints = [
        "This product safely matches your dietary profile.",
        "It does not contain any ingredients restricted by your health conditions.",
        "No allergens matching your profile were detected.",
      ];
    } else {
      primaryColor = const Color(0xFFC11A1A);
      pillColor = const Color(0xFFE5A4A4);
      pillTextColor = const Color(0xFF7F1D1D);
      pillText = "NOT SAFE TO EAT";
      descriptionPoints = result.warnings;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // --- HEADER CURVE ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 150),
                ),
              ),
            ),
          ),

          // --- LEAF ACCENTS ---
          if (result.isSafe) ...[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.20,
              left: 40,
              child: const Icon(Icons.eco, color: Color(0xFF8CC63F), size: 40),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              right: 40,
              child: const Icon(Icons.eco, color: Color(0xFF8CC63F), size: 50),
            ),
          ],

          // --- BACK BUTTON & TITLE ---
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          result.productName.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- SCROLLABLE CONTENT ---
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.10,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // --- PRODUCT IMAGE ---
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: result.imageUrl != null
                            ? Image.network(
                                result.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(
                                  Icons.fastfood,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              )
                            : const Icon(
                                Icons.fastfood,
                                size: 80,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- STATUS PILL ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: pillColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: pillTextColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        pillText,
                        style: GoogleFonts.poppins(
                          color: pillTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- DESCRIPTION CARD ---
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.elliptical(300, 50),
                          bottom: Radius.circular(20),
                        ),
                        border: Border(
                          top: BorderSide(color: pillColor, width: 4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Description",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Bullet Points
                          ...descriptionPoints.map(
                            (point) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: pillTextColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      point,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- ALTERNATIVES SECTION ---
                    if (!result.isSafe || result.isMissingData) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Safe Alternatives",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (result.alternatives.isNotEmpty)
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: result.alternatives.length,
                            itemBuilder: (context, index) {
                              final alt = result.alternatives[index];
                              return GestureDetector(
                                onTap: () => _showReasonDialog(context, alt),
                                child: Container(
                                  width: 130,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: alt['image_url'] != null
                                            ? Image.network(
                                                alt['image_url'],
                                                fit: BoxFit.contain,
                                              )
                                            : const Icon(
                                                Icons.eco,
                                                color: Colors.green,
                                                size: 40,
                                              ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        alt['name'] ?? "Unknown",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "No safer alternatives currently available in the database.",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // --- FLOATING ACTION BUTTON ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pop(context),
        backgroundColor: primaryColor,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
      ),
    );
  }

  void _showReasonDialog(
    BuildContext context,
    Map<String, dynamic> altProduct,
  ) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Why is ${altProduct['name']} better?",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          altProduct['match_reason'] ?? "It fits all your health limits.",
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.green[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(
              "Got it",
              style: GoogleFonts.poppins(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
