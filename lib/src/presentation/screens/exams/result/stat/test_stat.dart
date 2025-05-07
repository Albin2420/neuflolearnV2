import "dart:developer";

import "package:flutter/material.dart";
import "package:get/get_core/src/get_main.dart";
import "package:get/get_instance/get_instance.dart";
import "package:get/get_state_manager/get_state_manager.dart";
import "package:google_fonts/google_fonts.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:neuflo_learn/src/core/data_state/data_state.dart";
import "package:neuflo_learn/src/presentation/controller/teststatus/test_status_controller.dart";
import "package:neuflo_learn/src/presentation/screens/exams/result/stat/chapters/stat_chapter.dart";
import "package:neuflo_learn/src/presentation/screens/exams/result/stat/mock_test/mock_test_stat.dart";
import "package:neuflo_learn/src/presentation/screens/exams/result/stat/practise_test/practise_test_stat.dart";
import "package:neuflo_learn/src/presentation/widgets/failure/failureResponse.dart";

class TestStat extends StatelessWidget {
  const TestStat({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(TestStatusController());
    return Obx(() {
      if (ctr.statState.value is Loading) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Color(0xFF010029),
              size: 45,
            ),
          ),
        );
      } else if (ctr.statState.value is Success) {
        return SizedBox(
          // backgroundColor: Color(0xffEDF1F2),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0,
                        color: Color(0x08000000),
                      ),
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 3,
                        spreadRadius: 0,
                        color: Color(0x05000000),
                      ),
                      BoxShadow(
                        offset: Offset(1, 6),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Color(0x03000000),
                      ),
                      BoxShadow(
                        offset: Offset(2, 11),
                        blurRadius: 5,
                        spreadRadius: 0,
                        color: Color(0x00000000),
                      ),
                      BoxShadow(
                        offset: Offset(3, 17),
                        blurRadius: 5,
                        spreadRadius: 0,
                        color: Color(0x00000000),
                      ),
                    ],
                  ),
                  height: 101,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 53,
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              Text(
                                "Test stats",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xff010029),
                                ),
                              ),
                              Text(
                                "statistics and analytics",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(
                                    0xff010029,
                                  ).withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ctr.changePageIndex(0);
                                },
                                child: Obx(() {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 2,
                                          color: ctr.currentPageIndex.value == 0
                                              ? Color(0xff02012A)
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Practice Test",
                                        style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: ctr.currentPageIndex.value == 0
                                              ? Color(0xff02012A)
                                              : Color(
                                                  0xff010029,
                                                ).withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ctr.changePageIndex(1);
                                },
                                child: Obx(() {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 2,
                                          color: ctr.currentPageIndex.value == 1
                                              ? Color(0xff02012A)
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Mock Test",
                                        style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: ctr.currentPageIndex.value == 1
                                              ? Color(0xff02012A)
                                              : Color(
                                                  0xff010029,
                                                ).withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ctr.changePageIndex(2);
                                },
                                child: Obx(() {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 2,
                                          color: ctr.currentPageIndex.value == 2
                                              ? Color(0xff02012A)
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Chapters",
                                        style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: ctr.currentPageIndex.value == 2
                                              ? Color(0xff02012A)
                                              : Color(
                                                  0xff010029,
                                                ).withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    pageSnapping: false,
                    controller: ctr.pageController,
                    onPageChanged: (index) {
                      ctr.changePageIndex(index);
                    },
                    children: [
                      PractiseTestStat(),
                      MockTestStat(),
                      StatChapter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return FailureUi(
          onTapFunction: () {
            log("go for it");
            ctr.weeklystats();
          },
        );
      }
    });
  }
}
