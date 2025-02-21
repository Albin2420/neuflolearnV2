import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/setup_account/setup_account_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/widgets/course_card.dart';

class TargetCourse extends StatelessWidget {
  const TargetCourse({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<SetupAccountController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctr.fetchCourses();
    });
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "What course are you aiming for?",
            style: GoogleFonts.urbanist(
              fontSize:
                  Constant.screenHeight * (24 / Constant.figmaScreenHeight),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF010029),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "This will help us curate the best learning experience for you.",
            style: GoogleFonts.urbanist(
              fontSize:
                  Constant.screenHeight * (16 / Constant.figmaScreenHeight),
              fontWeight: FontWeight.w400,
              color: const Color(0x99010029),
            ),
            textAlign: TextAlign.center,
          ),
          Gap(Constant.screenHeight * (32 / Constant.figmaScreenHeight)),
          Obx(() {
            return ctr.courseState.value.onState(
              onInitial: () => const SizedBox(),
              success: (data) => ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: Constant.screenHeight *
                            (12 / Constant.figmaScreenHeight)),
                    child: CourseCard(
                      course: data[index],
                      title: data[index].courseName ?? '',
                      message: '${data[index].duration.toString()} years',
                      description: data[index].courseDescription,
                      color: const Color(0xff02012A),
                      showBottomSheet: false,
                    ),
                  );
                },
              ),
              onFailed: (error) => Center(
                  child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF010029),
                ),
              )),
              onLoading: () => Center(
                child: Transform.scale(
                  scale: 0.5,
                  child: const CircularProgressIndicator(),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
