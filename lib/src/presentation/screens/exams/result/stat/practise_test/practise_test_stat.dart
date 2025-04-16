import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

import 'package:neuflo_learn/src/presentation/controller/teststatus/test_status_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/practise_test/widgets/scoregrowth.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/practise_test/widgets/timegraph.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/arcloader.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/progress_graph.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/widgets/testhourcard.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/test_History.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/GradientBtn.dart';

class PractiseTestStat extends StatelessWidget {
  const PractiseTestStat({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestStatusController>();
    return Obx(() {
      final state = ctr.statState.value;
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text(
                      "Practice test stats",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Obx(() {
                return Testhourcard(
                    testAttended:
                        '${ctr.stdataPracticeTest["total_tests_attended"]}',
                    seconds: ctr.stdataPracticeTest["total_time_spent"] == 0
                        ? 0.0
                        : ctr.stdataPracticeTest["total_time_spent"]);
              }),
              SizedBox(
                height: 16,
              ),
              Obx(() {
                return ProgressGraphtile(
                  maxLimit: (ctr.stdataPracticeTest['total_time_spent'] as num)
                      .toDouble(),
                  weekdata: ctr.stdataPracticeTest['total_time_per_dayMap'],
                );
              }),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F000000),
                      offset: Offset(0, 2),
                      blurRadius: 5.8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 124,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    Image.asset("assets/icons/done_square.png"),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "average correct answers",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.kgreen,
                                ),
                              )
                            ],
                          ),
                          Obx(() {
                            return Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ArcGraph(
                                                percentage: ctr.stdataPracticeTest[
                                                                "subjectwise_correct_percentage"]
                                                            ["Physics"] ==
                                                        0
                                                    ? 0.0
                                                    : ctr.stdataPracticeTest[
                                                            "subjectwise_correct_percentage"]
                                                        ["Physics"],
                                                size: 65,
                                                color: Color(0xff21A2FF),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Text(
                                                  "${(ctr.stdataPracticeTest["subjectwise_correct_percentage"]["Physics"] ?? 0).toInt()}%",
                                                  style: GoogleFonts.urbanist(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Physics",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xff010029),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ArcGraph(
                                                percentage: ctr.stdataPracticeTest[
                                                                "subjectwise_correct_percentage"]
                                                            ["Chemistry"] ==
                                                        0
                                                    ? 0.0
                                                    : ctr.stdataPracticeTest[
                                                            "subjectwise_correct_percentage"]
                                                        ["Chemistry"],
                                                size: 65,
                                                color: Colors.red,
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Text(
                                                  "${(ctr.stdataPracticeTest["subjectwise_correct_percentage"]["Chemistry"] ?? 0).toInt()}%",
                                                  style: GoogleFonts.urbanist(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Chemistry",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xff010029),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ArcGraph(
                                                percentage: ctr.stdataPracticeTest[
                                                                "subjectwise_correct_percentage"]
                                                            ["Biology"] ==
                                                        0
                                                    ? 0.0
                                                    : ctr.stdataPracticeTest[
                                                            "subjectwise_correct_percentage"]
                                                        ["Biology"],
                                                size: 65,
                                                color: Color(0xff9747FF),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Text(
                                                  "${(ctr.stdataPracticeTest["subjectwise_correct_percentage"]["Biology"] ?? 0).toInt()}%",
                                                  style: GoogleFonts.urbanist(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Biology",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xff010029),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 124,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 18,
                                width: 18,
                                child: Image.asset(
                                    "assets/icons/wrong_square.png"),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "average incorrect answers",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.kred,
                                ),
                              )
                            ],
                          ),
                          Obx(() {
                            return Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ArcGraph(
                                                percentage: ctr.stdataPracticeTest[
                                                                "subjectwise_incorrect_percentage"]
                                                            ["Physics"] ==
                                                        0
                                                    ? 0.0
                                                    : ctr.stdataPracticeTest[
                                                            "subjectwise_incorrect_percentage"]
                                                        ["Physics"],
                                                size: 65,
                                                color: Color(0xff21A2FF),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Text(
                                                  "${(ctr.stdataPracticeTest["subjectwise_incorrect_percentage"]["Physics"] ?? 0).toInt()}%",
                                                  style: GoogleFonts.urbanist(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Physics",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xff010029),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ArcGraph(
                                                percentage: ctr.stdataPracticeTest[
                                                                "subjectwise_incorrect_percentage"]
                                                            ["Chemistry"] ==
                                                        0
                                                    ? 0.0
                                                    : ctr.stdataPracticeTest[
                                                            "subjectwise_incorrect_percentage"]
                                                        ["Chemistry"],
                                                size: 65,
                                                color: Colors.red,
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Text(
                                                  "${(ctr.stdataPracticeTest["subjectwise_incorrect_percentage"]["Chemistry"] ?? 0).toInt()}%",
                                                  style: GoogleFonts.urbanist(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Chemistry",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xff010029),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ArcGraph(
                                                percentage: ctr.stdataPracticeTest[
                                                                "subjectwise_incorrect_percentage"]
                                                            ["Biology"] ==
                                                        0
                                                    ? 0.0
                                                    : ctr.stdataPracticeTest[
                                                            "subjectwise_incorrect_percentage"]
                                                        ["Biology"],
                                                size: 65,
                                                color: Color(0xff9747FF),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Text(
                                                  "${(ctr.stdataPracticeTest["subjectwise_incorrect_percentage"]["Biology"] ?? 0).toInt()}%",
                                                  style: GoogleFonts.urbanist(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Biology",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xff010029),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Obx(() {
                return Scoregrowthgraph(
                  scorePercentage:
                      (ctr.stdataPracticeTest['score_change'] ?? 0).toDouble(),
                  // '${(ctr.stdataPracticeTest['score_change'] ?? 0).toInt()}',
                  score:
                      "${(ctr.stdataPracticeTest['average_score'] ?? 0).toInt()}",
                  map: ctr.stdataPracticeTest['daily_average_scoreMap'],
                );
              }),
              SizedBox(
                height: 16,
              ),
              Obx(() {
                return TimeGrowthGraph(
                  timegrowthPercentage:
                      (ctr.stdataPracticeTest['time_change'] ?? 0).toDouble(),
                  seconds: (ctr.stdataPracticeTest["average_time"] as num)
                      .toDouble(),
                  map: ctr.stdataPracticeTest["daily_average_timeMap"],
                );
              }),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Want to see your performance in previous tests?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff010029),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GradientButton(
                      onTap: () {
                        Get.to(() => TestHistory(), arguments: 3);
                      },
                      text: 'view your Detailed test history',
                      iconPath: 'assets/icons/timer5.png',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      );
    });
  }
}
