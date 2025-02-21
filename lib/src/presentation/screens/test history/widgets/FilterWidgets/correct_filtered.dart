import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/answeRtile.dart';

class CorrectFiltered extends StatelessWidget {
  const CorrectFiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    if (ctr.correctfiltered.isEmpty) {
      return SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text("answers is emprty"),
        ),
      );
    } else {
      return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (buildContext, index) {
            var opt = "${ctr.correctfiltered[index].answer}";
            var finans = "";
            if (opt == "a") {
              finans = "${ctr.correctfiltered[index].options?.a}";
            } else if (opt == "b") {
              finans = "${ctr.correctfiltered[index].options?.b}";
            } else if (opt == "c") {
              finans = "${ctr.correctfiltered[index].options?.c}";
            } else {
              finans = "${ctr.correctfiltered[index].options?.d}";
            }

            return AnsweRTile(
              qstn: "${ctr.correctfiltered[index].question}",
              answer: "${ctr.correctfiltered[index].answer}",
              opt: finans,
              explanation: "${ctr.correctfiltered[index].explanation}",
              submittedAns:
                  "${ctr.correctfiltered[index].submittedAnswer}".toLowerCase(),
            );
          },
          separatorBuilder: (buildContext, index) {
            return SizedBox(
              height: 10,
            );
          },
          itemCount: ctr.correctfiltered.length);
    }
  }
}
