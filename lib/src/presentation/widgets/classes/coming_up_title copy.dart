import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComingUpTitle extends StatelessWidget {
  const ComingUpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 20,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Coming Up Next",
              style: GoogleFonts.urbanist(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
