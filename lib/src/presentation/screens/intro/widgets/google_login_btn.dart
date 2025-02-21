import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class GoogleLoginButton extends StatelessWidget {
  final Function onTapFunction;
  const GoogleLoginButton({super.key, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(76),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(76),
        onTap: () {
          onTapFunction();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0xFF02012A)),
            borderRadius: BorderRadius.circular(76),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical:
                  Constant.screenHeight * (14 / Constant.figmaScreenHeight),
              horizontal:
                  Constant.screenWidth * (24 / Constant.figmaScreenWidth),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Continue with google',
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF02012A),
                    fontWeight: FontWeight.w600,
                    fontSize: Constant.screenHeight *
                        (16 / Constant.figmaScreenHeight),
                  ),
                ),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset("assets/icons/google.png"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
