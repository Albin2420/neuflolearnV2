import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class IntroItems extends StatelessWidget {
  const IntroItems({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });
  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          width: Constant.screenWidth * (390 / Constant.figmaScreenWidth),
          height: Constant.screenHeight * (206 / Constant.figmaScreenHeight),
        ),
        Gap(Constant.screenHeight * (51 / Constant.figmaScreenHeight)),
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: Constant.screenHeight * (24 / Constant.figmaScreenHeight),
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(Constant.screenHeight * (8 / Constant.figmaScreenHeight)),
        Text(
          description,
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            fontSize: Constant.screenHeight * (16 / Constant.figmaScreenHeight),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
