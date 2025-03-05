import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/controller/navigation/navigation_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/widgets/answer_tile.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/widgets/nextstep.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/widgets/result_info.dart';
import 'package:neuflo_learn/src/presentation/screens/navigationscreen/navigationscreen.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool correct = false;
  bool All = true;
  bool incorrect = false;
  bool skipped = false;
  int index = 0;
  TextEditingController txt = TextEditingController();
  final nctr = Get.find<Navigationcontroller>();

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<ExamController>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: const Color(0x00000008),
          surfaceTintColor: Colors.white,
          elevation: 10,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              if (Get.isRegistered<Navigationcontroller>()) {
                ctr.resetAvgTimer();
                ctr.resetTimer();
                await nctr.rebuild(rebuild: true);
              }
              Get.offAll(() => NavigationScreen());
            },
            icon: Icon(Icons.close_rounded),
          ),
          title: Column(
            children: [
              Text(
                "Test results",
                style: GoogleFonts.urbanist(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF010029),
                ),
              ),
              Text(
                ctr.currentSubjectName,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF010029),
                ),
              ),
            ],
          ),
          flexibleSpace: Column(
            children: [
              const Spacer(),
              Container(
                height: 1,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 1),
                  ),
                ]),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Getting Better!',
                          style: GoogleFonts.urbanist(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF010029),
                          ),
                        ),
                        Text(
                          "Check out your detailed test results.",
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                const Color(0xFF010029).withValues(alpha: 0.5),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Obx(
                    () => ResultInfo(
                      timeTaken:
                          '${ctr.examReportState.value.value?.timeTaken}',
                      sCore: '${ctr.examReportState.value.value?.score ?? '0'}',
                      rAnk: '${ctr.examReportState.value.value?.rank ?? '0'}',
                      correct: '${ctr.correctList.length}',
                      incorrect: '${ctr.inCorrectList.length}',
                      unAttempted: '${ctr.skippedValue} ',
                      perCentage:
                          '${(ctr.examReportState.value.value?.percentage)?.toInt()}',
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Nextstep(
                    onFinishDailyTests: () async {
                      if (Get.isRegistered<Navigationcontroller>()) {
                        ctr.resetAvgTimer();
                        ctr.resetTimer();
                        await nctr.rebuild(rebuild: true);
                        Get.offAll(() => NavigationScreen());
                      }
                    },
                    onSetTestReminders: () {
                      log("onSetTestRemindersTap");
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your answers",
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff01002980)
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            // CustomTextField(
                            //   hintText: 'Search topic',
                            //   textEditingController: txt,
                            //   prefixIcon: PhosphorIcons.magnifyingGlass(),
                            // ),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            Container(
                              padding: EdgeInsets.all(Constant.screenWidth *
                                  (4 / Constant.figmaScreenWidth)),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(
                                    color: Color(0xff02012a1a)
                                        .withValues(alpha: 0.1)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => Container(
                                        decoration: BoxDecoration(
                                          color: ctr.filterStatus.value == "All"
                                              ? const Color(0xFF010029)
                                              : const Color(0xFFFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(128),
                                        ),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(128),
                                          onTap: () async {
                                            ctr.filterAll();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(128),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  "All",
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: Constant
                                                            .screenHeight *
                                                        (14 /
                                                            Constant
                                                                .figmaScreenHeight),
                                                    fontWeight: FontWeight.w400,
                                                    color: ctr.filterStatus
                                                                .value ==
                                                            "All"
                                                        ? const Color(
                                                            0xFFFFFFFF)
                                                        : const Color(
                                                            0xFF010029),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(() => Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(128),
                                            color: ctr.filterStatus.value ==
                                                    "Correct"
                                                ? const Color(0xFF010029)
                                                : const Color(0xFFFFFFFF),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(128),
                                              onTap: () {
                                                ctr.filterCorrect();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          128),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      "Correct",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                        fontSize: Constant
                                                                .screenHeight *
                                                            (14 /
                                                                Constant
                                                                    .figmaScreenHeight),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ctr.filterStatus
                                                                    .value ==
                                                                "Correct"
                                                            ? const Color(
                                                                0xFFFFFFFF)
                                                            : const Color(
                                                                0xFF010029),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Obx(
                                      () => Container(
                                        decoration: BoxDecoration(
                                          color: ctr.filterStatus.value ==
                                                  "Incorrect"
                                              ? const Color(0xFF010029)
                                              : const Color(0xFFFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(128),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(128),
                                            onTap: () {
                                              ctr.filterInCorrect();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(128),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    "Incorrect",
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: Constant
                                                              .screenHeight *
                                                          (14 /
                                                              Constant
                                                                  .figmaScreenHeight),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ctr.filterStatus
                                                                  .value ==
                                                              "Incorrect"
                                                          ? const Color(
                                                              0xFFFFFFFF)
                                                          : const Color(
                                                              0xFF010029),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(() => Container(
                                          decoration: BoxDecoration(
                                            color: ctr.filterStatus.value ==
                                                    "Skipped"
                                                ? const Color(0xFF010029)
                                                : const Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(128),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(128),
                                              onTap: () {
                                                ctr.filterSkipped();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          128),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      "Skipped",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                        fontSize: Constant
                                                                .screenHeight *
                                                            (14 /
                                                                Constant
                                                                    .figmaScreenHeight),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ctr.filterStatus
                                                                    .value ==
                                                                "Skipped"
                                                            ? const Color(
                                                                0xFFFFFFFF)
                                                            : const Color(
                                                                0xFF010029),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Obx(() {
                    if (ctr.questionList.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Center(child: Text("Nothing found")),
                      );
                    } else {
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: ctr.questionList.length,
                        itemBuilder: (BuildContext context, index) {
                          var opt = "${ctr.questionList[index].answer}";
                          var finans = "";
                          if (opt == "a") {
                            finans = "${ctr.questionList[index].options?.a}";
                          } else if (opt == "b") {
                            finans = "${ctr.questionList[index].options?.b}";
                          } else if (opt == "c") {
                            finans = "${ctr.questionList[index].options?.c}";
                          } else {
                            finans = "${ctr.questionList[index].options?.d}";
                          }
                          log("final ans:$finans");
                          return Padding(
                            padding: EdgeInsets.only(bottom: 32),
                            child: AnswerTile(
                              correctOpt: finans,
                              qsTn: '${ctr.questionList[index].question}',
                              qID: '${ctr.questionList[index].questionId}',
                              answer: ctr.questionList[index].explanation ?? '',
                              correctAnswer:
                                  ctr.questionList[index].answer ?? '',
                              incorrectAnswer:
                                  '${ctr.questionList[index].selectedOption}',
                            ),
                          );
                        },
                      );
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
