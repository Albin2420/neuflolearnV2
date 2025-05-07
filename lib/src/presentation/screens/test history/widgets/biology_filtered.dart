import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/test_card.dart';

class BiologyFiltered extends StatelessWidget {
  const BiologyFiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    return Expanded(
      child: Obx(() {
        if (ctr.biology.isEmpty) {
          return const Center(
            child: Text(
              "No test history available",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ); // Show empty state message
        }

        return ListView.builder(
          itemCount: ctr.biology.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: TestCard(
                onTap: () {
                  ctr.fetchDetailedHistory(
                    testId: ctr.biology[index].testId,
                    testName: ctr.biology[index].testName,
                  );
                },
                currentScore: ctr.biology[index].score,
                totalScore: ctr.biology[index].totalScore,
                testName: ctr.biology[index].testName,
                testDate: ctr.biology[index].completionDate.toString(),
              ),
            );
          },
        );
      }),
    );
  }
}
