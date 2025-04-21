import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/setup_account/setup_account_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/widgets/addTopic_card.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TargetCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? iconImg;
  final Color color;
  final bool showBottomSheet;
  final int selectedChapterCount;
  final String type;

  const TargetCard(
      {super.key,
      required this.title,
      this.description,
      this.iconImg,
      required this.color,
      required this.showBottomSheet,
      required this.type,
      required this.selectedChapterCount});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<SetupAccountController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctr.setChapterCount(title: title, type: type);
    });
    return GestureDetector(
      onTap: () async {
        log('clicked :: $title');
        int subId = title == "Physics"
            ? 1
            : title == "Chemistry"
                ? 2
                : 3;
        ctr.fetchChapters(subId: subId);
        showBottomSheet
            ? showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: const Color(0xFFEDF1F2),
                context: context,
                builder: (ctx) {
                  return SingleChildScrollView(
                    controller: ctr.scrollController,
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      height: Constant.screenHeight - 45,
                      width: Constant.screenWidth,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color.fromRGBO(2, 1, 42, 0.1),
                            ),
                          ),
                          Gap(
                            Constant.screenHeight *
                                (12 / Constant.figmaScreenHeight),
                          ),
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                      title,
                                      style: GoogleFonts.urbanist(
                                          fontSize: Constant.screenWidth *
                                              (16 / Constant.figmaScreenWidth),
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                              1, 0, 41, 1)),
                                    ),
                                    Text(
                                      "Tap to select strengths",
                                      style: GoogleFonts.urbanist(
                                        fontSize: Constant.screenWidth *
                                            (14 / Constant.figmaScreenWidth),
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromRGBO(2, 1, 61, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(PhosphorIcons.x()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Expanded(
                              child: SizedBox(
                            height: Constant.screenHeight * 0.74,
                            child: Obx(() {
                              List<int> excludedIds = type == "Strength"
                                  ? ctr.weaknessMap.values
                                      .expand((list) => list)
                                      .cast<int>()
                                      .toList()
                                  : ctr.strengthMap.values
                                      .expand((list) => list)
                                      .cast<int>()
                                      .toList();
                              return ctr.chapterState.value.onState(
                                onInitial: () => SizedBox(),
                                success: (data) {
                                  // Filter out the chapters that are already selected in the opposite list
                                  var filteredChapters = data
                                      .where((chapter) => !excludedIds
                                          .contains(chapter.chapterId))
                                      .toList();

                                  return ListView.builder(
                                    padding: EdgeInsets.only(bottom: 10),
                                    controller: ScrollController(),
                                    scrollDirection: Axis.vertical,
                                    physics: const ScrollPhysics(),
                                    itemCount: filteredChapters.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var chapter = filteredChapters[index];

                                      int key = ctr.mapSubjectToId(
                                          title.substring(0, 3));

                                      List<int> list = [];
                                      if (type == "Strength") {
                                        list = List.from(
                                            ctr.strengthMap['$key'] ?? []);
                                      } else {
                                        list = List.from(
                                            ctr.weaknessMap['$key'] ?? []);
                                      }

                                      return AddTopicCard(
                                        text: chapter.chapterName ?? '',
                                        value: list.contains(chapter.chapterId),
                                        onTap: (isSelected) {
                                          if (type == "Strength") {
                                            ctr.addStrength(
                                              subject: title,
                                              chapterName:
                                                  chapter.chapterName ?? '',
                                              chapterId: chapter.chapterId ?? 0,
                                            );
                                          } else {
                                            ctr.addWeakness(
                                              subject: title,
                                              chapterName:
                                                  chapter.chapterName ?? '',
                                              chapterId: chapter.chapterId ?? 0,
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                                onFailed: (error) => SizedBox(
                                  height: Constant.screenHeight * 0.74,
                                  child: Center(
                                    child: Text(
                                        'Chapter failed to load! Try again'),
                                  ),
                                ),
                                onLoading: () => SizedBox(
                                  height: Constant.screenHeight * 0.74,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.green),
                                  ),
                                ),
                              );
                            }),
                          )),
                          AppBtn(
                              btnName: "Done",
                              onTapFunction: () => Navigator.pop(context)),
                          Gap(
                            Constant.screenHeight *
                                (16 / Constant.figmaScreenHeight),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const CircularProgressIndicator();
      },
      child: showBottomSheet == false
          ? GestureDetector(
              onTap: () {
                ctr.setChapterCount(title: title, type: type);
              },
              child: Container(
                padding: EdgeInsets.all(
                    Constant.screenWidth * (16 / Constant.figmaScreenWidth)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    // color: tapped == true
                    //     ? const Color(0xff02012A)
                    //     : const Color(0x2002012A),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        iconImg != null
                            ? Center(child: Icon(iconImg))
                            : const SizedBox.shrink(),
                        Gap(Constant.screenWidth *
                            (12 / Constant.figmaScreenWidth)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(title,
                                    style: GoogleFonts.urbanist(
                                      fontSize: Constant.screenHeight *
                                          (20 / Constant.figmaScreenHeight),
                                      fontWeight: FontWeight.w600,
                                    )),
                                Gap(Constant.screenWidth *
                                    (8 / Constant.figmaScreenWidth)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Constant.screenWidth *
                                        (8 / Constant.figmaScreenWidth),
                                    vertical: Constant.screenHeight *
                                        (2 / Constant.figmaScreenHeight),
                                  ),
                                  height: Constant.screenHeight *
                                      (16 / Constant.figmaScreenHeight),
                                  decoration: ShapeDecoration(
                                    color: color,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '0 topics selected',
                                      style: TextStyle(
                                        color: const Color(0xFFF7FEFF),
                                        fontSize: Constant.screenHeight *
                                            (10 / Constant.figmaScreenHeight),
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: Constant.screenWidth - 180,
                              child: Text(
                                description!,
                                style: GoogleFonts.urbanist(
                                  fontSize: Constant.screenHeight *
                                      (14 / Constant.figmaScreenHeight),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(Constant.screenWidth *
                        (24 / Constant.figmaScreenWidth)),
                  ],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(
                  Constant.screenWidth * (16 / Constant.figmaScreenWidth)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  // color: tapped == true
                  //     ? const Color(0xff02012A)
                  //     : const Color(0x2002012A),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // iconImg != null
                      //     ? Center(child: Icon(widget.iconImg))
                      //     : const SizedBox.shrink(),
                      Gap(Constant.screenWidth *
                          (12 / Constant.figmaScreenWidth)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(title,
                                  style: GoogleFonts.urbanist(
                                    fontSize: Constant.screenHeight *
                                        (20 / Constant.figmaScreenHeight),
                                    fontWeight: FontWeight.w600,
                                  )),
                              Gap(Constant.screenWidth *
                                  (8 / Constant.figmaScreenWidth)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Constant.screenWidth *
                                      (8 / Constant.figmaScreenWidth),
                                  vertical: Constant.screenHeight *
                                      (2 / Constant.figmaScreenHeight),
                                ),
                                height: Constant.screenHeight *
                                    (16 / Constant.figmaScreenHeight),
                                decoration: ShapeDecoration(
                                  color: color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Center(child: Builder(
                                  builder: (context) {
                                    return Text(
                                      '$selectedChapterCount topics selected',
                                      style: TextStyle(
                                        color: const Color(0xFFF7FEFF),
                                        fontSize: Constant.screenHeight *
                                            (10 / Constant.figmaScreenHeight),
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                )),
                              )
                            ],
                          ),
                          SizedBox(
                            width: Constant.screenWidth - 180,
                            child: Text(
                              description ?? '',
                              style: GoogleFonts.urbanist(
                                fontSize: Constant.screenHeight *
                                    (14 / Constant.figmaScreenHeight),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(Constant.screenWidth * (24 / Constant.figmaScreenWidth)),
                ],
              ),
            ),
    );
  }
}

























// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
// import 'package:neuflo_learn/src/presentation/controller/setup_account/setup_account_controller.dart';
// import 'package:neuflo_learn/src/presentation/screens/account_setup/widgets/addTopic_card.dart';
// import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

// class TargetCard extends StatelessWidget {
//   final String title;
//   final String? description;
//   final IconData? iconImg;
//   final Color color;
//   final bool showBottomSheet;
//   final int selectedChapterCount;
//   final String type;

//   const TargetCard(
//       {super.key,
//       required this.title,
//       this.description,
//       this.iconImg,
//       required this.color,
//       required this.showBottomSheet,
//       required this.type,
//       required this.selectedChapterCount});

//   @override
//   Widget build(BuildContext context) {
//     final ctr = Get.find<SetupAccountController>();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ctr.setChapterCount(title: title, type: type);
//     });
//     return GestureDetector(
//       onTap: () async {
//         log('clicked :: $title');
//         int subId = title == "Physics"
//             ? 1
//             : title == "Chemistry"
//                 ? 2
//                 : 3;
//         ctr.fetchChapters(subId: subId);
//         showBottomSheet
//             ? showModalBottomSheet(
//                 isScrollControlled: true,
//                 backgroundColor: const Color(0xFFEDF1F2),
//                 context: context,
//                 builder: (ctx) {
//                   return SingleChildScrollView(
//                     controller: ctr.scrollController,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: Constant.screenWidth *
//                             (16 / Constant.figmaScreenWidth),
//                       ),
//                       height: Constant.screenHeight - 45,
//                       width: Constant.screenWidth,
//                       child: Column(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             height: 4,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               color: const Color.fromRGBO(2, 1, 42, 0.1),
//                             ),
//                           ),
//                           Gap(
//                             Constant.screenHeight *
//                                 (12 / Constant.figmaScreenHeight),
//                           ),
//                           Stack(
//                             children: [
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       title,
//                                       style: GoogleFonts.urbanist(
//                                           fontSize: Constant.screenWidth *
//                                               (16 / Constant.figmaScreenWidth),
//                                           fontWeight: FontWeight.w600,
//                                           color: const Color.fromRGBO(
//                                               1, 0, 41, 1)),
//                                     ),
//                                     Text(
//                                       "Tap to select strengths",
//                                       style: GoogleFonts.urbanist(
//                                         fontSize: Constant.screenWidth *
//                                             (14 / Constant.figmaScreenWidth),
//                                         fontWeight: FontWeight.w500,
//                                         color:
//                                             const Color.fromRGBO(2, 1, 61, 1),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Positioned(
//                                 right: 0,
//                                 child: IconButton(
//                                   icon: Icon(PhosphorIcons.x()),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Scrollbar(
//                             controller: ctr.scrollController,
//                             scrollbarOrientation: ScrollbarOrientation.right,
//                             thickness: 2,
//                             trackVisibility: true,
//                             thumbVisibility: true,
//                             child: SingleChildScrollView(
//                               child: SizedBox(
//                                 height: Constant.screenHeight * 0.74,
//                                 child: Obx(
//                                   () {
//                                     return ctr.chapterState.value.onState(
//                                       onInitial: () => SizedBox(),
//                                       success: (data) {
//                                         return ListView.builder(
//                                           controller: ScrollController(),
//                                           scrollDirection: Axis.vertical,
//                                           physics: const ScrollPhysics(),
//                                           itemCount: data.length,
//                                           shrinkWrap: true,
//                                           itemBuilder: (context, index) {
//                                             log("id:${data[index].chapterId}");

//                                             int key = ctr.mapSubjectToId(
//                                                 title.substring(0, 3));

//                                             List<int> list = [];

//                                             if (type == "Strength") {
//                                               if (ctr.strengthMap.isNotEmpty) {
//                                                 list = List.from(
//                                                     ctr.strengthMap['$key'] ??
//                                                         []);
//                                               }
//                                               log('strenth list:$list');
//                                             } else {
//                                               if (ctr.weaknessMap.isNotEmpty) {
//                                                 list = List.from(
//                                                     ctr.weaknessMap['$key'] ??
//                                                         []);
//                                                 log('week list:$list');
//                                               }
//                                             }

//                                             return AddTopicCard(
//                                               text:
//                                                   data[index].chapterName ?? '',
//                                               value: list.isEmpty
//                                                   ? false
//                                                   : list.contains(
//                                                       data[index].chapterId),
//                                               onTap: (isSelected) {
//                                                 log("key:$key");

//                                                 if (type == "Strength") {
//                                                   ctr.addStrength(
//                                                     subject: title,
//                                                     chapterName: data[index]
//                                                             .chapterName ??
//                                                         '',
//                                                     chapterId:
//                                                         data[index].chapterId ??
//                                                             0,
//                                                   );
//                                                 } else {
//                                                   ctr.addWeakness(
//                                                     subject: title,
//                                                     chapterName: data[index]
//                                                             .chapterName ??
//                                                         '',
//                                                     chapterId:
//                                                         data[index].chapterId ??
//                                                             0,
//                                                   );
//                                                 }
//                                               },
//                                             );
//                                           },
//                                         );
//                                       },
//                                       onFailed: (error) => SizedBox(
//                                         height: Constant.screenHeight * 0.74,
//                                         child: Center(
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                   'Chapter failed to load! Try again'),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       onLoading: () => SizedBox(
//                                         height: Constant.screenHeight * 0.74,
//                                         child: Center(
//                                           child: Transform.scale(
//                                             scale: 0.5,
//                                             child: CircularProgressIndicator(
//                                               color: Colors.green,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           AppBtn(
//                               btnName: "Done",
//                               onTapFunction: () => Navigator.pop(context)),
//                           Gap(
//                             Constant.screenHeight *
//                                 (16 / Constant.figmaScreenHeight),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : const CircularProgressIndicator();
//       },
//       child: showBottomSheet == false
//           ? GestureDetector(
//               onTap: () {
//                 ctr.setChapterCount(title: title, type: type);
//               },
//               child: Container(
//                 padding: EdgeInsets.all(
//                     Constant.screenWidth * (16 / Constant.figmaScreenWidth)),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     width: 1,
//                     // color: tapped == true
//                     //     ? const Color(0xff02012A)
//                     //     : const Color(0x2002012A),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         iconImg != null
//                             ? Center(child: Icon(iconImg))
//                             : const SizedBox.shrink(),
//                         Gap(Constant.screenWidth *
//                             (12 / Constant.figmaScreenWidth)),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(title,
//                                     style: GoogleFonts.urbanist(
//                                       fontSize: Constant.screenHeight *
//                                           (20 / Constant.figmaScreenHeight),
//                                       fontWeight: FontWeight.w600,
//                                     )),
//                                 Gap(Constant.screenWidth *
//                                     (8 / Constant.figmaScreenWidth)),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: Constant.screenWidth *
//                                         (8 / Constant.figmaScreenWidth),
//                                     vertical: Constant.screenHeight *
//                                         (2 / Constant.figmaScreenHeight),
//                                   ),
//                                   height: Constant.screenHeight *
//                                       (16 / Constant.figmaScreenHeight),
//                                   decoration: ShapeDecoration(
//                                     color: color,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(18),
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       '0 topics selected',
//                                       style: TextStyle(
//                                         color: const Color(0xFFF7FEFF),
//                                         fontSize: Constant.screenHeight *
//                                             (10 / Constant.figmaScreenHeight),
//                                         fontFamily: 'Urbanist',
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               width: Constant.screenWidth - 180,
//                               child: Text(
//                                 description!,
//                                 style: GoogleFonts.urbanist(
//                                   fontSize: Constant.screenHeight *
//                                       (14 / Constant.figmaScreenHeight),
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Gap(Constant.screenWidth *
//                         (24 / Constant.figmaScreenWidth)),
//                   ],
//                 ),
//               ),
//             )
//           : Container(
//               padding: EdgeInsets.all(
//                   Constant.screenWidth * (16 / Constant.figmaScreenWidth)),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   width: 1,
//                   // color: tapped == true
//                   //     ? const Color(0xff02012A)
//                   //     : const Color(0x2002012A),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       // iconImg != null
//                       //     ? Center(child: Icon(widget.iconImg))
//                       //     : const SizedBox.shrink(),
//                       Gap(Constant.screenWidth *
//                           (12 / Constant.figmaScreenWidth)),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(title,
//                                   style: GoogleFonts.urbanist(
//                                     fontSize: Constant.screenHeight *
//                                         (20 / Constant.figmaScreenHeight),
//                                     fontWeight: FontWeight.w600,
//                                   )),
//                               Gap(Constant.screenWidth *
//                                   (8 / Constant.figmaScreenWidth)),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: Constant.screenWidth *
//                                       (8 / Constant.figmaScreenWidth),
//                                   vertical: Constant.screenHeight *
//                                       (2 / Constant.figmaScreenHeight),
//                                 ),
//                                 height: Constant.screenHeight *
//                                     (16 / Constant.figmaScreenHeight),
//                                 decoration: ShapeDecoration(
//                                   color: color,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                 ),
//                                 child: Center(child: Builder(
//                                   builder: (context) {
//                                     return Text(
//                                       '$selectedChapterCount topics selected',
//                                       style: TextStyle(
//                                         color: const Color(0xFFF7FEFF),
//                                         fontSize: Constant.screenHeight *
//                                             (10 / Constant.figmaScreenHeight),
//                                         fontFamily: 'Urbanist',
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     );
//                                   },
//                                 )),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             width: Constant.screenWidth - 180,
//                             child: Text(
//                               description ?? '',
//                               style: GoogleFonts.urbanist(
//                                 fontSize: Constant.screenHeight *
//                                     (14 / Constant.figmaScreenHeight),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Gap(Constant.screenWidth * (24 / Constant.figmaScreenWidth)),
//                 ],
//               ),
//             ),
//     );
//   }
// }



