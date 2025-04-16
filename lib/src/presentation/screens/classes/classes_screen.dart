import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neuflo_learn/src/presentation/screens/play_video/play_video.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/currently_playing.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/header.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/subject_card.dart';
import 'package:neuflo_learn/src/presentation/widgets/failure/failureResponse.dart';

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
      }, success: (data) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Header(),
              RefreshIndicator(
                color: Color(0xff010029),
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await Future.wait([
                    classesController.reFresh(),
                    Future.delayed(Duration(seconds: 5)),
                  ]);
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
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
                            classesController.afterfiltered.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.035,
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                  ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Subjects",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: classesController.afterfiltered.isEmpty
                                      ? Colors.white
                                      : Color(0xff010029),
                                ),
                              ),
                            ),
                            SizedBox(height: 18),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: SubjectCard(
                                subName: "Physics",
                                currentcount: 2,
                                totalCount: 10,
                                onTap: () {
                                  classesController.onSubjectSelected(
                                      subject: 1);
                                },
                              ),
                            ),
                            SizedBox(height: 13),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: SubjectCard(
                                subName: "Chemistry",
                                currentcount: 2,
                                totalCount: 4,
                                onTap: () {
                                  classesController.onSubjectSelected(
                                      subject: 2);
                                },
                              ),
                            ),
                            SizedBox(height: 13),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: SubjectCard(
                                subName: "Biology",
                                currentcount: 2,
                                totalCount: 5,
                                onTap: () {
                                  classesController.onSubjectSelected(
                                      subject: 3);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              classesController.afterfiltered.isEmpty
                  ? SizedBox()
                  : Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: 1,
                      right: 1,
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18, bottom: 10),
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
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 4),
                              child: Obx(
                                () {
                                  final video =
                                      classesController.afterfiltered.first;
                                  return LiveSection(
                                    onTapCallback: () async {
                                      bool x = classesController.isLiveActive(
                                          liveEnd: video['live_end_time'],
                                          liveBegins: video['live_time']);
                                      if (x) {
                                        await classesController.setchatId(
                                            chatId: video['group_chat_id']);
                                        Get.to(
                                          () => PlayVideo(
                                            isLive: true,
                                            currentVideoUrl: video['video_url'],
                                            subjectName: video['subject_name'],
                                            chapterNo: 2,
                                            topic: video['chaptername'],
                                            videos: [],
                                          ),
                                        );
                                      } else {
                                        log("live expired()");
                                      }
                                    },
                                    title: video['chaptername'],
                                    color: Colors.white,
                                    time: video['live_time'],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        );
      }, onFailed: (failed) {
        return FailureUi(
          onTapFunction: () {
            classesController.reFresh();
          },
        );
      }, onLoading: () {
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
      });
    });
  }
}
