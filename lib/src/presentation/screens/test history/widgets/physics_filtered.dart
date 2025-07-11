import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/test_card.dart';

class PhysicsFiltered extends StatelessWidget {
  const PhysicsFiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    return Expanded(
      child: Obx(() {
        if (ctr.physics.isEmpty) {
          return const Center(
            child: Text(
              "No test history available",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ); // Show empty state message
        }

        return ListView.builder(
          itemCount: ctr.physics.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: TestCard(
                onTap: () {
                  ctr.fetchDetailedHistory(
                    testId: ctr.physics[index].testId,
                    testName: ctr.physics[index].testName,
                  );
                },
                currentScore: ctr.physics[index].score,
                totalScore: ctr.physics[index].totalScore,
                testName: ctr.physics[index].testName,
                testDate: ctr.physics[index].completionDate.toString(),
              ),
            );
          },
        );
      }),
    );
  }
}
