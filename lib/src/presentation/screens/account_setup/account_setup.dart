import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/setup_account/setup_account_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/target_area.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/target_course.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/widgets/account_setup_success.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';

class AccountSetup extends StatelessWidget {
  const AccountSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(SetupAccountController());

    List progress = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1A1A3E), width: 1),
                borderRadius: BorderRadius.circular(34),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A3E),
                  borderRadius: BorderRadius.circular(34),
                ),
                width: Constant.screenWidth * (106 / Constant.figmaScreenWidth),
                height:
                    Constant.screenHeight * (4 / Constant.figmaScreenHeight),
                margin: const EdgeInsets.all(1.5),
              ),
            ),
          ),
          Gap(Constant.figmaScreenWidth * (4 / Constant.figmaScreenWidth)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: const Color(0xFFCCCCD4),
              ),
              width: Constant.screenWidth * (106 / Constant.figmaScreenWidth),
              height: Constant.screenHeight * (4 / Constant.figmaScreenHeight),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: const Color(0xFF1A1A3E),
              ),
              width: Constant.screenWidth * (106 / Constant.figmaScreenWidth),
              height: Constant.screenHeight * (4 / Constant.figmaScreenHeight),
            ),
          ),
          Gap(Constant.figmaScreenWidth * (4 / Constant.figmaScreenWidth)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1A1A3E), width: 1),
                borderRadius: BorderRadius.circular(34),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A3E),
                  borderRadius: BorderRadius.circular(34),
                ),
                width: Constant.screenWidth * (106 / Constant.figmaScreenWidth),
                height:
                    Constant.screenHeight * (4 / Constant.figmaScreenHeight),
                margin: const EdgeInsets.all(1.5),
              ),
            ),
          ),
        ],
      ),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: SizedBox(),
          shadowColor: const Color(0x00000008),
          surfaceTintColor: Colors.white,
          elevation: 10,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                "Setup your account",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF010029),
                ),
              ),
              Text(
                "Targetcourse",
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF010029),
                ),
              )
            ],
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
                    offset:
                        const Offset(0, 1), // Horizontal and Vertical offset
                  ),
                ]),
              ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(
            Constant.screenWidth * (16 / Constant.figmaScreenWidth),
          ),
          child: Column(
            children: [
              Obx(() => progress[ctr.currentPageIndex.value]),
              Gap(Constant.screenHeight * (16 / Constant.figmaScreenHeight)),
              Expanded(
                child: PageView(
                  controller: ctr.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    TargetCourse(),
                    TargetArea(),
                  ],
                ),
              ),
              Obx(
                () => AppBtn(
                  btnName: ctr.currentPageIndex.value == 0 ? "Next" : 'Submit',
                  onTapFunction: () async {
                    if (ctr.currentPageIndex.value == 0 &&
                        ctr.currentSelectedCourse.value == null) {
                      Fluttertoast.showToast(
                        msg: "Please select a course to continue",
                      );
                      return;
                    }

                    if (ctr.currentPageIndex.value == 1) {
                      Get.to(() => AccountSetupSuccess());

                      return;
                    }

                    ctr.setPageIndex(ctr.currentPageIndex.value + 1);
                    ctr.pageController
                        .jumpToPage(ctr.currentPageIndex.value + 1);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
