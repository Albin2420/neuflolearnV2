// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
// import 'package:neuflo_learn/src/presentation/controller/custom_test/custom_test_controller.dart';
// import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
// import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/test_settings/test_settings_sheet.dart';
// import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/widgets/custom_test_exm_criteria.dart';
// import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';

// class CustomTestIntro extends StatelessWidget {
//   const CustomTestIntro({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ctr = Get.put(CustomTestController());
//     final examCtr = Get.find<ExamController>();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         shadowColor: const Color(0x00000008),
//         surfaceTintColor: Colors.white,
//         elevation: 10,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(Icons.close_rounded),
//         ),
//         title: Text(
//           "Custom Test",
//           style: GoogleFonts.urbanist(
//             fontSize: 19,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF010029),
//           ),
//         ),
//         flexibleSpace: Column(
//           children: [
//             const Spacer(), // This pushes the container to the bottom
//             Container(
//               height: 1,
//               decoration: BoxDecoration(boxShadow: [
//                 BoxShadow(
//                   color: Colors.black
//                       .withOpacity(0.2), // Shadow color with opacity
//                   offset: const Offset(0, 1), // Horizontal and Vertical offset
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: MediaQuery.sizeOf(context).height * 0.18,
//         padding: EdgeInsets.only(
//           left: Constant.screenWidth * (16 / Constant.figmaScreenWidth),
//           right: Constant.screenWidth * (16 / Constant.figmaScreenWidth),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 ctr.setCurrentSubjectName(sub: "Physics");
//                 ctr.fetchChapters(subId: 1);
//                 Get.to(
//                   () => TestSettingsSheet(),
//                   transition: Transition.downToUp,
//                   duration: Duration(milliseconds: 270),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Color(0xff000000), // Set the bottom border color
//                       width: 2.0, // Set the width of the bottom border
//                     ),
//                   ),
//                 ),
//                 height: 22,
//                 width: 150,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Edit test settings",
//                       style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w600, fontSize: 16),
//                     ),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     SizedBox(
//                       height: 16,
//                       width: 16,
//                       child: Image.asset("assets/icons/edit.png"),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             AppBtn(
//               btnName: 'Start Test',
//               onTapFunction: () async {
//                 if (ctr.selectedChapters.isEmpty) {
//                   Fluttertoast.showToast(
//                     msg: 'Select chapters from test settings to continue',
//                     backgroundColor: Colors.red,
//                   );
//                   return;
//                 }

//                 await examCtr.initiateCustomTestExam(
//                   chapters: ctr.selectedChapters,
//                   noOfQuestions: ctr.questionCount.value,
//                 );
//               },
//               iconImg: Icons.arrow_forward,
//             ),
//             SizedBox(
//                 height: Constant.screenWidth * (24 / Constant.figmaScreenWidth))
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: EdgeInsets.only(top: 40, bottom: 40),
//               width: MediaQuery.sizeOf(context).width,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     height: 56,
//                     width: 56,
//                     child: Image.asset("assets/icons/customtest.png"),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Custom Test",
//                         style: GoogleFonts.urbanist(
//                             fontWeight: FontWeight.w700, fontSize: 32),
//                       ),
//                       Text(
//                         "Customisable practice test ",
//                         style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Color(0xff02013B),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             CustomtestExamcriteria(
//               timeLimit: '2hr 35min',
//               noOfQuestion: '60',
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//               child: Divider(
//                 color: Color(0xff0000001a).withValues(alpha: 0.2),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16),
//                 child: SingleChildScrollView(
//                   child: Obx(() {
//                     return Wrap(
//                       alignment: WrapAlignment.center,
//                       runAlignment: WrapAlignment.center,
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       children: [
//                         ...ctr.selectedChapters.map(
//                           (e) => Text(
//                             "${e.chapterName},",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.urbanist(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/custom_test/custom_test_controller.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/test_settings/test_settings_sheet.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/widgets/custom_test_exm_criteria.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';

class CustomTestIntro extends StatelessWidget {
  const CustomTestIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(CustomTestController());
    final examCtr = Get.find<ExamController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: const Color(0x00000008),
        surfaceTintColor: Colors.white,
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close_rounded),
        ),
        title: Text(
          "Custom Test",
          style: GoogleFonts.urbanist(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF010029),
          ),
        ),
        flexibleSpace: Column(
          children: [
            const Spacer(), // This pushes the container to the bottom
            Container(
              height: 1,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Shadow color with opacity
                  offset: const Offset(0, 1), // Horizontal and Vertical offset
                ),
              ]),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 40, bottom: 20),
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 56,
                            width: 56,
                            child: Image.asset("assets/icons/customtest.png"),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: [
                              Text(
                                "Custom Test",
                                style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.w700, fontSize: 32),
                              ),
                              Text(
                                "Customisable practice test ",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xff02013B),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CustomtestExamcriteria(
                  shadow: false, timeLimit: '2hr 35min', noOfQuestion: '60'),
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                height: 24,
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48, right: 48, top: 22),
                child: Obx(
                  () => Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...ctr.selectedChapters.map(
                        (e) => Text(
                          "${e.chapterName},",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                ctr.setCurrentSubjectName(sub: "Physics");
                ctr.fetchChapters(subId: 1);
                Get.to(
                  () => TestSettingsSheet(),
                  transition: Transition.downToUp,
                  duration: Duration(milliseconds: 270),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff000000), // Set the bottom border color
                      width: 2.0, // Set the width of the bottom border
                    ),
                  ),
                ),
                height: 22,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit test settings",
                      style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: Image.asset("assets/icons/edit.png"),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            AppBtn(
              btnName: 'Start Test',
              onTapFunction: () async {
                if (ctr.selectedChapters.isEmpty) {
                  Fluttertoast.showToast(
                      msg: 'Select chapters from test settings to continue',
                      backgroundColor: Colors.black,
                      textColor: Colors.white);
                  return;
                }

                await examCtr.initiateCustomTestExam(
                  physicsChapters: ctr.physicsSelectedChapters,
                  chemistryChapters: ctr.chemistrySelectedChapters,
                  biologyChapters: ctr.biologySelectedChapters,
                  noOfQuestions: ctr.questionCount.value,
                );
              },
              iconImg: Icons.arrow_forward,
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
