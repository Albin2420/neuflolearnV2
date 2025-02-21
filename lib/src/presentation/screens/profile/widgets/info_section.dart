import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoSectionWidget extends StatelessWidget {
  final String sectionName;
  final VoidCallback onPressed;

  const InfoSectionWidget({
    super.key,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // double containerWidth = screenWidth * 0.9;
    double containerHeight = screenHeight * 0.08;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: containerHeight,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to the ends of the row
          children: [
            Text(
              sectionName,
              style: GoogleFonts.urbanist(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
