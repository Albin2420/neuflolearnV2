import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/custom_test/custom_test_controller.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/custom_test_intro.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/exam.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/exam_loading.dart';
import 'package:neuflo_learn/src/presentation/widgets/failure/failureResponse.dart';

class CustomTestExamView extends StatelessWidget {
  const CustomTestExamView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(ExamController());
    final customctr = Get.put(CustomTestController());
    return Obx(() {
      return ctr.examState.value.onState(
        onInitial: () => CustomTestIntro(),
        success: (data) {
          log('CustomTestExamView => $data');

          if (data.isEmpty) {
            return CustomTestIntro();
          }
          return Exam(
            level: '',
            type: 'customTest',
          );
          // return CustomTestIntro();
        },
        onFailed: (error) {
          return FailureUi(onTapFunction: () async {
            await ctr.initiateCustomTestExam(
              physicsChapters: customctr.physicsSelectedChapters,
              chemistryChapters: customctr.chemistrySelectedChapters,
              biologyChapters: customctr.biologySelectedChapters,
              noOfQuestions: customctr.questionCount.value,
            );
          });
        },
        onLoading: () => Scaffold(body: ExamLoading()),
      );
    });
  }
}
