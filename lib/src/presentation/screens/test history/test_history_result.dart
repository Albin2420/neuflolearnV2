// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
// import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/exam_loading.dart';
// import 'package:neuflo_learn/src/presentation/screens/exams/result/widgets/result_info.dart';
// import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/answertile.dart';
// import 'package:neuflo_learn/src/presentation/widgets/app_btn/custom_text_field.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

// class TestHistoryResult extends StatelessWidget {
//   const TestHistoryResult({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ctr = Get.find<TestHistoryController>();
//     TextEditingController txt = TextEditingController();
//     return Scaffold(
//       backgroundColor: const Color(0xffEDF1F2),
//       appBar: AppBar(
//         shadowColor: const Color(0x00000008),
//         surfaceTintColor: Colors.white,
//         elevation: 10,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.close_rounded),
//         ),
//         title: Column(
//           children: [
//             Text(
//               "Test results",
//               style: GoogleFonts.urbanist(
//                 fontSize: 19,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF010029),
//               ),
//             ),
//             Text(
//               "Physics 45 - Daily test ",
//               style: GoogleFonts.urbanist(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF010029),
//               ),
//             ),
//             // Obx(() {
//             //   return Text(ctr.currentSubjectName);
//             // })
//           ],
//         ),
//         flexibleSpace: Column(
//           children: [
//             const Spacer(),
//             Container(
//               height: 1,
//               decoration: BoxDecoration(boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   offset: const Offset(0, 1),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() {
//         return ctr.state.value.onState(onInitial: () {
//           return ExamLoading();
//         }, success: (s) {
//           return Obx(() {
//             return SingleChildScrollView(
//               primary: false,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 16),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 24,
//                     ),
//                     ResultInfo(
//                         timeTaken: "${ctr.timetaken.value}",
//                         sCore: "${ctr.score.value}",
//                         rAnk: "${ctr.rAnK.value}",
//                         correct: "${ctr.correct.value}",
//                         incorrect: "${ctr.incorrect.value}",
//                         unAttempted: "${ctr.unAttempted.value}",
//                         perCentage: "${ctr.percentage.value}"),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     SizedBox(
//                       child: Column(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Your answers",
//                                 style: GoogleFonts.urbanist(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: const Color(0xff01002980)
//                                       .withValues(alpha: 0.5),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               CustomTextField(
//                                 hintText: 'Search topic',
//                                 textEditingController: txt,
//                                 prefixIcon: PhosphorIcons.magnifyingGlass(),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               ListView.separated(
//                                   shrinkWrap: true,
//                                   primary: true,
//                                   itemBuilder: (buildContext, index) {
//                                     log("ans:${ctr.qstns[index].answer}");
//                                     return AnsweRTile(
//                                         option: '',
//                                         qstn: "${ctr.qstns[index].question}",
//                                         answer: "${ctr.qstns[index].answer}",
//                                         correctAnswer:
//                                             "${ctr.qstns[index].answer}",
//                                         incorrectAnswer:
//                                             "${ctr.qstns[index].selectedOption}");
//                                   },
//                                   separatorBuilder: (buildContext, index) {
//                                     return SizedBox(
//                                       height: 10,
//                                     );
//                                   },
//                                   itemCount: ctr.qstns.length)
//                               // Container(
//                               //   padding: EdgeInsets.all(Constant.screenWidth *
//                               //       (4 / Constant.figmaScreenWidth)),
//                               //   decoration: BoxDecoration(
//                               //     color: Color(0xFFFFFFFF),
//                               //     border: Border.all(
//                               //         color: Color(0xff02012a1a)
//                               //             .withValues(alpha: 0.1)),
//                               //     borderRadius:
//                               //         BorderRadius.all(Radius.circular(40)),
//                               //   ),
//                               //   child: Row(
//                               //     children: [
//                               //       Expanded(
//                               //         child: Obx(
//                               //           () => Container(
//                               //             decoration: BoxDecoration(
//                               //               color: ctr.filterStatus.value == "All"
//                               //                   ? const Color(0xFF010029)
//                               //                   : const Color(0xFFFFFFFF),
//                               //               borderRadius:
//                               //                   BorderRadius.circular(128),
//                               //             ),
//                               //             child: InkWell(
//                               //               borderRadius:
//                               //                   BorderRadius.circular(128),
//                               //               onTap: () async {

//                               //               },
//                               //               child: Container(
//                               //                 decoration: BoxDecoration(
//                               //                   borderRadius:
//                               //                       BorderRadius.circular(128),
//                               //                 ),
//                               //                 child: Padding(
//                               //                   padding:
//                               //                       const EdgeInsets.all(8.0),
//                               //                   child: Center(
//                               //                     child: Text(
//                               //                       "All",
//                               //                       style: GoogleFonts.urbanist(
//                               //                         fontSize: Constant
//                               //                                 .screenHeight *
//                               //                             (14 /
//                               //                                 Constant
//                               //                                     .figmaScreenHeight),
//                               //                         fontWeight: FontWeight.w400,
//                               //                         color: ctr.filterStatus
//                               //                                     .value ==
//                               //                                 "All"
//                               //                             ? const Color(
//                               //                                 0xFFFFFFFF)
//                               //                             : const Color(
//                               //                                 0xFF010029),
//                               //                       ),
//                               //                     ),
//                               //                   ),
//                               //                 ),
//                               //               ),
//                               //             ),
//                               //           ),
//                               //         ),
//                               //       ),
//                               //       Expanded(
//                               //         child: Obx(() => Container(
//                               //               decoration: BoxDecoration(
//                               //                 borderRadius:
//                               //                     BorderRadius.circular(128),
//                               //                 color: ctr.filterStatus.value ==
//                               //                         "Correct"
//                               //                     ? const Color(0xFF010029)
//                               //                     : const Color(0xFFFFFFFF),
//                               //               ),
//                               //               child: Material(
//                               //                 color: Colors.transparent,
//                               //                 child: InkWell(
//                               //                   borderRadius:
//                               //                       BorderRadius.circular(128),
//                               //                   onTap: () {

//                               //                   },
//                               //                   child: Container(
//                               //                     decoration: BoxDecoration(
//                               //                       borderRadius:
//                               //                           BorderRadius.circular(
//                               //                               128),
//                               //                     ),
//                               //                     child: Padding(
//                               //                       padding:
//                               //                           const EdgeInsets.all(8.0),
//                               //                       child: Center(
//                               //                         child: Text(
//                               //                           "Correct",
//                               //                           style:
//                               //                               GoogleFonts.urbanist(
//                               //                             fontSize: Constant
//                               //                                     .screenHeight *
//                               //                                 (14 /
//                               //                                     Constant
//                               //                                         .figmaScreenHeight),
//                               //                             fontWeight:
//                               //                                 FontWeight.w400,
//                               //                             color: ctr.filterStatus
//                               //                                         .value ==
//                               //                                     "Correct"
//                               //                                 ? const Color(
//                               //                                     0xFFFFFFFF)
//                               //                                 : const Color(
//                               //                                     0xFF010029),
//                               //                           ),
//                               //                         ),
//                               //                       ),
//                               //                     ),
//                               //                   ),
//                               //                 ),
//                               //               ),
//                               //             )),
//                               //       ),
//                               //       Expanded(
//                               //         child: Obx(
//                               //           () => Container(
//                               //             decoration: BoxDecoration(
//                               //               color: ctr.filterStatus.value ==
//                               //                       "Incorrect"
//                               //                   ? const Color(0xFF010029)
//                               //                   : const Color(0xFFFFFFFF),
//                               //               borderRadius:
//                               //                   BorderRadius.circular(128),
//                               //             ),
//                               //             child: Material(
//                               //               color: Colors.transparent,
//                               //               child: InkWell(
//                               //                 borderRadius:
//                               //                     BorderRadius.circular(128),
//                               //                 onTap: () {

//                               //                 },
//                               //                 child: Container(
//                               //                   decoration: BoxDecoration(
//                               //                     borderRadius:
//                               //                         BorderRadius.circular(128),
//                               //                   ),
//                               //                   child: Padding(
//                               //                     padding:
//                               //                         const EdgeInsets.all(8.0),
//                               //                     child: Center(
//                               //                       child: Text(
//                               //                         "Incorrect",
//                               //                         style: GoogleFonts.urbanist(
//                               //                           fontSize: Constant
//                               //                                   .screenHeight *
//                               //                               (14 /
//                               //                                   Constant
//                               //                                       .figmaScreenHeight),
//                               //                           fontWeight:
//                               //                               FontWeight.w400,
//                               //                           color: ctr.filterStatus
//                               //                                       .value ==
//                               //                                   "Incorrect"
//                               //                               ? const Color(
//                               //                                   0xFFFFFFFF)
//                               //                               : const Color(
//                               //                                   0xFF010029),
//                               //                         ),
//                               //                       ),
//                               //                     ),
//                               //                   ),
//                               //                 ),
//                               //               ),
//                               //             ),
//                               //           ),
//                               //         ),
//                               //       ),
//                               //       Expanded(
//                               //         child: Obx(() => Container(
//                               //               decoration: BoxDecoration(
//                               //                 color:
//                               //                     ? const Color(0xFF010029)
//                               //                     : const Color(0xFFFFFFFF),
//                               //                 borderRadius:
//                               //                     BorderRadius.circular(128),
//                               //               ),
//                               //               child: Material(
//                               //                 color: Colors.transparent,
//                               //                 child: InkWell(
//                               //                   borderRadius:
//                               //                       BorderRadius.circular(128),
//                               //                   onTap: () {

//                               //                   },
//                               //                   child: Container(
//                               //                     decoration: BoxDecoration(
//                               //                       borderRadius:
//                               //                           BorderRadius.circular(
//                               //                               128),
//                               //                     ),
//                               //                     child: Padding(
//                               //                       padding:
//                               //                           const EdgeInsets.all(8.0),
//                               //                       child: Center(
//                               //                         child: Text(
//                               //                           "Skipped",
//                               //                           style:
//                               //                               GoogleFonts.urbanist(
//                               //                             fontSize: Constant
//                               //                                     .screenHeight *
//                               //                                 (14 /
//                               //                                     Constant
//                               //                                         .figmaScreenHeight),
//                               //                             fontWeight:
//                               //                                 FontWeight.w400,
//                               //                             color:
//                               //                                 ? const Color(
//                               //                                     0xFFFFFFFF)
//                               //                                 : const Color(
//                               //                                     0xFF010029),
//                               //                           ),
//                               //                         ),
//                               //                       ),
//                               //                     ),
//                               //                   ),
//                               //                 ),
//                               //               ),
//                               //             )),
//                               //       ),
//                               //     ],
//                               //   ),
//                               // ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           });
//         }, onFailed: (f) {
//           return SizedBox(
//             height: 10,
//           );
//         }, onLoading: () {
//           log("loading");
//           return ExamLoading();
//         });
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/exam_loading.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/FilterWidgets/all_filtered.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/FilterWidgets/correct_filtered.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/FilterWidgets/incorrect_filtered.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/FilterWidgets/skipped_filtered.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../widgets/app_btn/custom_text_field.dart';
import '../exams/result/widgets/result_info.dart';

class TestHistoryResult extends StatelessWidget {
  const TestHistoryResult({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    TextEditingController txt = TextEditingController();
    final filters = [
      Allfiltered(),
      CorrectFiltered(),
      Incorrectfiltered(),
      SkippedFiltered()
    ];
    return Obx(
      () {
        return ctr.state.value.onState(
          onInitial: () {
            return ExamLoading();
          },
          success: (r) {
            return Scaffold(
              backgroundColor: const Color(0xffEDF1F2),
              appBar: AppBar(
                shadowColor: const Color(0x00000008),
                surfaceTintColor: Colors.white,
                elevation: 10,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      ctr.sub.value,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF010029),
                      ),
                    ),
                    Text(
                      "Your result",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 0, 41, 128)
                            .withValues(alpha: 0.5),
                      ),
                    )
                  ],
                ),
                flexibleSpace: Column(
                  children: [
                    const Spacer(),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                leading: IconButton(
                  icon: Image.asset("assets/icons/close.png", scale: 3.5),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 24),
                              child: ResultInfo(
                                timeTaken: "${ctr.timetaken.value}",
                                sCore: "${ctr.score.value}",
                                rAnk: "${ctr.rAnK.value}",
                                correct: "${ctr.correct.value}",
                                incorrect: "${ctr.incorrect.value}",
                                unAttempted: "${ctr.unAttempted.value}",
                                perCentage: "${ctr.percentage.value}",
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: [
                                  Text(
                                    "Your Answers",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff01002980)
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: CustomTextField(
                                hintText: 'Search topic',
                                textEditingController: txt,
                                prefixIcon: PhosphorIcons.magnifyingGlass(),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, left: 16, right: 16, bottom: 16),
                              child: Container(
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
                                            color:
                                                ctr.filterStatus.value == "All"
                                                    ? const Color(0xFF010029)
                                                    : const Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(128),
                                          ),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(128),
                                            onTap: () async {
                                              ctr.filterAll(index: 0);
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
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                  ctr.filterCorrect(index: 1);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            128),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Correct",
                                                        style: GoogleFonts
                                                            .urbanist(
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
                                                ctr.filterInCorrect(index: 2);
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
                                                      "Incorrect",
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
                                                  ctr.filterSkipped(index: 3);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            128),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Skipped",
                                                        style: GoogleFonts
                                                            .urbanist(
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24),
                              child: Obx(() {
                                return filters[ctr.filterindex.value];
                              }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          onFailed: (f) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text("failed...."),
                ),
              ),
            );
          },
          onLoading: () {
            return ExamLoading();
          },
        );
      },
    );
  }
}
