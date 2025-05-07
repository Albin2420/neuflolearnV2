import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/answeRtile.dart';

class SkippedFiltered extends StatelessWidget {
  const SkippedFiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    if (ctr.skipped.isEmpty) {
      return SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Center(child: Text("answers is emprty")),
      );
    } else {
      return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (buildContext, index) {
          var opt = "${ctr.skipped[index].answer}";
          var finans = "";
          if (opt == "a") {
            finans = "${ctr.skipped[index].options?.a}";
          } else if (opt == "b") {
            finans = "${ctr.skipped[index].options?.b}";
          } else if (opt == "c") {
            finans = "${ctr.skipped[index].options?.c}";
          } else {
            finans = "${ctr.skipped[index].options?.d}";
          }

          return AnsweRTile(
            qstn: "${ctr.skipped[index].question}",
            answer: "${ctr.skipped[index].answer}",
            opt: finans,
            explanation: "${ctr.skipped[index].explanation}",
            submittedAns: "${ctr.skipped[index].submittedAnswer}".toLowerCase(),
          );
        },
        separatorBuilder: (buildContext, index) {
          return SizedBox(height: 10);
        },
        itemCount: ctr.skipped.length,
      );
    }
  }
}
