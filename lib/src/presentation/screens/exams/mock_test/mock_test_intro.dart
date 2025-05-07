import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/mock_test/widgets/mock_test_exam_criteria.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';

class MockTestIntro extends StatelessWidget {
  const MockTestIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<ExamController>();
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
          "Mock Test",
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, bottom: 40),
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: Image.asset("assets/icons/mocktest.png"),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      right: 12,
                      left: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kOrange,
                      borderRadius: BorderRadius.circular(56),
                    ),
                    height: 25,
                    child: Text(
                      'intermediate',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Mock Test",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        "NEET mock test",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xff02013B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MocktestExamcriteria(
              timeLimit: '3hr time limit',
              noOfQuestion: '200',
              // negativeMark: '-1 for incorrect ans',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        height: 100,
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppBtn(
              btnName: 'Start Test',
              onTapFunction: () async {
                log("mocktest begins");
                ctr.instantEvaluvation.value = false;
                ctr.timeLimit.value = true;
                ctr.targetSecond.value = 10800;
                await ctr.initiatemockTest();
              },
              iconImg: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}
