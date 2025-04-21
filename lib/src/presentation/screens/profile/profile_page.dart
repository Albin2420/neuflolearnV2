import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/auth/auth_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/intro/intro.dart';
import 'package:neuflo_learn/src/presentation/screens/profile/widgets/profile_info.dart';
import 'package:neuflo_learn/src/presentation/screens/profile/widgets/profile_info_stats.dart';
import 'package:neuflo_learn/src/presentation/screens/profile/widgets/profile_loading.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/appBtnOutline.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
import 'package:neuflo_learn/src/presentation/widgets/failure/failureResponse.dart';

import '../../controller/profile/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<AppStartupController>();
    final authCtr = Get.put(AuthController());
    final prctr = Get.put(ProfileController());
    return Obx(() {
      return prctr.profileState.value.onState(onInitial: () {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: ProfiLeLoading(),
        );
      }, success: (succsess) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              'Profile',
              style: GoogleFonts.urbanist(
                color: const Color(0xFF010029),
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 18),
                Obx(() => ProfileInfoWidget(
                      name: ctr.appUser.value?.name ?? '',
                      email: ctr.appUser.value?.email ?? "",
                      imagePath: ctr.appUser.value?.imageUrl ?? '',
                      studentType: 'Student',
                    )),
                const SizedBox(height: 18),
                Obx(() {
                  return ProfileStatsWidget(
                    toTalPercentage: prctr.totalPerc.value,
                    sec: prctr.sec.value,
                    dataMap: {
                      'Physics': prctr.phySics.value,
                      'Chemistry': prctr.chemIstry.value,
                      'Biology': prctr.bioLogy.value,
                    },
                  );
                }),
                const SizedBox(height: 18),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(
              vertical:
                  Constant.screenHeight * (16 / Constant.figmaScreenHeight),
              horizontal:
                  Constant.screenWidth * (16 / Constant.figmaScreenWidth),
            ),
            child: Row(
              children: [
                Flexible(
                  child: AppBtn(
                    colors: [
                      Color.fromARGB(255, 197, 48, 48),
                      Color.fromARGB(255, 223, 39, 36),
                    ],
                    btnName: 'Delete Account',
                    onTapFunction: () async {
                      showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Confirm Deletion",
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xff010029),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Text(
                                    "Do you really want to delete your account?",
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xff010029),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: AppBtn(
                                          colors: [
                                            Color.fromARGB(255, 197, 48, 48),
                                            Color.fromARGB(255, 223, 39, 36),
                                          ],
                                          btnName: "Delete",
                                          onTapFunction: () async {
                                            EasyLoading.show();

                                            await authCtr.deleteUserAccount();

                                            if (authCtr.isAccountDeleteComplete
                                                    .value ==
                                                true) {
                                              EasyLoading.dismiss();
                                              Get.offAll(() => IntroScreen());
                                            }

                                            if (authCtr.isAccountDeleteComplete
                                                    .value ==
                                                false) {
                                              EasyLoading.dismiss();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Account Deletion Completed With Error, Try again');
                                              return;
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Flexible(
                                        child: AppBtnOutLine(
                                          isOutline: true,
                                          btnName: 'Cancel',
                                          onTapFunction: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: AppBtn(
                    btnName: 'Signout',
                    onTapFunction: () async {
                      showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Signout",
                                        style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Color(0xff010029),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    "Are You Sure?",
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xff010029),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: AppBtn(
                                          btnName: "yes",
                                          onTapFunction: () async {
                                            await authCtr.signOut();
                                            Get.offAll(IntroScreen());
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Flexible(
                                        child: AppBtnOutLine(
                                          isOutline: true,
                                          btnName: 'Cancel',
                                          onTapFunction: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }, onFailed: (failed) {
        return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: FailureUi(onTapFunction: () {
              prctr.fetchweekgrowth();
            }));
      }, onLoading: () {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: ProfiLeLoading(),
        );
      });
    });
  }
}
