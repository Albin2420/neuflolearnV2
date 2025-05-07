import 'dart:developer';

import 'package:neuflo_learn/src/presentation/controller/add_user_info/add_user_info_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/basic_info/add_phone_umber.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBasicInfo extends StatelessWidget {
  const AddBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(AddUserInfoController());
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
            Get.back();
          },
          icon: Icon(Icons.close_rounded),
        ),
        title: Text(
          "Tell us your name",
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
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.2,
                    ), // Shadow color with opacity
                    offset: const Offset(
                      0,
                      1,
                    ), // Horizontal and Vertical offset
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
              child: Column(
                children: [
                  TextField(
                    controller: ctr.nameController,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(
                          bottom: 19,
                          top: 10,
                          right: 15,
                        ),
                        height: 16,
                        width: 16,
                        child: Image.asset("assets/icons/person.png"),
                      ),
                      hintText: "Your name",
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF010029),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF000000)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (ctr.nameError.value != null) {
                return Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Row(
                    children: [
                      Text(
                        '${ctr.nameError.value}',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 207, 28, 28),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
            Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 32,
                bottom: 32,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: ctr.emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(
                          bottom: 19,
                          top: 10,
                          right: 15,
                        ),
                        height: 16,
                        width: 16,
                        child: Image.asset("assets/icons/mail.png"),
                      ),
                      hintText: "Your email",
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF010029),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF000000)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 140,
        color: Colors.white,
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
                onTapFunction: () {
                  ctr.validateName();
                  if (ctr.nameError.value == null) {
                    Get.to(() => AddPhoneNumber());
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
