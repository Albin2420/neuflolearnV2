import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomTextBtn({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Action when tapped
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(76),
          border: Border.all(
            color: Color(0xff02012A), // Border color
          ),
        ),
        child: Center(
          child: Text(
            text, // Dynamic text
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xff020130), // Text color
            ),
          ),
        ),
      ),
    );
  }
}
