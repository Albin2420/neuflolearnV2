import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/answeRtile.dart';

class Incorrectfiltered extends StatelessWidget {
  const Incorrectfiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    if (ctr.incorrectfiltered.isEmpty) {
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
          var opt = "${ctr.incorrectfiltered[index].answer}";
          var finans = "";
          if (opt == "a") {
            finans = "${ctr.incorrectfiltered[index].options?.a}";
          } else if (opt == "b") {
            finans = "${ctr.incorrectfiltered[index].options?.b}";
          } else if (opt == "c") {
            finans = "${ctr.incorrectfiltered[index].options?.c}";
          } else {
            finans = "${ctr.incorrectfiltered[index].options?.d}";
          }

          return AnsweRTile(
            qstn: "${ctr.incorrectfiltered[index].question}",
            answer: "${ctr.incorrectfiltered[index].answer}",
            opt: finans,
            explanation: "${ctr.incorrectfiltered[index].explanation}",
            submittedAns:
                "${ctr.incorrectfiltered[index].submittedAnswer}".toLowerCase(),
          );
        },
        separatorBuilder: (buildContext, index) {
          return SizedBox(height: 10);
        },
        itemCount: ctr.incorrectfiltered.length,
      );
    }
  }
}
