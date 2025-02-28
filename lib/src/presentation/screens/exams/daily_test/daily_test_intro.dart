// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/daily_test/widgets/daily_test_exam_criteria.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';

class DailyTestIntro extends StatelessWidget {
  final String subjectName;
  final String test_level;

  const DailyTestIntro({
    super.key,
    required this.subjectName,
    required this.test_level,
  });

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
        title: Column(
          children: [
            Text(
              "Daily Test",
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF010029),
              ),
            ),
            Text(
              subjectName,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xFF010029).withOpacity(0.5),
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
              padding: EdgeInsets.only(top: 40, bottom: 40),
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: Image.asset(subjectName == "Physics"
                        ? "assets/icons/physics.png"
                        : subjectName == "Chemistry"
                            ? 'assets/icons/chemistry.png'
                            : 'assets/icons/biology.png'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      Text(
                        subjectName,
                        style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w700, fontSize: 32),
                      ),
                      Text(
                        "Daily practice test",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xff02013B),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            DailytestExamcriteria(
              timeLimit: 'No time limit',
              noOfQuestion: '30',
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
                try {
                  ctr.setSubjectName(subj: subjectName);
                  await ctr.initiatePracticeTestExam(
                      subjectName: subjectName, testlevel: test_level);
                } catch (e) {
                  log("error in Start Test:$e");
                }
              },
              iconImg: Icons.arrow_forward,
            )
          ],
        ),
      ),
    );
  }
}
