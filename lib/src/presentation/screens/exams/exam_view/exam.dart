// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/option_tile.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/result.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/next_prev_btn.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tex_text/tex_text.dart';

import '../../../widgets/app_btn/exam_button.dart';

class Exam extends StatelessWidget {
  final String level;
  final String type;
  const Exam({super.key, required this.level, required this.type});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<ExamController>();

    ctr.startAvgTimer();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xff0000001a).withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 56,
                    // color: Colors.green,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: SizedBox(
                                    // height: Constant.screenHeight *
                                    //     (242 / Constant.figmaScreenHeight),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Are you sure about exiting?',
                                          style: GoogleFonts.urbanist(
                                            color: const Color(0xFF010029),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'You wont be able to come back to this and will have to start over.',
                                          style: GoogleFonts.urbanist(
                                            color: const Color(
                                              0xFF010029,
                                            ).withValues(alpha: 0.5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(
                                          Constant.screenHeight *
                                              (24 / Constant.figmaScreenHeight),
                                        ),
                                        CustomBtn3(
                                          btnName:
                                              'Yes i want to submit & exit',
                                          vpad: 12,
                                          hpad: 12,
                                          onTapFunction: () async {
                                            Get.back();
                                            // ctr.resetExamValues();
                                            // Get.offAll(
                                            //     () => NavigationScreen());
                                            EasyLoading.show();
                                            ctr.skippedCount();
                                            bool x1;
                                            x1 = await ctr.generateExamReport(
                                              level: level,
                                              type: type,
                                            );

                                            if (x1) {
                                              EasyLoading.dismiss();
                                              Get.to(() => ResultPage());
                                            } else {
                                              EasyLoading.dismiss();
                                              Fluttertoast.showToast(
                                                msg: ctr.examReportState.value
                                                        .error ??
                                                    'something went wrong',
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          },
                                        ),
                                        Gap(
                                          Constant.screenHeight *
                                              (8 / Constant.figmaScreenHeight),
                                        ),
                                        CustomBtn4(
                                          btnName:
                                              'No, I want to finish the test',
                                          vpad: 12,
                                          hpad: 12,
                                          onTapFunction: () {
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: Icon(Icons.close),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(boxShadow: []),
                            padding: EdgeInsets.only(bottom: 8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const ScrollPhysics(),
                              child: Row(
                                children: [
                                  for (int i = 0;
                                      i < ctr.questionList.length;
                                      i++)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => Icon(
                                            color: ctr.flagList.contains(i)
                                                ? Color(0xff02012A)
                                                : Colors.transparent,
                                            PhosphorIcons.flagPennant(
                                              PhosphorIconsStyle.fill,
                                            ),
                                            size: 17,
                                          ),
                                        ),
                                        Obx(
                                          () => Container(
                                            padding: EdgeInsets.only(
                                              top: 2,
                                              right: 2,
                                              left: 2,
                                              bottom: 2,
                                            ),
                                            width: 30,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              border: Border.all(
                                                color: i == ctr.page.value
                                                    ? Color(0xff010029)
                                                    : Colors.transparent,
                                              ),
                                            ),
                                            child: Container(
                                              width: 20,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(34),
                                                color: ctr.instantEvaluvation
                                                        .value
                                                    ? ctr.correctList
                                                            .contains(i)
                                                        ? Colors.green
                                                        : ctr.inCorrectList
                                                                .contains(i)
                                                            ? Colors.red
                                                            : ctr.flagList
                                                                    .contains(i)
                                                                ? Color(
                                                                    0xffCCCCD4)
                                                                : Color(
                                                                    0xff010029)
                                                    : ctr.flagList.contains(
                                                        i,
                                                      )
                                                        ? Color(0xffCCCCD4)
                                                        : Color(0xff010029),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                "${ctr.currentQuestionIndex}",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              "/${ctr.questionList.length}",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NextPrevBtn(
                          iconImg: 'assets/icons/prev.png',
                          onTapFunction: () {
                            ctr.gotoPrev();
                            ctr.skippedCount();
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ctr.toggleIsxapanded();
                              ctr.resetAvgTimer();
                            },
                            child: SizedBox(
                              height: 56,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Text(
                                      "Question ${ctr.page.value + 1}",
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Image.asset(
                                      scale: 2,
                                      "assets/icons/down.png",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        NextPrevBtn(
                          iconImg: 'assets/icons/next3.png',
                          onTapFunction: () {
                            //check whether already attended or not;
                            log("index::${ctr.page.value}");

                            if (ctr.page.value == ctr.questionList.length - 1) {
                              log("lst page");
                            } else {
                              if (ctr.answerMap.containsKey(
                                  "${ctr.questionList[ctr.page.value].questionId}")) {
                                log("already submitted");
                                ctr.gotoNext();
                                ctr.resetAvgTimer();
                              } else if (!ctr.skippedList
                                  .contains(ctr.page.value)) {
                                ctr.generateSkippedList(
                                    index: ctr.page.value,
                                    id: "${ctr.questionList[ctr.page.value].questionId}");
                                ctr.gotoNext();
                                ctr.resetAvgTimer();
                              } else {
                                log("bit confused");
                                ctr.gotoNext();
                                ctr.resetAvgTimer();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return ctr.isExpanded.value == true
                        ? AnimatedContainer(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x07000000),
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            height: ctr.isExpanded.value
                                ? Constant.screenHeight * 0.26
                                : 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  left: BorderSide(
                                    color: Color.fromARGB(137, 0, 0, 0),
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(137, 0, 0, 0),
                                  ),
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(137, 0, 0, 0),
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Constant.screenWidth *
                                      (16 / Constant.figmaScreenWidth),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisSpacing: 4,
                                            crossAxisSpacing: 4,
                                            crossAxisCount: 7,
                                          ),
                                          itemCount: ctr.questionList.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                ctr.toggleIsxapanded();
                                                ctr.gotoPage(pageIndex: index);
                                                ctr.indexupdate(index: index);
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        ctr.flagList.contains(
                                                      index,
                                                    )
                                                            ? Color(0xff010029)
                                                            : Colors.white,
                                                  ),
                                                  color: ctr.instantEvaluvation
                                                          .value
                                                      ? ctr.correctList
                                                              .contains(index)
                                                          ? Colors.green
                                                          : ctr.inCorrectList
                                                                  .contains(
                                                                      index)
                                                              ? Colors.red
                                                              : ctr.flagList
                                                                      .contains(
                                                                          index)
                                                                  ? Color(
                                                                      0xffCCCCD4)
                                                                  : Color(
                                                                      0xff010029)
                                                      : ctr.flagList.contains(
                                                          index,
                                                        )
                                                          ? Color(0xffCCCCD4)
                                                          : Color(0xff010029),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 15,
                                                      color: ctr.correctList
                                                              .contains(index)
                                                          ? Colors.white
                                                          : ctr.inCorrectList
                                                                  .contains(
                                                                      index)
                                                              ? Colors.white
                                                              : ctr.flagList
                                                                      .contains(
                                                                          index)
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Gap(
                                      Constant.screenWidth *
                                          (32 / Constant.figmaScreenWidth),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox();
                  }),
                ],
              ),
            ),
            Container(
              color: Color(0xffEEFCFF).withValues(alpha: 0.5),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: Image.asset("assets/icons/timer2.png"),
                      ),
                      SizedBox(width: 2),
                      Obx(() => Text(ctr.formattedTime)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (ctr.page.value < ctr.questionList.length - 1) {
                        ctr.updateIsSkipped();
                        // if (ctr.lastVisitedIndex.value > 0 &&
                        //     ctr.lastVisitedIndex.value <=
                        //         ctr.questionList.length - 1) {
                        //   ctr.gotoPage(page: ctr.lastVisitedIndex.value);
                        // }

                        bool canSkip = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: SizedBox(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 24),
                                    Text(
                                      'Are you sure about skipping?',
                                      style: GoogleFonts.urbanist(
                                        color: const Color(0xFF010029),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'You can be able to answer this question later.',
                                      style: GoogleFonts.urbanist(
                                        color: const Color(0xFF010029),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    CustomBtn3(
                                      btnName: 'Yes, I want to skip',
                                      vpad: 12,
                                      hpad: 12,
                                      onTapFunction: () {
                                        // ctr.gotoPage(pageIndex: 4);
                                        if (ctr.answerMap.containsKey(
                                            "${ctr.questionList[ctr.page.value].questionId}")) {
                                          log("already attended");
                                          Get.back(result: true);
                                        } else {
                                          log("add to skip");
                                          Get.back(result: true);
                                          ctr.generateSkippedList(
                                              index: ctr.page.value,
                                              id: "${ctr.questionList[ctr.page.value].questionId}");
                                        }
                                      },
                                    ),
                                    Gap(
                                      Constant.screenHeight *
                                          (8 / Constant.figmaScreenHeight),
                                    ),
                                    CustomBtn4(
                                      btnName: 'No, I want to answer this',
                                      vpad: 12,
                                      hpad: 12,
                                      onTapFunction: () {
                                        Get.back(result: false);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        if (canSkip == true) {
                          await Future.delayed(Duration(milliseconds: 500));
                          if (ctr.lastVisitedIndex.value == -1) {
                            ctr.gotoNext();
                          } else {
                            ctr.lstvalue.value = ctr.lastVisitedIndex.value;
                            if (ctr.page.value < ctr.lstvalue.value) {
                              ctr.gotoPage(pageIndex: ctr.lstvalue.value);
                            } else {
                              ctr.gotoNext();
                            }
                          }
                        }
                      }
                    },
                    child: Text(
                      "skip this question",
                      style: GoogleFonts.urbanist(
                        color: Color(0xffD84040),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xffD84040),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffEEFCFF).withValues(alpha: 0.5),
                ),
                child: Obx(() {
                  if (ctr.timerExpired.value &&
                      ctr.isReportLoading.value == false) {
                    EasyLoading.show();
                    Future.delayed(Duration.zero, () async {
                      bool x = await ctr.generateExamReport(
                        level: level,
                        type: type,
                      );

                      EasyLoading.dismiss();

                      if (x) {
                        Get.to(() => ResultPage());
                      } else {
                        Fluttertoast.showToast(
                          msg: ctr.examReportState.value.error ??
                              'Something went wrong',
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    });
                  }
                  return Obx(() {
                    return PageView.builder(
                      scrollBehavior: ScrollBehavior(),
                      onPageChanged: (index) {
                        ctr.setCurrentPageIndex(index: index);
                        ctr.resetValues();
                        ctr.setSubmittedStatus(
                          staus: ctr.questionList[index].isAttempted ?? false,
                        );
                        // ctr.resetToCurrentDeafults();
                        ctr.resetAvgTimer();
                        ctr.startAvgTimer();
                      },
                      controller: ctr.pageController,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ctr.questionList.length,
                      itemBuilder: (context, index) {
                        ctr.setCurrentQuestion(
                          question: ctr.questionList[index],
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ctr.setCurrentQuestionIndex(index: index + 1);
                        });

                        return Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Question  ${index + 1}  of ${ctr.questionList.length}   id:${ctr.questionList[index].questionId}",
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: const Color(
                                          0xff0100294d,
                                        ).withValues(alpha: 0.3),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                  ],
                                ),
                                SizedBox(height: 8),
                                SizedBox(height: 5),
                                TexText(
                                  "${ctr.questionList[index].question}",
                                  style: GoogleFonts.urbanist(
                                    color: const Color(0xFF010029),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, i) {
                                    String option = ctr.mapIndexToOption(
                                      index: i,
                                    );
                                    bool isSelected = ctr.currentQuestion.value
                                            .selectedOption ==
                                        option;
                                    bool isSubmitted =
                                        ctr.currentQuestion.value.isAttempted ??
                                            false;
                                    String optionTitle = _getOptionTitle(i);
                                    Color tileColor = _getTileColor(
                                      index,
                                      option,
                                      isSelected,
                                      isSubmitted,
                                    );

                                    return Obx(
                                      () => OptionTile(
                                        index: i,
                                        isSelected: ctr
                                                .currentUserSelectedOption
                                                .value ==
                                            option,
                                        onTapFunction: (optionValue) {
                                          if (ctr.questionList[index]
                                                  .isAttempted !=
                                              true) {
                                            ctr.setCurrentUserSelectedOption(
                                              option: optionValue,
                                            );
                                          }
                                        },
                                        optionValue: option,
                                        tileColor: ctr.instantEvaluvation.value
                                            ? tileColor
                                            : null,
                                        title: optionTitle,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 12),
                                Obx(() {
                                  if (ctr.currentUserSelectedOption.value !=
                                          null &&
                                      ctr.instantEvaluvation.value) {
                                    return ctr.currentQuestion.value
                                                .isMarkedCorrect ==
                                            true
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "AI-Solution",
                                                style: GoogleFonts.urbanist(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              TexText(
                                                "${ctr.questionList[index].explanation}",
                                                style: GoogleFonts.urbanist(
                                                  color:
                                                      const Color(0xFF010029),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 24),
                                            ],
                                          )
                                        : SizedBox();
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.5))),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => ExamButton(
                btnName: ctr.isSubmitted.value == true
                    ? ctr.page.value >= ctr.questionList.length - 1
                        ? "End Test"
                        : "Next"
                    : 'Submit',
                iconImg: PhosphorIcons.arrowRight(),
                vpad: 12,
                hpad: 20,
                onTapFunction: () async {
                  log("page:${ctr.page.value}     index:${ctr.checkIndex}");
                  if (ctr.isSubmitted.value == true) {
                    try {
                      log("call for submission");
                      if ((ctr.page.value >= ctr.questionList.length - 1) &&
                          ctr.isReportLoading.value == false) {
                        EasyLoading.show();
                        ctr.skippedCount();
                        bool x;
                        x = await ctr.generateExamReport(
                          level: level,
                          type: type,
                        );

                        if (x) {
                          EasyLoading.dismiss();
                          Get.to(() => ResultPage());
                        } else {
                          EasyLoading.dismiss();
                          Fluttertoast.showToast(
                            msg: ctr.examReportState.value.error ??
                                'something went wrong',
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }

                        return;
                      }
                      ctr.gotoNext();
                    } catch (e) {
                      log("error Next/Sumit/ :$e");
                    }
                  } else {
                    ctr.submitAnswer();

                    if (ctr.currentUserSelectedOption.value == null) {
                      if (ctr.skippedList.contains(ctr.page.value)) {
                      } else {
                        ctr.generateSkippedList(
                            index: ctr.page.value,
                            id: "${ctr.questionList[ctr.page.value].questionId}");
                      }
                    }

                    if (ctr.currentUserSelectedOption.value != null) {
                      if (ctr.skippedList.contains(ctr.page.value) &&
                          ctr.skippedIds.contains(
                              '${ctr.questionList[ctr.page.value].questionId}')) {
                        ctr.skippedList.remove(ctr.page.value);
                        ctr.skippedIds.remove(
                            '${ctr.questionList[ctr.page.value].questionId}');
                        ctr.saveResult();
                        ctr.resetAvgTimer();
                      } else {
                        ctr.saveResult();
                        ctr.resetAvgTimer();
                      }
                    }

                    if (ctr.currentQnAnswer.value ==
                        ctr.currentUserSelectedOption.value) {
                      ctr.generateCorrectList(
                          index: ctr.page.value,
                          id: "${ctr.questionList[ctr.page.value].questionId}");
                    }

                    if (ctr.currentQnAnswer.value !=
                            ctr.currentUserSelectedOption.value &&
                        ctr.currentUserSelectedOption.value != null) {
                      ctr.generateIncorrectIdList(
                          id: "${ctr.questionList[ctr.page.value].questionId}");
                      ctr.generateIncorrectList(index: ctr.page.value);
                    }

                    log("ctr.page.value : ${ctr.page.value}");

                    log('ans:${ctr.answerMap}');

                    // log("answermap:${ctr.answerMap.containsKey("588")}");
                  }
                },
              ),
            ),
            ExamButton(
              isOutline: true,
              btncolor: Colors.white,
              btnName: 'flag',
              iconImg: PhosphorIcons.flagPennant(),
              vpad: 12,
              hpad: 20,
              onTapFunction: () {
                ctr.markFlagged(index: ctr.page.value);
                ctr.updateIsFlagged();
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getTileColor(
    int index,
    String option,
    bool isSelected,
    bool isSubmitted,
  ) {
    final ctr = Get.find<ExamController>();

    // log("ctr.currentUserSelectedOption.value : ${ctr.currentUserSelectedOption.value}");

    // log("currentUserSelectedOption in QUESTION OBJECT : ${ctr.currentQuestion.value.selectedOption}");

    if (ctr.currentUserSelectedOption.value != null) {
      if (isSubmitted) {
        if (option == ctr.currentQnAnswer.value) {
          return Colors.green; // Correct answer
        } else if (isSelected) {
          return Colors.red; // Incorrect selected answer
        }
        return Colors.transparent; // Other options (no color)
      }

      // Default color when not submitted (transparent)
      return Colors.transparent;
    }
    return Colors.transparent;
  }

  String _getOptionTitle(int index) {
    final ctr = Get.find<ExamController>();

    switch (index) {
      case 0:
        return ctr.currentQuestion.value.options?.a ?? '';
      case 1:
        return ctr.currentQuestion.value.options?.b ?? '';
      case 2:
        return ctr.currentQuestion.value.options?.c ?? '';
      case 3:
        return ctr.currentQuestion.value.options?.d ?? '';
      default:
        return '';
    }
  }
}
