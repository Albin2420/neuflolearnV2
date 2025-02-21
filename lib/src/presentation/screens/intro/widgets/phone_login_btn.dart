import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PhoneLoginButton extends StatelessWidget {
  const PhoneLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF010029),
            Color(0xFF010048),
          ],
        ),
        borderRadius: BorderRadius.circular(76),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(76),
          // onTap: () => Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const PhoneSignUpScreen(),
          //   ),
          // ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(76),
            ),
            child: Container(
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
                    'Continue with phone',
                    style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: Constant.screenHeight *
                            (16 / Constant.figmaScreenHeight)),
                  ),
                  Icon(
                    PhosphorIcons.phone(),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
