import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class AppBtnOutLine extends StatelessWidget {
  final String btnName;
  final Widget? routePage;
  final Function onTapFunction;
  final IconData? iconImg;
  final List<Color>? colors;
  final bool? isOutline;
  const AppBtnOutLine(
      {super.key,
      required this.btnName,
      this.routePage,
      required this.onTapFunction,
      this.iconImg,
      this.colors,
      this.isOutline});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isOutline == false
            ? LinearGradient(
                colors: colors ??
                    [
                      Color(0xFF010029),
                      Color(0xFF010048),
                    ],
              )
            : null,
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
              border: Border.all(
                  color: isOutline == true
                      ? Color(0xff02012A)
                      : Colors.transparent),
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
                      color:
                          isOutline == false ? Colors.white : Color(0xff020130),
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
