// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/option_tile.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/result.dart';
import 'package:neuflo_learn/src/presentation/screens/navigationscreen/navigationscreen.dart';
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
                                              color: const Color(0xFF010029)
                                                  .withValues(alpha: 0.5),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Gap(
                                            Constant.screenHeight *
                                                (24 /
                                                    Constant.figmaScreenHeight),
                                          ),
                                          CustomBtn3(
                                            btnName: 'Yes i want to exit',
                                            vpad: 12,
                                            hpad: 12,
                                            onTapFunction: () {
                                              Get.back();
                                              // ctr.resetExamValues();
                                              Get.offAll(
                                                  () => NavigationScreen());
                                            },
                                          ),
                                          Gap(
                                            Constant.screenHeight *
                                                (8 /
                                                    Constant.figmaScreenHeight),
                                          ),
                                          CustomBtn4(
                                              btnName:
                                                  'No, I want to finish the test',
                                              vpad: 12,
                                              hpad: 12,
                                              onTapFunction: () {
                                                Get.back();
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
                                                PhosphorIconsStyle.fill),
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
                                                color:
                                                    ctr.correctList.contains(i)
                                                        ? Colors.green
                                                        : ctr.inCorrectList
                                                                .contains(i)
                                                            ? Colors.red
                                                            : Color(0xff010029),
                                              ),
                                            ),
                                          ),
                                        )
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
                            Obx(() => Text(
                                  "${ctr.currentQuestionIndex}",
                                  style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )),
                            Text(
                              "/${ctr.questionList.length}",
                              style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600, fontSize: 10),
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
                                  Obx(() => Text(
                                        "Question ${ctr.page.value + 1}",
                                        style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Image.asset(
                                        scale: 2, "assets/icons/down.png"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        NextPrevBtn(
                          iconImg: 'assets/icons/next3.png',
                          onTapFunction: () {
                            ctr.gotoNext();
                            ctr.resetAvgTimer();
                          },
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () {
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
                                  )),
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
                                        width: 1),
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
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      mainAxisSpacing: 15,
                                                      crossAxisSpacing: 15,
                                                      crossAxisCount: 7),
                                              itemCount:
                                                  ctr.questionList.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    ctr.toggleIsxapanded();
                                                    ctr.gotoPage(
                                                        pageIndex: index);
                                                  },
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        color: ctr.correctList
                                                                .contains(index)
                                                            ? Colors.green
                                                            : ctr.inCorrectList
                                                                    .contains(
                                                                        index)
                                                                ? Colors.red
                                                                : Color(
                                                                    0xff010029), //
                                                        shape: BoxShape.circle),
                                                    child: Center(
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
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
                    },
                  )
                ],
              ),
            ),
            Container(
              color: Color(0xffEEFCFF).withValues(alpha: 0.5),
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
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
                      SizedBox(
                        width: 2,
                      ),
                      Obx(
                        () => Text(
                          ctr.formattedTime,
                        ),
                      ),
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
                                    SizedBox(
                                      height: 24,
                                    ),
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
                                      'You wont be able to answer this question later.',
                                      style: GoogleFonts.urbanist(
                                        color: const Color(0xFF010029),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    CustomBtn3(
                                      btnName: 'Yes, I want to skip',
                                      vpad: 12,
                                      hpad: 12,
                                      onTapFunction: () {
                                        // ctr.gotoPage(pageIndex: 4);
                                        Get.back(result: true);
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
                                    )
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
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEEFCFF).withValues(alpha: 0.5),
                  ),
                  child: Obx(() {
                    return PageView.builder(
                      scrollBehavior: ScrollBehavior(),
                      onPageChanged: (index) {
                        ctr.setCurrentPageIndex(index: index);
                        ctr.resetValues();
                        ctr.setSubmittedStatus(
                          staus: ctr.questionList[index].isAttempted ?? false,
                        );

                        ctr.resetToCurrentDeafults();

                        ctr.resetAvgTimer();
                        ctr.startAvgTimer();

                        // ctr.setLastVisitedIndex(index: index);
                        // ctr.onNextQuestionLoaded();
                      },
                      controller: ctr.pageController,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ctr.questionList.length,
                      itemBuilder: (context, index) {
                        ctr.setCurrentQuestion(
                          question: ctr.questionList[index],
                        );
                        // log('qns :${ctr.questionList[index].question}');

                        // log('id :${ctr.questionList[index].questionId}');
                        // log("opt:${ctr.questionList[index].options}");
                        // log("ans:${ctr.questionList[index].answer}");

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ctr.setCurrentQuestionIndex(index: index + 1);
                        });

                        // ctr.startAvgTimer();

                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   ctr.canShowAnswer();
                        // });

                        ///
                        return Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Question  ${index < 10 ? index + 1 : index}  of ${ctr.questionList.length}",
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: const Color(0xff0100294d)
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    // Text(
                                    //     "ID:${ctr.questionList[index].questionId}")
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                // LaTexT(
                                //   laTeXCode: Text(
                                //     '${ctr.questionList[index].question}',
                                //     style: GoogleFonts.urbanist(
                                //       color: const Color(0xFF010029),
                                //       fontWeight: FontWeight.w700,
                                //       fontSize: 16,
                                //     ),
                                //   ),
                                // ),

                                // SizedBox(
                                //   height: 400,
                                //   child: Markdown(
                                //     selectable: true,
                                //     data:
                                //         r'''${ctr.questionList[index].question}''',
                                //     builders: {
                                //       'latex': LatexElementBuilder(
                                //         textStyle: const TextStyle(
                                //           // color: Colors.blue,
                                //           fontWeight: FontWeight.w100,
                                //         ),
                                //         textScaleFactor: 1.2,
                                //       ),
                                //     },
                                //     extensionSet: md.ExtensionSet(
                                //       [LatexBlockSyntax()],
                                //       [LatexInlineSyntax()],
                                //     ),
                                //   ),
                                // ),

                                // GptMarkdown(
                                //   '${ctr.questionList[index].question}',
                                //   style: const TextStyle(
                                //     color: Colors.red,
                                //   ),
                                // ),

                                SizedBox(
                                  height: 5,
                                ),
                                // Math.tex(
                                //   "{Å}", // API response
                                //   mathStyle: MathStyle.display,
                                //   textStyle: TextStyle(fontSize: 18),
                                // ),

                                TexText(
                                  "${ctr.questionList[index].question}",
                                  style: GoogleFonts.urbanist(
                                    color: const Color(0xFF010029),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),

                                // GptMarkdown(
                                //   '${ctr.questionList[index].question}',
                                //   style: GoogleFonts.urbanist(
                                //     color: const Color(0xFF010029),
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 16,
                                //   ),
                                // ),

                                SizedBox(
                                  height: 4,
                                ),

                                // Math.tex(
                                //   r'''In Young's double slit experiment carried out with light of wavelength (\lambda)=5000 \AA, the distance between the slits is 0.2 \mathrm{~mm} and the screen is at 200 \mathrm{~cm} from the slits. The central maximum is at x=0. The third maximum (taking the central maximum as zeroth maximum) will be at x equal to''',
                                //   textStyle: TextStyle(color: Colors.green),
                                //   onErrorFallback: (err) {
                                //     log("error,$err");
                                //     return Container(
                                //       height: 10,
                                //       width: 10,
                                //       color: Colors.red,
                                //     );
                                //   },
                                // ),
                                // GptMarkdown(
                                //     r'''$\mathrm{V}=\mathrm{B}_{\mathrm{E}} \tan \delta, \mathrm{H}=\mathrm{B}_{\mathrm{E}},$'''),

                                // GptMarkdown(
                                //   r'''$\mathrm{V}=\mathrm{B}_{\mathrm{E}} \tan \delta, \quad \mathrm{H}=\mathrm{B}_{\mathrm{E}}$''',
                                //   style: GoogleFonts.urbanist(
                                //     color: Color(0xFF010029),
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 16,
                                //   ),
                                // ),
                                // GptMarkdown(
                                //   r'''$\mathrm{V}=\mathrm{B}_{\mathrm{E}} \tan \delta, \mathrm{H}=\mathrm{B}_{\mathrm{E}},''',
                                //   style: GoogleFonts.urbanist(
                                //     color: Color.fromARGB(255, 15, 224, 85),
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 16,
                                //   ),
                                // ),

                                SizedBox(
                                  height: 4,
                                ),

                                // GptMarkdown(
                                //   r'''$\left[\begin{array}{lll}2015 & R S\end{array}\right]$''',
                                //   style: GoogleFonts.urbanist(
                                //     color: Color(0xFF010029),
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 16,
                                //   ),
                                // ),

                                // GptMarkdown(
                                //   r'''$\mathrm{V}=\mathrm{B}_{\mathrm{E}}, \mathrm{H}=\mathrm{B}_{\mathrm{E}} \tan \delta$, ''',
                                //   style: const TextStyle(
                                //     color: Colors.red,
                                //   ),
                                // ),

                                SizedBox(
                                  height: 24,
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, i) {
                                    // Option corresponding to the index
                                    String option =
                                        ctr.mapIndexToOption(index: i);

                                    // log("option =: $option");

                                    // Check if the current option is selected
                                    bool isSelected = ctr.currentQuestion.value
                                            .selectedOption ==
                                        option;

                                    // log("isSelected =: $isSelected");

                                    // Check if the answer has been submitted
                                    bool isSubmitted =
                                        ctr.currentQuestion.value.isAttempted ??
                                            false;

                                    // log("isSubmitted =: $isSubmitted");

                                    // Get the option title dynamically
                                    String optionTitle = _getOptionTitle(i);

                                    // Calculate the tile color based on the current selected option and the correct answer
                                    Color tileColor = _getTileColor(
                                        index, option, isSelected, isSubmitted);

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
                                        tileColor: tileColor,
                                        title: optionTitle,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Obx(() {
                                  if (ctr.currentUserSelectedOption.value !=
                                      null) {
                                    return (ctr.currentQuestion.value
                                                    .isMarkedCorrect !=
                                                true
                                            ? false
                                            : true)
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
                                              SizedBox(
                                                height: 8,
                                              ),
                                              GptMarkdown(
                                                "${ctr.questionList[index].explanation}",
                                                style: GoogleFonts.urbanist(
                                                  color:
                                                      const Color(0xFF010029),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              )
                                            ],
                                          )
                                        : SizedBox();
                                  } else {
                                    return SizedBox();
                                  }
                                })
                                // Expanded(
                                //   flex: 1,
                                //   child: SingleChildScrollView(
                                //     child: Column(
                                //       children: [
                                //         ListView.builder(
                                //           physics: NeverScrollableScrollPhysics(),
                                //           shrinkWrap: true,
                                //           itemCount: 4,
                                //           itemBuilder: (BuildContext context, i) {
                                //             // Option corresponding to the index
                                //             String option =
                                //                 ctr.mapIndexToOption(index: i);

                                //             // log("option =: $option");

                                //             // Check if the current option is selected
                                //             bool isSelected = ctr.currentQuestion
                                //                     .value.selectedOption ==
                                //                 option;

                                //             // log("isSelected =: $isSelected");

                                //             // Check if the answer has been submitted
                                //             bool isSubmitted = ctr.currentQuestion
                                //                     .value.isAttempted ??
                                //                 false;

                                //             // log("isSubmitted =: $isSubmitted");

                                //             // Get the option title dynamically
                                //             String optionTitle =
                                //                 _getOptionTitle(i);

                                //             // Calculate the tile color based on the current selected option and the correct answer
                                //             Color tileColor = _getTileColor(index,
                                //                 option, isSelected, isSubmitted);

                                //             return Obx(
                                //               () => OptionTile(
                                //                 index: i,
                                //                 isSelected: ctr
                                //                         .currentUserSelectedOption
                                //                         .value ==
                                //                     option,
                                //                 onTapFunction: (optionValue) {
                                //                   if (ctr.questionList[index]
                                //                           .isAttempted !=
                                //                       true) {
                                //                     ctr.setCurrentUserSelectedOption(
                                //                       option: optionValue,
                                //                     );
                                //                   }
                                //                 },
                                //                 optionValue: option,
                                //                 tileColor: tileColor,
                                //                 title: optionTitle,
                                //               ),
                                //             );
                                //           },
                                //         ),
                                //         SizedBox(
                                //           height: 12,
                                //         ),
                                //         Obx(() {
                                //           if (ctr.currentUserSelectedOption
                                //                   .value !=
                                //               null) {
                                //             return (ctr.currentQuestion.value
                                //                             .isMarkedCorrect !=
                                //                         true
                                //                     ? false
                                //                     : true)
                                //                 ? Column(
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment.start,
                                //                     children: [
                                //                       Text(
                                //                         "AI-Solution",
                                //                         style:
                                //                             GoogleFonts.urbanist(
                                //                           fontWeight:
                                //                               FontWeight.w800,
                                //                           fontSize: 16,
                                //                         ),
                                //                       ),
                                //                       SizedBox(
                                //                         height: 8,
                                //                       ),
                                //                       LaTexT(
                                //                         laTeXCode: Text(
                                //                           '${ctr.questionList[index].explanation}',
                                //                           style: GoogleFonts
                                //                               .urbanist(
                                //                             color: const Color(
                                //                                 0xFF010029),
                                //                             fontWeight:
                                //                                 FontWeight.w700,
                                //                             fontSize: 16,
                                //                           ),
                                //                         ),
                                //                       ),
                                //                       SizedBox(
                                //                         height: 24,
                                //                       )
                                //                     ],
                                //                   )
                                //                 : SizedBox();
                                //           } else {
                                //             return SizedBox();
                                //           }
                                //         })
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  })),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
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
                  if (ctr.isSubmitted.value == true) {
                    try {
                      if ((ctr.page.value >= ctr.questionList.length - 1) &&
                          ctr.isReportLoading.value == false) {
                        EasyLoading.show();
                        ctr.skippedCount();
                        bool x;
                        x = await ctr.generateExamReport(
                            level: level, type: type);

                        if (x) {
                          EasyLoading.dismiss();
                          Get.to(() => ResultPage());
                        } else {
                          EasyLoading.dismiss();
                          Fluttertoast.showToast(
                            msg: ctr.examReportState.value.error ??
                                'something went wrong',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
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
                      ctr.generateSkippedList(index: ctr.page.value);
                    }

                    if (ctr.currentUserSelectedOption.value != null) {
                      ctr.saveResult();
                      ctr.resetAvgTimer();
                    }

                    if (ctr.currentQnAnswer.value ==
                        ctr.currentUserSelectedOption.value) {
                      ctr.generateCorrectList(index: ctr.page.value);
                    }

                    if (ctr.currentQnAnswer.value !=
                            ctr.currentUserSelectedOption.value &&
                        ctr.currentUserSelectedOption.value != null) {
                      ctr.generateIncorrectIdList(index: ctr.page.value);
                      ctr.generateIncorrectList(index: ctr.page.value);
                    }

                    log("ctr.page.value : ${ctr.page.value}");
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
            )
          ],
        ),
      ),
    );
  }

  Color _getTileColor(
      int index, String option, bool isSelected, bool isSubmitted) {
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
