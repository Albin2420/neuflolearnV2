import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/custom_test/custom_test_controller.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/test_settings/widgets/chapter_list.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/custom_text_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TestSettingsSheet extends StatefulWidget {
  const TestSettingsSheet({super.key});

  @override
  State<TestSettingsSheet> createState() => _TestSettingsSheetState();
}

class _TestSettingsSheetState extends State<TestSettingsSheet> {
  final ctr = Get.find<CustomTestController>();
  final examctr = Get.find<ExamController>();
  // Add a variable to control the visibility of the question count list
  // final bool _showQuestionCountList = false;
  // Define the list of available question counts
  final List<int> _questionCounts = [20, 30, 40, 50, 60];
  // Add an RxInt for selected question count

  // Add an overlay entry variable
  OverlayEntry? _overlayEntry;

  // Function to show question count overlay
  void _showQuestionCountOverlay(
      BuildContext context, RxInt selectedCount, List<int> counts) {
    // Remove any existing overlay
    _removeOverlay();

    // Create a new overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Position the overlay next to the question count section
        top: 270, // Adjust based on your layout
        right: 30,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 80,
            constraints: BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: counts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ctr.questionCount.value = counts[index];
                    if (examctr.timeLimit.value) {
                      examctr.targetSecond.value =
                          minutesToSeconds(ctr.questionCount.value);
                    }
                    // log("qns count : ${ctr.questionCount.value},secondlimit : ${examctr.targetSecond.value}");
                    _removeOverlay();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: selectedCount.value == counts[index]
                          ? Color(0xff010029).withOpacity(0.1)
                          : Colors.transparent,
                      border: Border(
                        bottom: index < counts.length - 1
                            ? BorderSide(color: Colors.grey.shade200)
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        counts[index].toString(),
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: selectedCount.value == counts[index]
                              ? Color(0xff010029)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    // Add the overlay to the overlay state
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Function to remove overlay
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove overlay when disposing
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ctr.setCurrentSubjectName(sub: 'Physics');
      await ctr.fetchChapters(subId: 1);
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: SizedBox(),
      ),
      backgroundColor: Colors.grey,
      body: GestureDetector(
        // Close overlay when tapped outside
        onTap: () {
          _removeOverlay();
        },
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 24, top: 10, bottom: 12, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                      ),
                      Column(
                        children: [
                          Text(
                            'Create a custom test',
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          Text(
                            "Setup your test",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                          // ctr.clearHiveBox();
                        },
                        icon: Icon(Icons.close),
                      )
                    ],
                  ),
                ),

                ///expand goes from here
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 8, bottom: 8, left: 24, right: 24),
                          height: 38,
                          child: Row(
                            children: [
                              Text(
                                "General",
                                style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff010029).withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 24, right: 24, top: 16, bottom: 40),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Question count",
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Show the question count overlay
                                      _showQuestionCountOverlay(context,
                                          ctr.questionCount, _questionCounts);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Obx(() => Text(
                                              ctr.questionCount.value
                                                  .toString(),
                                              style: GoogleFonts.urbanist(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            )),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.asset(
                                            scale: 4,
                                            "assets/icons/right_arrow.png",
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 32,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Instant evaluation",
                                      style: GoogleFonts.urbanist(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    Obx(
                                      () => Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          trackOutlineColor:
                                              WidgetStateColor.resolveWith(
                                            (states) => const Color(0x00FFFFFF),
                                          ),
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor: Color(0xffD2D2E1),
                                          activeTrackColor: Colors.black,
                                          value:
                                              examctr.instantEvaluvation.value,
                                          onChanged: (x) {
                                            examctr.instantEvaluvation.value =
                                                x;
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 32,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Time limit",
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Obx(() => Switch(
                                            trackOutlineColor:
                                                WidgetStateColor.resolveWith(
                                              (states) =>
                                                  const Color(0x00FFFFFF),
                                            ),
                                            inactiveThumbColor: Colors.white,
                                            inactiveTrackColor:
                                                Color(0xffD2D2E1),
                                            activeTrackColor: Colors.black,
                                            value: examctr.timeLimit.value,
                                            onChanged: (x) {
                                              examctr.timeLimit.value = x;
                                              if (examctr.timeLimit.value) {
                                                examctr.targetSecond.value =
                                                    minutesToSeconds(ctr
                                                        .questionCount.value);
                                              } else {
                                                examctr.targetSecond.value = 0;
                                              }
                                              log("qns count : ${ctr.questionCount.value},secondlimit : ${examctr.targetSecond.value}");
                                            },
                                          )),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // Rest of your code remains unchanged
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 24, top: 22, bottom: 24),
                          height: 70,
                          child: Row(
                            children: [
                              Text(
                                "Select topic(s)",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xff010029).withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            child: Container(
                              padding: EdgeInsets.all(Constant.screenWidth *
                                  (4 / Constant.figmaScreenWidth)),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Obx(() => Container(
                                          decoration: BoxDecoration(
                                            color:
                                                ctr.selectedSubjectName.value ==
                                                        "Physics"
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
                                              onTap: () async {
                                                ctr.setCurrentSubjectName(
                                                  sub: 'Physics',
                                                );
                                                await ctr.fetchChapters(
                                                    subId: 1);
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
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          PhosphorIcons.atom(ctr
                                                                      .selectedSubjectName
                                                                      .value ==
                                                                  "Physics"
                                                              ? PhosphorIconsStyle
                                                                  .fill
                                                              : PhosphorIconsStyle
                                                                  .regular),
                                                          color: ctr.selectedSubjectName
                                                                      .value ==
                                                                  "Physics"
                                                              ? Colors.white
                                                              : Colors.black,
                                                          size: 15,
                                                        ),
                                                        Gap(
                                                          Constant.screenWidth *
                                                              (4 /
                                                                  Constant
                                                                      .figmaScreenWidth),
                                                        ),
                                                        Text(
                                                          "Physics",
                                                          style: GoogleFonts
                                                              .urbanist(
                                                            fontSize: Constant
                                                                    .screenHeight *
                                                                (14 /
                                                                    Constant
                                                                        .figmaScreenHeight),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: ctr.selectedSubjectName
                                                                        .value ==
                                                                    "Physics"
                                                                ? const Color(
                                                                    0xFFFFFFFF)
                                                                : const Color(
                                                                    0xFF010029),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Obx(() => Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(128),
                                            color:
                                                ctr.selectedSubjectName.value ==
                                                        "Chemistry"
                                                    ? const Color(0xFF010029)
                                                    : const Color(0xFFFFFFFF),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(128),
                                              onTap: () async {
                                                ctr.setCurrentSubjectName(
                                                  sub: 'Chemistry',
                                                );
                                                await ctr.fetchChapters(
                                                    subId: 2);
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
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          PhosphorIcons.flask(ctr
                                                                      .selectedSubjectName
                                                                      .value ==
                                                                  "Chemistry"
                                                              ? PhosphorIconsStyle
                                                                  .fill
                                                              : PhosphorIconsStyle
                                                                  .regular),
                                                          color: ctr.selectedSubjectName
                                                                      .value ==
                                                                  "Chemistry"
                                                              ? Colors.white
                                                              : Colors.black,
                                                          size: 15,
                                                        ),
                                                        Gap(
                                                          Constant.screenWidth *
                                                              (4 /
                                                                  Constant
                                                                      .figmaScreenWidth),
                                                        ),
                                                        Text(
                                                          "Chemistry",
                                                          style: GoogleFonts
                                                              .urbanist(
                                                            fontSize: Constant
                                                                    .screenHeight *
                                                                (14 /
                                                                    Constant
                                                                        .figmaScreenHeight),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: ctr.selectedSubjectName
                                                                        .value ==
                                                                    "Chemistry"
                                                                ? const Color(
                                                                    0xFFFFFFFF)
                                                                : const Color(
                                                                    0xFF010029),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Obx(() => Container(
                                          decoration: BoxDecoration(
                                            color:
                                                ctr.selectedSubjectName.value ==
                                                        "Biology"
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
                                              onTap: () async {
                                                ctr.setCurrentSubjectName(
                                                    sub: 'Biology');
                                                await ctr.fetchChapters(
                                                    subId: 3);
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
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          PhosphorIcons.stethoscope(ctr
                                                                      .selectedSubjectName
                                                                      .value ==
                                                                  "Biology"
                                                              ? PhosphorIconsStyle
                                                                  .fill
                                                              : PhosphorIconsStyle
                                                                  .regular),
                                                          color: ctr.selectedSubjectName
                                                                      .value ==
                                                                  "Biology"
                                                              ? Colors.white
                                                              : Colors.black,
                                                          size: 15,
                                                        ),
                                                        Gap(
                                                          Constant.screenWidth *
                                                              (4 /
                                                                  Constant
                                                                      .figmaScreenWidth),
                                                        ),
                                                        Text(
                                                          "Biology",
                                                          style: GoogleFonts
                                                              .urbanist(
                                                            fontSize: Constant
                                                                    .screenHeight *
                                                                (14 /
                                                                    Constant
                                                                        .figmaScreenHeight),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: ctr.selectedSubjectName
                                                                        .value ==
                                                                    "Biology"
                                                                ? const Color(
                                                                    0xFFFFFFFF)
                                                                : const Color(
                                                                    0xFF010029),
                                                          ),
                                                        ),
                                                      ],
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
                        ),
                        ...[
                          Container(
                            padding: EdgeInsets.only(
                                top: 16, bottom: 16, left: 24, right: 24),
                            height: 86,
                            child: CustomTextField(
                              hintText: 'Search topic',
                              onChanged: (text) {
                                ctr.onSearchChanged(text);
                              },
                              textEditingController: ctr.txt,
                              prefixIcon: PhosphorIcons.magnifyingGlass(),
                            ),
                          ),
                          ChapterList()
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 2),
        child: AppBtn(
          btnName: "Done",
          onTapFunction: () {
            // Save the selected question count to your controller if needed
            // examctr.questionCount.value = _selectedQuestionCount.value;
            Get.back();
          },
        ),
      ),
    );
  }

  int minutesToSeconds(int minutes) {
    return minutes * 60;
  }
}
































































































// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
// import 'package:neuflo_learn/src/presentation/controller/custom_test/custom_test_controller.dart';
// import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
// import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/test_settings/widgets/chapter_list.dart';
// import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
// import 'package:neuflo_learn/src/presentation/widgets/app_btn/custom_text_field.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

// class TestSettingsSheet extends StatefulWidget {
//   const TestSettingsSheet({super.key});

//   @override
//   State<TestSettingsSheet> createState() => _TestSettingsSheetState();
// }

// class _TestSettingsSheetState extends State<TestSettingsSheet> {
//   @override
//   Widget build(BuildContext context) {
//     final ctr = Get.find<CustomTestController>();
//     final examctr = Get.find<ExamController>();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       ctr.setCurrentSubjectName(sub: 'Physics');
//       await ctr.fetchChapters(subId: 1);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: SizedBox(),
//       ),
//       backgroundColor: Colors.grey,
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30), // Radius for the top-left corner
//               topRight: Radius.circular(30), // Radius for the top-right corner
//             ),
//           ),
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 4,
//               ),
//               Container(
//                 height: 4,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Container(
//                 padding:
//                     EdgeInsets.only(left: 24, top: 10, bottom: 12, right: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(
//                       height: 24,
//                       width: 24,
//                     ),
//                     Column(
//                       children: [
//                         Text(
//                           'Create a custom test',
//                           style: GoogleFonts.urbanist(
//                               fontWeight: FontWeight.w700, fontSize: 20),
//                         ),
//                         Text(
//                           "Setup your test",
//                           style: GoogleFonts.urbanist(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                           ),
//                         )
//                       ],
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Get.back();
//                         // ctr.clearHiveBox();
//                       },
//                       icon: Icon(Icons.close),
//                     )
//                   ],
//                 ),
//               ),

//               ///expand goes from here
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(
//                             top: 8, bottom: 8, left: 24, right: 24),
//                         height: 38,
//                         child: Row(
//                           children: [
//                             Text(
//                               "General",
//                               style: GoogleFonts.urbanist(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16,
//                                   color: Color(0xff010029).withOpacity(0.5)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(
//                             left: 24, right: 24, top: 16, bottom: 40),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Question count",
//                                   style: GoogleFonts.urbanist(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     log("call the time sheet");
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         "20",
//                                         style: GoogleFonts.urbanist(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 16),
//                                       ),
//                                       SizedBox(
//                                         height: 24,
//                                         width: 24,
//                                         // color: Colors.blue,
//                                         child: Image.asset(
//                                           scale: 4,
//                                           "assets/icons/right_arrow.png",
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             SizedBox(
//                               height: 32,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Instant evaluation",
//                                     style: GoogleFonts.urbanist(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16),
//                                   ),
//                                   Obx(
//                                     () => Transform.scale(
//                                       scale: 0.8,
//                                       child: Switch(
//                                         trackOutlineColor:
//                                             WidgetStateColor.resolveWith(
//                                           (states) => const Color(0x00FFFFFF),
//                                         ),
//                                         inactiveThumbColor: Colors.white,
//                                         inactiveTrackColor: Color(0xffD2D2E1),
//                                         activeTrackColor: Colors.black,
//                                         value: examctr.instantEvaluvation.value,
//                                         onChanged: (x) {
//                                           examctr.instantEvaluvation.value = x;
//                                         },
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             SizedBox(
//                               height: 32,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Time limit",
//                                     style: GoogleFonts.urbanist(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   Transform.scale(
//                                     scale: 0.8,
//                                     child: Obx(() => Switch(
//                                           trackOutlineColor:
//                                               WidgetStateColor.resolveWith(
//                                             (states) => const Color(0x00FFFFFF),
//                                           ),
//                                           inactiveThumbColor: Colors.white,
//                                           inactiveTrackColor: Color(0xffD2D2E1),
//                                           activeTrackColor: Colors.black,
//                                           value: examctr.timeLimit.value,
//                                           onChanged: (x) {
//                                             examctr.timeLimit.value = x;
//                                           },
//                                         )),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(left: 16, right: 16, top: 0),
//                         child: Divider(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(left: 24, top: 22, bottom: 24),
//                         height: 70,
//                         child: Row(
//                           children: [
//                             Text(
//                               "Select topic(s)",
//                               style: GoogleFonts.urbanist(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                                 color: Color(0xff010029).withOpacity(0.5),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16, right: 16),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(40)),
//                           child: Container(
//                             padding: EdgeInsets.all(Constant.screenWidth *
//                                 (4 / Constant.figmaScreenWidth)),
//                             decoration: const BoxDecoration(
//                               color: Color(0xFFFFFFFF),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(40)),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Obx(() => Container(
//                                         decoration: BoxDecoration(
//                                           color:
//                                               ctr.selectedSubjectName.value ==
//                                                       "Physics"
//                                                   ? const Color(0xFF010029)
//                                                   : const Color(0xFFFFFFFF),
//                                           borderRadius:
//                                               BorderRadius.circular(128),
//                                         ),
//                                         child: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             borderRadius:
//                                                 BorderRadius.circular(128),
//                                             onTap: () async {
//                                               ctr.setCurrentSubjectName(
//                                                 sub: 'Physics',
//                                               );
//                                               await ctr.fetchChapters(subId: 1);
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(128),
//                                               ),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Center(
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(
//                                                         PhosphorIcons.atom(ctr
//                                                                     .selectedSubjectName
//                                                                     .value ==
//                                                                 "Physics"
//                                                             ? PhosphorIconsStyle
//                                                                 .fill
//                                                             : PhosphorIconsStyle
//                                                                 .regular),
//                                                         color:
//                                                             ctr.selectedSubjectName
//                                                                         .value ==
//                                                                     "Physics"
//                                                                 ? Colors.white
//                                                                 : Colors.black,
//                                                         size: 15,
//                                                       ),
//                                                       Gap(
//                                                         Constant.screenWidth *
//                                                             (4 /
//                                                                 Constant
//                                                                     .figmaScreenWidth),
//                                                       ),
//                                                       Text(
//                                                         "Physics",
//                                                         style: GoogleFonts
//                                                             .urbanist(
//                                                           fontSize: Constant
//                                                                   .screenHeight *
//                                                               (14 /
//                                                                   Constant
//                                                                       .figmaScreenHeight),
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           color: ctr.selectedSubjectName
//                                                                       .value ==
//                                                                   "Physics"
//                                                               ? const Color(
//                                                                   0xFFFFFFFF)
//                                                               : const Color(
//                                                                   0xFF010029),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                                 Expanded(
//                                   child: Obx(() => Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(128),
//                                           color:
//                                               ctr.selectedSubjectName.value ==
//                                                       "Chemistry"
//                                                   ? const Color(0xFF010029)
//                                                   : const Color(0xFFFFFFFF),
//                                         ),
//                                         child: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             borderRadius:
//                                                 BorderRadius.circular(128),
//                                             onTap: () async {
//                                               ctr.setCurrentSubjectName(
//                                                 sub: 'Chemistry',
//                                               );
//                                               await ctr.fetchChapters(subId: 2);
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(128),
//                                               ),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Center(
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(
//                                                         PhosphorIcons.flask(ctr
//                                                                     .selectedSubjectName
//                                                                     .value ==
//                                                                 "Chemistry"
//                                                             ? PhosphorIconsStyle
//                                                                 .fill
//                                                             : PhosphorIconsStyle
//                                                                 .regular),
//                                                         color:
//                                                             ctr.selectedSubjectName
//                                                                         .value ==
//                                                                     "Chemistry"
//                                                                 ? Colors.white
//                                                                 : Colors.black,
//                                                         size: 15,
//                                                       ),
//                                                       Gap(
//                                                         Constant.screenWidth *
//                                                             (4 /
//                                                                 Constant
//                                                                     .figmaScreenWidth),
//                                                       ),
//                                                       Text(
//                                                         "Chemistry",
//                                                         style: GoogleFonts
//                                                             .urbanist(
//                                                           fontSize: Constant
//                                                                   .screenHeight *
//                                                               (14 /
//                                                                   Constant
//                                                                       .figmaScreenHeight),
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           color: ctr.selectedSubjectName
//                                                                       .value ==
//                                                                   "Chemistry"
//                                                               ? const Color(
//                                                                   0xFFFFFFFF)
//                                                               : const Color(
//                                                                   0xFF010029),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                                 Expanded(
//                                   child: Obx(() => Container(
//                                         decoration: BoxDecoration(
//                                           color:
//                                               ctr.selectedSubjectName.value ==
//                                                       "Biology"
//                                                   ? const Color(0xFF010029)
//                                                   : const Color(0xFFFFFFFF),
//                                           borderRadius:
//                                               BorderRadius.circular(128),
//                                         ),
//                                         child: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             borderRadius:
//                                                 BorderRadius.circular(128),
//                                             onTap: () async {
//                                               ctr.setCurrentSubjectName(
//                                                   sub: 'Biology');
//                                               await ctr.fetchChapters(subId: 3);
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(128),
//                                               ),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Center(
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(
//                                                         PhosphorIcons.stethoscope(ctr
//                                                                     .selectedSubjectName
//                                                                     .value ==
//                                                                 "Biology"
//                                                             ? PhosphorIconsStyle
//                                                                 .fill
//                                                             : PhosphorIconsStyle
//                                                                 .regular),
//                                                         color:
//                                                             ctr.selectedSubjectName
//                                                                         .value ==
//                                                                     "Biology"
//                                                                 ? Colors.white
//                                                                 : Colors.black,
//                                                         size: 15,
//                                                       ),
//                                                       Gap(
//                                                         Constant.screenWidth *
//                                                             (4 /
//                                                                 Constant
//                                                                     .figmaScreenWidth),
//                                                       ),
//                                                       Text(
//                                                         "Biology",
//                                                         style: GoogleFonts
//                                                             .urbanist(
//                                                           fontSize: Constant
//                                                                   .screenHeight *
//                                                               (14 /
//                                                                   Constant
//                                                                       .figmaScreenHeight),
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           color: ctr.selectedSubjectName
//                                                                       .value ==
//                                                                   "Biology"
//                                                               ? const Color(
//                                                                   0xFFFFFFFF)
//                                                               : const Color(
//                                                                   0xFF010029),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       ...[
//                         Container(
//                           padding: EdgeInsets.only(
//                               top: 16, bottom: 16, left: 24, right: 24),
//                           height: 86,
//                           child: CustomTextField(
//                             hintText: 'Search topic',
//                             onChanged: (text) {
//                               ctr.onSearchChanged(text);
//                             },
//                             textEditingController: ctr.txt,
//                             prefixIcon: PhosphorIcons.magnifyingGlass(),
//                           ),
//                         ),
//                         ChapterList()
//                       ]
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         color: Colors.white,
//         padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 2),
//         child: AppBtn(
//             btnName: "Done",
//             onTapFunction: () {
//               Get.back();
//             }),
//       ),
//     );
//   }
// }