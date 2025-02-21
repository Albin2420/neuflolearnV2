import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/exam.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/exam_loading.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/mock_test/mock_test_intro.dart';

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
            return MockTestIntro();
          }
          return Exam(
            level: '',
            type: 'mocktest',
          );
        },
        onFailed: (error) {
          return MockTestIntro();
        },
        onLoading: () => Scaffold(body: ExamLoading()),
      );
    });
  }
}
