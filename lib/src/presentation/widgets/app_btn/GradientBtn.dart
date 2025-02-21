import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String iconPath;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(76),
          gradient: const LinearGradient(
            colors: [Color(0xff010029), Color(0xff010048)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 22,
              width: 22,
              child: Image.asset(
                iconPath,
                scale: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
