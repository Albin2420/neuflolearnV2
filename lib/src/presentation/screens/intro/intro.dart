import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth_impl.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/auth/auth_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/account_setup.dart';
import 'package:neuflo_learn/src/presentation/screens/basic_info/add_basic_info.dart';
import 'package:neuflo_learn/src/presentation/screens/intro/widgets/google_login_btn.dart';
import 'package:neuflo_learn/src/presentation/screens/intro/widgets/intro_items.dart';
import 'package:neuflo_learn/src/presentation/screens/navigationscreen/navigationscreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(AuthController());
    final appctrl = Get.find<AppStartupController>();
    FirestoreService firestoreService = FirestoreService();

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
              'neuflo',
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400, fontSize: 32),
            ),
            Text(
              "learn",
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF6C00),
                  fontSize: 32),
            )
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  // Obx(() {
                  //   if (appctrl.isDemo.value == true) {
                  //     return Padding(
                  //       padding: const EdgeInsets.only(left: 8, right: 8),
                  //       child: SizedBox(
                  //         height: 100,
                  //         child: Row(
                  //           children: [
                  //             Expanded(
                  //               child: TextField(
                  //                 controller: ctr.textCtr,
                  //               ),
                  //             ),
                  //             TextButton(
                  //               onPressed: () {
                  //                 Url.baseUrl = ctr.textCtr.text;

                  //                 ctr.textCtr.clear();
                  //               },
                  //               child: const Text('Submit'),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   } else {
                  //     return SizedBox();
                  //   }
                  // }),
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
                  const SizedBox(
                    height: 24,
                  ),
                  // Gap(
                  //   Constant.screenHeight * (32 / Constant.figmaScreenHeight),
                  // ),
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
            const SizedBox(
              height: 48,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
              // color: Colors.yellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const PhoneLoginButton(),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  GoogleLoginButton(
                    onTapFunction: () async {
                      await ctr.singInWithGoogle();

                      if (ctr.currentAppUser.value != null) {
                        if (ctr.currentFirestoreAppUser.value != null) {
                          if (ctr.currentFirestoreAppUser.value
                                  ?.isProfileSetupComplete ==
                              null) {
                            if (ctr.currentFirestoreAppUser.value?.name == '' ||
                                ctr.currentFirestoreAppUser.value?.email ==
                                    '') {
                              Get.offAll(() => AddBasicInfo());
                              return;
                            } else {
                              Get.offAll(() => AccountSetup());
                              return;
                            }
                          } else {
                            await firestoreService
                                .dailyExamReportResetandStreakReset(
                                    userName:
                                        "${ctr.currentAppUser.value?.phoneNumber}@neuflo.io");
                            Fluttertoast.showToast(msg: 'Sign in successfull');
                            Get.offAll(() => NavigationScreen());
                            return;
                          }
                        }
                      }

                      if (ctr.authStatus.value == AuthStatus.successful) {
                        Fluttertoast.showToast(msg: 'Sign in successfull');

                        Get.to(() => AddBasicInfo());
                      }
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
