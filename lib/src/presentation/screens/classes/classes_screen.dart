import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/screens/play_video/play_video.dart';

import 'package:neuflo_learn/src/presentation/widgets/classes/currently_playing.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/header.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/subject_card.dart';

import '../../../core/config/theme/colors.dart';
import '../../controller/classes/classes_controller.dart';

class Classes extends StatelessWidget {
  const Classes({super.key});

  @override
  Widget build(BuildContext context) {
    ClassesController classesController = Get.put(ClassesController());

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.statusBarColor,
      statusBarIconBrightness: Brightness.light,
    ));

    return Obx(() {
      return classesController.chapterstate.value.onState(onInitial: () {
        return Center(child: CircularProgressIndicator());
      }, success: (data) {
        // return SizedBox(
        //   height: MediaQuery.sizeOf(context).height,
        //   width: MediaQuery.sizeOf(context).width,
        //   child: Stack(
        //     children: [
        //       SafeArea(
        //         child: Column(
        //           children: [
        //             Header(),
        //             const SizedBox(height: 52),
        //             Expanded(
        //               child: Padding(
        //                 padding:
        //                     const EdgeInsets.only(top: 30, left: 20, right: 20),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     SizedBox(height: 12),
        //                     Text(
        //                       "Subjects",
        //                       style: GoogleFonts.urbanist(
        //                         fontWeight: FontWeight.w500,
        //                         fontSize: 24,
        //                       ),
        //                     ),
        //                     SizedBox(height: 18),
        //                     SubjectCard(
        //                       subName: "Physics",
        //                       currentcount: 2,
        //                       totalCount: classesController.physics.length,
        //                       onTap: () {
        //                         classesController.onSubjectSelected(subject: 1);
        //                       },
        //                     ),
        //                     SizedBox(height: 13),
        //                     SubjectCard(
        //                       subName: "Chemistry",
        //                       currentcount: 2,
        //                       totalCount: classesController.chemistry.length,
        //                       onTap: () {
        //                         classesController.onSubjectSelected(subject: 2);
        //                       },
        //                     ),
        //                     SizedBox(height: 13),
        //                     SubjectCard(
        //                       subName: "Biology",
        //                       currentcount: 2,
        //                       totalCount: classesController.biology.length,
        //                       onTap: () {
        //                         classesController.onSubjectSelected(subject: 3);
        //                       },
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Positioned(
        //         top: 180,
        //         left: 20,
        //         right: 20,
        //         child: LiveSection(
        //           onTapCallback: () async {
        //             await classesController.setchatId(
        //                 chatId: classesController.afterfiltered[0]
        //                     ['group_chat_id']);
        //             if (true) {
        //               Get.to(
        //                 () => PlayVideo(
        //                   isLive: true,
        //                   currentVideoUrl: classesController.afterfiltered[0]
        //                       ['video_url'],
        //                   subjectName: classesController.afterfiltered[0]
        //                       ['subject_name'],
        //                   chapterNo: 2,
        //                   topic: classesController.afterfiltered[0]
        //                       ['chaptername'],
        //                   videos: [],
        //                 ),
        //               );
        //             }
        //           },
        //           title: classesController.afterfiltered[0]['chaptername'],
        //           color: Colors.white,
        //           time: classesController.afterfiltered[0]['live_time'],
        //         ),
        //       ),
        //     ],
        //   ),
        // );

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Header(),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: 1,
                right: 1,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18, bottom: 10),
                        child: Text(
                          "Live Class",
                          style: GoogleFonts.urbanist(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 4),
                        child: LiveSection(
                          onTapCallback: () async {
                            log("live()");
                            await classesController.setchatId(
                                chatId: classesController.afterfiltered[0]
                                    ['group_chat_id']);
                            if (true) {
                              Get.to(
                                () => PlayVideo(
                                  isLive: true,
                                  currentVideoUrl: classesController
                                      .afterfiltered[0]['video_url'],
                                  subjectName: classesController
                                      .afterfiltered[0]['subject_name'],
                                  chapterNo: 2,
                                  topic: classesController.afterfiltered[0]
                                      ['chaptername'],
                                  videos: [],
                                ),
                              );
                            }
                          },
                          title: classesController.afterfiltered[0]
                              ['chaptername'],
                          color: Colors.white,
                          time: classesController.afterfiltered[0]['live_time'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Classes",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    "Brush up your course work",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: AppColors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "Subjects",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Color(0xff010029),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: SubjectCard(
                              subName: "Physics",
                              currentcount: 2,
                              totalCount: 10,
                              onTap: () {
                                classesController.onSubjectSelected(subject: 1);
                              },
                            ),
                          ),
                          SizedBox(height: 13),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: SubjectCard(
                              subName: "Chemistry",
                              currentcount: 2,
                              totalCount: 4,
                              onTap: () {
                                classesController.onSubjectSelected(subject: 2);
                              },
                            ),
                          ),
                          SizedBox(height: 13),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: SubjectCard(
                              subName: "Biology",
                              currentcount: 2,
                              totalCount: 5,
                              onTap: () {
                                classesController.onSubjectSelected(subject: 3);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }, onFailed: (failed) {
        return Scaffold(
          body: SafeArea(
              child: Center(
            child: Text("pls try again later"),
          )),
        );
      }, onLoading: () {
        return Center(child: CircularProgressIndicator());
      });
    });
  }
}
