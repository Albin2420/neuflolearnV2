import 'dart:developer';

import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth_impl.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/auth/auth_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/account_setup.dart';
import 'package:neuflo_learn/src/presentation/screens/basic_info/add_basic_info.dart';
import 'package:neuflo_learn/src/presentation/screens/intro/widgets/google_login_btn.dart';
import 'package:neuflo_learn/src/presentation/screens/intro/widgets/intro_items.dart';
import 'package:neuflo_learn/src/presentation/screens/navigationscreen/navigationscreen.dart';
import 'package:neuflo_learn/src/presentation/screens/pending/accountsetuppending.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/config/theme/colors.dart';
import '../../../core/url.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(AuthController());
    final appctrl = Get.find<AppStartupController>();
    FirestoreService firestoreService = FirestoreService();
    TextEditingController urlController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Neuflo',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w400,
                fontSize: 32,
              ),
            ),
            Text(
              "Learn",
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFF6C00),
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.center,
            colors: [
              const Color(0xFFFFFFFF), // White
              const Color(0xFFFFFFFF), // White (same as the first one)
              const Color(0xFFEEFCFF).withOpacity(0.4), // Light blue color
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          hintText: "Enter URL",
                          hintStyle: GoogleFonts.urbanist(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .orange), // Border color when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.kOrange,
                                width: 2), // Border color when focused
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        log("URL => ${urlController.text}");
                        Url.baseUrl1 = urlController.text;
                        log("Url.baseUrl1 => ${Url.baseUrl1}");
                        Fluttertoast.showToast(
                            msg: "base url :${Url.baseUrl1}");
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(Icons.arrow_forward_ios,
                            color:
                                Colors.white), // Optional: Add icon for meaning
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: ctr.controller,
                        children: const [
                          IntroItems(
                            image: "assets/images/intro1.png",
                            title: "Your Personal NEET Guide",
                            description:
                                "Our app is designed to make your preparation journey smooth and effective.",
                          ),
                          IntroItems(
                            image: "assets/images/intro2.png",
                            title: "Practice with mock-tests",
                            description:
                                "Elevate your NEET preparation with meticulously crafted mock tests aligned with the syllabus.",
                          ),
                          IntroItems(
                            image: "assets/images/intro3.png",
                            title: "Advanced Learning Analytics",
                            description:
                                "Gain insights into your strengths and weaknesses, track study patterns, and more.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Gap(
                      Constant.screenHeight * (32 / Constant.figmaScreenHeight),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: ctr.controller,
                        effect: const WormEffect(
                          activeDotColor: Color(0xFF010029),
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                        count: 3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              BottomAppBar(
                color: Colors.transparent,
                child: GoogleLoginButton(
                  onTapFunction: () async {
                    if (ctr.isgLoginTriggered.value != true) {
                      ctr.isgLoginTriggered.value = true;
                      await ctr.singInWithGoogle();

                      log("auth status1:${ctr.authStatus}");
                      log(
                        "issetupComplete:${ctr.currentFirestoreAppUser.value?.isProfileSetupComplete}",
                      );

                      // if (ctr.currentAppUser.value != null) {
                      if (ctr.currentFirestoreAppUser.value != null &&
                          ctr.authStatus.value == AuthStatus.successful) {
                        if (ctr.currentFirestoreAppUser.value
                                ?.isProfileSetupComplete ==
                            false) {
                          if (ctr.currentFirestoreAppUser.value?.name == '' ||
                              ctr.currentFirestoreAppUser.value?.email == '') {
                            ctr.isgLoginTriggered.value = false;
                            Get.offAll(() => AddBasicInfo());
                            return;
                          }
                        } else {
                          log(
                            "navigate to home() :${ctr.currentFirestoreAppUser.value?.phone}",
                          );
                          EasyLoading.show();

                          bool isTokenFetched = await ctr.getNewToken(
                            studentId:
                                ctr.currentFirestoreAppUser.value?.id ?? 0,
                            phoneNumber:
                                ctr.currentFirestoreAppUser.value?.phone ?? '',
                          );

                          if (isTokenFetched) {
                            firestoreService.dailyExamReportResetandStreakReset(
                              userName:
                                  "${ctr.currentFirestoreAppUser.value?.phone}@neuflo.io",
                            );
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(msg: 'Sign in successful');
                            ctr.isgLoginTriggered.value = false;
                            Get.offAll(() => NavigationScreen());
                          } else {
                            if (ctr.notverified.value == true) {
                              EasyLoading.dismiss();
                              ctr.isgLoginTriggered.value = false;
                              Get.offAll(
                                () => AccountSetupFailed(userName: "Albin"),
                              );
                            } else {
                              EasyLoading.dismiss();
                              ctr.isgLoginTriggered.value = false;
                              Fluttertoast.showToast(
                                msg: 'something went wrong',
                              );
                            }
                            // EasyLoading.dismiss();
                            // ctr.isgLoginTriggered.value = false;
                            // Fluttertoast.showToast(
                            //   msg: 'something went wrong',
                            // ); //403 check
                          }
                          return;
                        }
                      }

                      if (ctr.authStatus.value == AuthStatus.successful) {
                        Fluttertoast.showToast(msg: 'Sign in successfull');
                        ctr.isgLoginTriggered.value = false;
                        Get.to(() => AddBasicInfo());
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
