import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/test_card.dart';

class ChemistryFiltered extends StatelessWidget {
  const ChemistryFiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    return Expanded(
      child: Obx(() {
        if (ctr.chemistry.isEmpty) {
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
          itemCount: ctr.chemistry.length,
          itemBuilder: (context, index) {
            return TestCard(
              onTap: () {
                ctr.fetchDetailedHistory(
                    testId: ctr.chemistry[index].testId,
                    testName: ctr.chemistry[index].testName);
              },
              currentScore: ctr.chemistry[index].score,
              totalScore: ctr.chemistry[index].totalScore,
              testName: ctr.chemistry[index].testName,
              testDate: ctr.chemistry[index].completionDate.toString(),
            );
          },
        );
      }),
    );
  }
}
