import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/setup_account/setup_account_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/navigationscreen/navigationscreen.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';

class AccountSetupSuccess extends StatelessWidget {
  const AccountSetupSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.kScaffoldBg2,
        body: AccountSetupSuccessWidget(),
        bottomNavigationBar: SetupSuccessBtn(),
      ),
    );
  }
}

class SetupSuccessBtn extends StatelessWidget {
  const SetupSuccessBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<SetupAccountController>();
    return Container(
      padding: EdgeInsets.all(16),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppBtn(
            btnName: 'Continue',
            onTapFunction: () async {
              EasyLoading.show();
              await ctr.completeUserSetup();

              if (ctr.userAccountSetupState.value.state == DataState.success) {
                log('----------  if data state is SUCCESS');
                await EasyLoading.dismiss();
                Get.offAll(() => NavigationScreen());
              }

              if (ctr.userAccountSetupState.value.state == DataState.error) {
                log('----------  if data state is ERROR');
                EasyLoading.dismiss();
                Fluttertoast.showToast(
                  backgroundColor: Colors.red.shade400,
                  textColor: Colors.white,
                  msg: 'Account setup failed. Try again',
                );

                return;
              }
            },
          )
        ],
      ),
    );
  }
}

class AccountSetupSuccessWidget extends StatelessWidget {
  const AccountSetupSuccessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFEBDC),
                      border:
                          Border.all(color: const Color(0xffFFEBDC), width: .2),
                      borderRadius: BorderRadius.circular(85),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(
                              255, 230, 216, 206), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(
                              2, 3), // Offset (controls the shadow's position)
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        "assets/images/check.png",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 64,
              ),
              Text(
                "Account created successfully",
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF010029),
                  fontSize:
                      Constant.screenWidth * (24 / Constant.figmaScreenWidth),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(Constant.screenHeight * (8 / Constant.figmaScreenHeight)),
              Text(
                "Get started with the best learning experience",
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF010029),
                  fontSize:
                      Constant.screenWidth * (16 / Constant.figmaScreenWidth),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "tailormade for you.",
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF010029),
                  fontSize:
                      Constant.screenWidth * (16 / Constant.figmaScreenWidth),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
