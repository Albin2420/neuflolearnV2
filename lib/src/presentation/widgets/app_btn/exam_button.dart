import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class ExamButton extends StatelessWidget {
  final String btnName;
  final bool? isOutline;
  final Widget? routePage;
  final Function onTapFunction;
  final IconData? iconImg;
  final int hpad;
  final int vpad;
  final Color? btncolor;

  const ExamButton({
    super.key,
    required this.btnName,
    this.routePage,
    this.isOutline,
    required this.onTapFunction,
    this.iconImg,
    this.btncolor,
    required this.hpad,
    required this.vpad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: btnName == 'Next'
              ? Colors.black
              : isOutline == true
                  ? Colors.black
                  : Colors.transparent,
        ),
        color: btncolor,
        gradient: btncolor == null
            ? btnName == 'Next'
                ? LinearGradient(colors: [Colors.white, Colors.white])
                : const LinearGradient(
                    colors: [Color(0xFF010029), Color(0xFF010048)],
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(76)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    Constant.screenHeight * (vpad / Constant.figmaScreenHeight),
                horizontal:
                    Constant.screenWidth * (hpad / Constant.figmaScreenWidth),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  btnName == 'Next'
                      ? Text(
                          btnName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: Constant.screenHeight *
                                (16 / Constant.figmaScreenHeight),
                          ),
                        )
                      : Text(
                          btnName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            color:
                                isOutline == true ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: Constant.screenHeight *
                                (16 / Constant.figmaScreenHeight),
                          ),
                        ),
                  // Adjust the width as needed
                  if (iconImg != null)
                    Icon(
                      iconImg,
                      color: btnName == 'Next'
                          ? AppColors.black
                          : isOutline == true
                              ? AppColors.kblue
                              : Colors.white,
                    ),
                  // Use a default value if iconImg is null
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBtn3 extends StatelessWidget {
  final String btnName;
  final Widget? routePage;
  final Function onTapFunction;
  final IconData? iconImg;
  final int hpad;
  final int vpad;
  const CustomBtn3({
    super.key,
    required this.btnName,
    this.routePage,
    required this.onTapFunction,
    this.iconImg,
    required this.hpad,
    required this.vpad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(76)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: const Color.fromARGB(115, 1, 0, 72),
          borderRadius: BorderRadius.circular(76),
          onTap: () {
            onTapFunction();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(76),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    Constant.screenHeight * (vpad / Constant.figmaScreenHeight),
                horizontal:
                    Constant.screenWidth * (hpad / Constant.figmaScreenWidth),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    btnName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w500,
                      fontSize: Constant.screenHeight *
                          (16 / Constant.figmaScreenHeight),
                    ),
                  ),
                  if (iconImg != null) Icon(iconImg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBtn4 extends StatelessWidget {
  final String btnName;
  final Widget? routePage;
  final Function onTapFunction;
  final IconData? iconImg;
  final int hpad;
  final int vpad;

  const CustomBtn4({
    super.key,
    required this.btnName,
    this.routePage,
    required this.onTapFunction,
    this.iconImg,
    required this.hpad,
    required this.vpad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF010029), Color(0xFF010048)],
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(76)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    Constant.screenHeight * (vpad / Constant.figmaScreenHeight),
                horizontal:
                    Constant.screenWidth * (hpad / Constant.figmaScreenWidth),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  // Adjust the width as needed
                  if (iconImg != null) Icon(iconImg, color: Colors.white),
                  // Use a default value if iconImg is null
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
