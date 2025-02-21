import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'neuflo',
              style: GoogleFonts.urbanist(
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'learn',
              style: GoogleFonts.urbanist(
                fontSize: 32,
                color: const Color(0xFFFF6C00),
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
