import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class TestNavigateCard extends StatelessWidget {
  const TestNavigateCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
  });
  final String image, title, description;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(
              Constant.screenWidth * (16 / Constant.figmaScreenWidth),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(image, width: 40, height: 40),
                Gap(Constant.screenHeight * (16 / Constant.figmaScreenHeight)),
                Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize:
                        Constant.screenWidth * (16 / Constant.figmaScreenWidth),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.urbanist(
                    fontSize:
                        Constant.screenWidth * (14 / Constant.figmaScreenWidth),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
