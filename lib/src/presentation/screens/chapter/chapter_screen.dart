import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/chapter/chapter_controller.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/videos/videos.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/appbar_widget%20copy.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/chapter_tile%20copy.dart';

import '../../controller/videos/videos_controller.dart';

class ChapterPage extends StatelessWidget {
  final String subjectName;

  const ChapterPage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    ClassesController classesController = Get.find<ClassesController>();
    VideosController videosController = Get.put(VideosController());
    ChapterController chapterController = Get.put(ChapterController());
    log("Subject name from class => $subjectName");

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        subjectName: subjectName,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chapters",
              style: GoogleFonts.urbanist(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            classesController.currentSelectedList.isEmpty
                ? Text(
                    "No chapters found",
                    style: GoogleFonts.urbanist(color: Colors.black),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: classesController.currentSelectedList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ChapterTile(
                          index: index,
                          onTap: () {
                            log("vdo:${classesController.currentSelectedList[index]['videos']}");
                            classesController.classIndex.value = index;
                            Get.to(
                              () => Videos(
                                chapterNo: index + 1,
                                chapterName: classesController
                                    .currentSelectedList[index]['chaptername'],
                                subjectName: subjectName,
                              ),
                              arguments: classesController
                                  .currentSelectedList[index]['videos'],
                            );
                          },
                          title:
                              "${classesController.currentSelectedList[index]['chaptername']}",
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
