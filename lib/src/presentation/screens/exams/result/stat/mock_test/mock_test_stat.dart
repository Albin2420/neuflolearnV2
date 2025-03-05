import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/presentation/controller/teststatus/test_status_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/practise_test/widgets/scoregrowth.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/practise_test/widgets/timegraph.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/arcloader.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/progress_graph.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/widgets/testhourcard.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/test_History.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/GradientBtn.dart';

class MockTestStat extends StatelessWidget {
  const MockTestStat({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrc = Get.find<TestStatusController>();

    return Obx(() {
      final State = ctrc.userState.value;
      if (State is Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (State is Error) {
        return Center(child: Text('ERROR'));
      } else if (State is Success) {
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
                        "Mock test stats",
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
                          '${ctrc.stdataMockTest["total_tests_attended"] ?? 0}',
                      seconds: ctrc.stdataMockTest["total_time_spent"] == null
                          ? 0.0
                          : ctrc.stdataMockTest["total_time_spent"].toDouble());
                }),
                SizedBox(
                  height: 16,
                ),
                Obx(() {
                  return ProgressGraphtile(
                    maxLimit: (ctrc.stdataMockTest['total_time_spent'] as num)
                        .toDouble(),
                    weekdata: ctrc.stdataMockTest['total_time_per_dayMap'],
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
                                  child: Image.asset(
                                      "assets/icons/done_square.png"),
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
                                                  percentage: ctrc.stdataMockTest[
                                                                  "subjectwise_correct_percentage"]
                                                              ["Physics"] ==
                                                          0
                                                      ? 0.0
                                                      : ctrc.stdataMockTest[
                                                              "subjectwise_correct_percentage"]
                                                          ["Physics"],
                                                  size: 65,
                                                  color: Color(0xff21A2FF),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Text(
                                                    "${(ctrc.stdataMockTest["subjectwise_correct_percentage"]["Physics"] ?? 0).toInt()}%",
                                                    style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  percentage: ctrc.stdataMockTest[
                                                                  "subjectwise_correct_percentage"]
                                                              ["Chemistry"] ==
                                                          0
                                                      ? 0.0
                                                      : ctrc.stdataMockTest[
                                                              "subjectwise_correct_percentage"]
                                                          ["Chemistry"],
                                                  size: 65,
                                                  color: Colors.red,
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Text(
                                                    "${(ctrc.stdataMockTest["subjectwise_correct_percentage"]["Chemistry"] ?? 0).toInt()}%",
                                                    style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  percentage: ctrc.stdataMockTest[
                                                                  "subjectwise_correct_percentage"]
                                                              ["Biology"] ==
                                                          0
                                                      ? 0.0
                                                      : ctrc.stdataMockTest[
                                                              "subjectwise_correct_percentage"]
                                                          ["Biology"],
                                                  size: 65,
                                                  color: Color(0xff9747FF),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Text(
                                                    "${(ctrc.stdataMockTest["subjectwise_correct_percentage"]["Biology"] ?? 0).toInt()}%",
                                                    style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  percentage: ctrc.stdataMockTest[
                                                                  "subjectwise_incorrect_percentage"]
                                                              ["Physics"] ==
                                                          0
                                                      ? 0.0
                                                      : ctrc.stdataMockTest[
                                                              "subjectwise_incorrect_percentage"]
                                                          ["Physics"],
                                                  size: 65,
                                                  color: Color(0xff21A2FF),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Text(
                                                    "${(ctrc.stdataMockTest["subjectwise_incorrect_percentage"]["Physics"] ?? 0).toInt()}%",
                                                    style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  percentage: ctrc.stdataMockTest[
                                                                  "subjectwise_incorrect_percentage"]
                                                              ["Chemistry"] ==
                                                          0
                                                      ? 0.0
                                                      : ctrc.stdataMockTest[
                                                              "subjectwise_incorrect_percentage"]
                                                          ["Chemistry"],
                                                  size: 65,
                                                  color: Colors.red,
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Text(
                                                    "${(ctrc.stdataMockTest["subjectwise_incorrect_percentage"]["Chemistry"] ?? 0).toInt()}%",
                                                    style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  percentage: ctrc.stdataMockTest[
                                                                  "subjectwise_incorrect_percentage"]
                                                              ["Biology"] ==
                                                          0
                                                      ? 0.0
                                                      : ctrc.stdataMockTest[
                                                              "subjectwise_incorrect_percentage"]
                                                          ["Biology"],
                                                  size: 65,
                                                  color: Color(0xff9747FF),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Text(
                                                    "${(ctrc.stdataMockTest["subjectwise_incorrect_percentage"]["Biology"] ?? 0).toInt()}%",
                                                    style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                    map: ctrc.stdataMockTest['daily_average_scoreMap'],
                    score:
                        "${(ctrc.stdataMockTest['average_score'] ?? 0).toInt()}",
                  );
                }),
                SizedBox(
                  height: 16,
                ),
                Obx(() {
                  return TimeGrowthGraph(
                      map: ctrc.stdataMockTest["daily_average_timeMap"],
                      seconds: (ctrc.stdataMockTest['average_time'] ?? 0)
                          .toDouble());
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
                            color: Color(0xff010029)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GradientButton(
                        onTap: () {
                          Get.to(() => TestHistory(), arguments: 1);
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
      } else {
        return Center(child: Text("please wait....."));
      }
    });
  }
}
