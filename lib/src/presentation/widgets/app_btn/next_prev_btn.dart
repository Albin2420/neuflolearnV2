import 'package:flutter/material.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class NextPrevBtn extends StatelessWidget {
  final String iconImg;

  final Function onTapFunction;

  const NextPrevBtn(
      {super.key, required this.onTapFunction, required this.iconImg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Constant.screenHeight * (8 / Constant.figmaScreenHeight),
          horizontal: Constant.screenWidth * (8 / Constant.figmaScreenWidth)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF010029),
            Color(0xFF010048),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: const Color.fromARGB(115, 1, 0, 72),
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onTapFunction();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical:
                    Constant.screenHeight * (8 / Constant.figmaScreenHeight),
                horizontal:
                    Constant.screenWidth * (8 / Constant.figmaScreenWidth)),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              iconImg,
              width: Constant.screenWidth * (10 / Constant.figmaScreenWidth),
              height: Constant.screenHeight * (12 / Constant.figmaScreenHeight),
            ), // Use a default value if iconImg is null
          ),
        ),
      ),
    );
  }
}
