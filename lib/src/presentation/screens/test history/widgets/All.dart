import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/test_card.dart';

import '../../../controller/test history/test_history_controller.dart';

class All extends StatelessWidget {
  const All({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    return Expanded(
      flex: 3,
      child: Obx(() {
        if (ctr.testHistorys.isEmpty) {
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
          itemCount: ctr.testHistorys.length,
          itemBuilder: (context, index) {
            return TestCard(
              onTap: () {
                ctr.fetchDetailedHistory(
                    testId: ctr.testHistorys[index].testId,
                    testName: ctr.testHistorys[index].testName);
              },
              currentScore: ctr.testHistorys[index].score,
              totalScore: ctr.testHistorys[index].totalScore,
              testName: ctr.testHistorys[index].testName,
              testDate: ctr.testHistorys[index].completionDate.toString(),
            );
          },
        );
      }),
    );
  }
}
