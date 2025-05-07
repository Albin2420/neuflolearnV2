import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/daily_test/daily_test_intro.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/exam.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/exam_loading.dart';
import 'package:neuflo_learn/src/presentation/widgets/failure/failureResponse.dart';

class PracticeTestExamView extends StatelessWidget {
  final String subjectName;
  final String level;
  const PracticeTestExamView({
    super.key,
    required this.subjectName,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(ExamController());

    return Obx(() {
      return ctr.examState.value.onState(
        onInitial: () =>
            DailyTestIntro(subjectName: subjectName, test_level: level),
        success: (data) {
          if (data.isEmpty) {
            return FailureUi(
              onTapFunction: () async {
                await ctr.initiatePracticeTestExam(
                  subjectName: subjectName,
                  testlevel: level,
                );
              },
            );
          }
          return Exam(level: level, type: 'PracticeTest');
        },
        onFailed: (error) {
          log("Error..................................:$error");
          return FailureUi(
            onTapFunction: () async {
              await ctr.initiatePracticeTestExam(
                subjectName: subjectName,
                testlevel: level,
              );
            },
          );
        },
        onLoading: () => Scaffold(body: ExamLoading()),
      );
    });
  }
}
