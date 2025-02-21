import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/test_card.dart';

class MockFiltered extends StatelessWidget {
  const MockFiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    return Expanded(
      child: Obx(() {
        if (ctr.mockTest.isEmpty) {
          return const Center(
            child: Text(
              "No test history available",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ); // Show empty state message
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: ctr.mockTest.length,
          itemBuilder: (context, index) {
            return TestCard(
              onTap: () {
                ctr.fetchDetailedHistory(
                    testId: ctr.mockTest[index].testId,
                    testName: ctr.mockTest[index].testName);
              },
              currentScore: ctr.mockTest[index].score,
              totalScore: ctr.mockTest[index].totalScore,
              testName: ctr.mockTest[index].testName,
              testDate: ctr.mockTest[index].completionDate.toString(),
            );
          },
        );
      }),
    );
  }
}
