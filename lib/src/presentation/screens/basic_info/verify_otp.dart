import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/add_user_info/add_user_info_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/account_setup.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
import 'package:pinput/pinput.dart';

class VerifyOtp extends StatelessWidget {
  const VerifyOtp({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<AddUserInfoController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: const Color(0x00000008),
        surfaceTintColor: Colors.white,
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            ctr.resetTimer();
            Get.back();
          },
          icon: Icon(Icons.close_rounded),
        ),
        title: Text(
          "Enter OTP",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF010029),
          ),
        ),
        flexibleSpace: Column(
          children: [
            const Spacer(), // This pushes the container to the bottom
            Container(
              height: 1,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Shadow color with opacity
                  offset: const Offset(0, 1), // Horizontal and Vertical offset
                ),
              ]),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 80),
              width: MediaQuery.of(context).size.width,
              height: 175,
              child: Pinput(
                separatorBuilder: (index) {
                  if (index == 2) {
                    return const SizedBox(
                      width: 30,
                    );
                  } else {
                    return const SizedBox(
                      width: 8,
                    );
                  }
                },
                length: 6,
                validator: (s) {
                  return s?.length == 6 ? null : 'Invalid pin';
                },
                onCompleted: (pin) async {
                  ctr.finalOtp.value = pin;
                },
                defaultPinTheme: PinTheme(
                  width: 32,
                  height: 45,
                  textStyle: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w500, fontSize: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Code not received?",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      Obx(() {
                        return Text(
                          ' ${ctr.formattedTime}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  // Obx(
                  //   () => ctr.isTimerActive == false
                  //       ? GestureDetector(
                  //           onTap: () {},
                  //           child: Text(
                  //             "Resend now",
                  //             style: GoogleFonts.urbanist(
                  //                 decoration: TextDecoration.underline,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 16),
                  //           ),
                  //         )
                  //       : SizedBox(),
                  // )
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        if (!ctr.isTimerActive) {
                          ctr.startTimer();
                          ctr.generateOtp();
                        } else {
                          log("hooi:${ctr.countdownTimer}");
                        }
                      },
                      child: Text(
                        "Resend now",
                        style: GoogleFonts.urbanist(
                          decoration: TextDecoration.underline,
                          fontWeight: !ctr.isTimerActive
                              ? FontWeight.bold
                              : FontWeight.w200,
                          fontSize: 16,
                        ),
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 140,
        // color: Colors.amber,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'By tapping "Continue" you agree to our\n',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color(0xFF010029).withOpacity(0.6),
                      ),
                    ),
                    TextSpan(
                      text: 'terms of service',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          log('Terms of Service tapped');
                        },
                    ),
                    TextSpan(
                      text: ' and ',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'privacy policy',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle "privacy policy" tap
                          log('Privacy Policy tapped');
                          // Navigate to privacy policy page or show dialog
                        },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppBtn(
                btnName: 'Continue',
                onTapFunction: () async {
                  if (ctr.currentOtp == int.parse(ctr.finalOtp.value)) {
                    // EasyLoading.show();
                    await ctr.saveDetails();
                    // ctr.resetTimer();
                    // EasyLoading.dismiss();
                  } else {
                    Fluttertoast.showToast(
                      msg: "Invalid OTP. Please try again.",
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
