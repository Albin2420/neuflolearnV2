import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/answeRtile.dart';

class Allfiltered extends StatelessWidget {
  const Allfiltered({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    if (ctr.qstnsAll.value.isEmpty) {
      return Text("no data found");
    } else {
      return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (buildContext, index) {
            var opt = "${ctr.qstnsAll[index].answer}";
            var finans = "";
            if (opt == "a") {
              finans = "${ctr.qstnsAll[index].options?.a}";
            } else if (opt == "b") {
              finans = "${ctr.qstnsAll[index].options?.b}";
            } else if (opt == "c") {
              finans = "${ctr.qstnsAll[index].options?.c}";
            } else {
              finans = "${ctr.qstnsAll[index].options?.d}";
            }

            log("submitted answer:${ctr.qstnsAll[index].submittedAnswer}");
            log(" answer:${ctr.qstnsAll[index].answer}");

            return AnsweRTile(
              qstn: "${ctr.qstnsAll[index].question}",
              answer: "${ctr.qstnsAll[index].answer}",
              opt: finans,
              explanation: "${ctr.qstnsAll[index].explanation}",
              submittedAns:
                  "${ctr.qstnsAll[index].submittedAnswer}".toLowerCase(),
            );
          },
          separatorBuilder: (buildContext, index) {
            return SizedBox(
              height: 10,
            );
          },
          itemCount: ctr.qstnsAll.length);
    }
  }
}
