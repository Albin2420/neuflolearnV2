import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/exam.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/exam_loading.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/mock_test/mock_test_intro.dart';
import 'package:neuflo_learn/src/presentation/widgets/failure/failureResponse.dart';

class MockTestExamView extends StatelessWidget {
  const MockTestExamView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(ExamController());
    return Obx(() {
      return ctr.examState.value.onState(
        onInitial: () => MockTestIntro(),
        success: (data) {
          if (data.isEmpty) {
            return FailureUi(onTapFunction: () {
              ctr.instantEvaluvation.value = false;
              ctr.timeLimit.value = true;
              ctr.targetSecond.value = 10800;
              ctr.initiatemockTest();
            });
          }
          return Exam(
            level: '',
            type: 'mocktest',
          );
        },
        onFailed: (error) {
          return FailureUi(onTapFunction: () {
            ctr.instantEvaluvation.value = false;
            ctr.timeLimit.value = true;
            ctr.targetSecond.value = 10800;
            ctr.initiatemockTest();
          });
        },
        onLoading: () => Scaffold(body: ExamLoading()),
      );
    });
  }
}
