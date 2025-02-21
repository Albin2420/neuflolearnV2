import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class AppBtn extends StatelessWidget {
  final String btnName;
  final Widget? routePage;
  final Function onTapFunction;
  final IconData? iconImg;
  final List<Color>? colors;
  const AppBtn({
    super.key,
    required this.btnName,
    this.routePage,
    required this.onTapFunction,
    this.iconImg,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ??
              [
                Color(0xFF010029),
                Color(0xFF010048),
              ],
        ),
        borderRadius: BorderRadius.circular(76),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: const Color.fromARGB(115, 1, 0, 72),
          borderRadius: BorderRadius.circular(76),
          onTap: () {
            onTapFunction();
          },
          child: Container(
            width: Constant.screenWidth,
            decoration: BoxDecoration(
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
                mainAxisAlignment: (iconImg != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Text(
                    btnName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: Constant.screenHeight *
                          (16 / Constant.figmaScreenHeight),
                    ),
                  ),
                  if (iconImg != null)
                    SizedBox(
                      width: Constant.screenWidth *
                          (4 / Constant.figmaScreenWidth),
                    ), // Adjust the width as needed
                  if (iconImg != null)
                    Icon(
                      iconImg,
                      color: Colors.white,
                    ) // Use a default value if iconImg is null
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
