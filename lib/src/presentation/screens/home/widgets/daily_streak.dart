import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class DailyStreak extends StatelessWidget {
  const DailyStreak({super.key, required this.widget, required this.day});
  final String day;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget,
        SizedBox(
          height: 4,
        ),
        Text(
          day,
          style: GoogleFonts.urbanist(
            fontSize: Constant.screenHeight * (10 / Constant.figmaScreenHeight),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000),
          ),
        )
      ],
    );
  }
}
