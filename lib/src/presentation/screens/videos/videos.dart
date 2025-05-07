import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/play_video/play_video.dart';

import '../../widgets/classes/video_listtile.dart';

class Videos extends StatelessWidget {
  int chapterNo;
  String chapterName;
  String subjectName;
  Videos(
      {super.key,
      required this.chapterNo,
      required this.chapterName,
      required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final clsctrl = Get.find<ClassesController>();
    VideosController videosController = Get.find<VideosController>();
    // Fetch the arguments passed from the previous page
    final List videos = Get.arguments ?? []; // Default to an empty list if null

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Image.asset('assets/images/vector.png'),
        ),
        title: Column(
          children: [
            Text(
              "Chapter $chapterNo",
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 200,
              height: 15,
              color: Colors.white,
              child: Center(
                child: Text(
                  chapterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Classes",
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            clsctrl.currentSelectedList[clsctrl.classIndex.value]['videos']
                    .isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: VideoListtile(
                            index: index,
                            onTap: () {
                              videosController.onItemTapped(context, index);
                              videosController.updateKey();
                              Get.to(
                                () => PlayVideo(
                                  currentVideoUrl: clsctrl.currentSelectedList[
                                          clsctrl.classIndex.value]['videos']
                                      [index]['video_url'],
                                  subjectName: subjectName,
                                  chapterNo: chapterNo,
                                  topic: chapterName,
                                  videos: clsctrl.currentSelectedList[
                                      clsctrl.classIndex.value]['videos'],
                                  isLive: false,
                                  isFakeLive: false,
                                ),
                              );
                            },
                            title: clsctrl.currentSelectedList[clsctrl
                                .classIndex.value]['videos'][index]['title'],
                            subTitle: clsctrl.currentSelectedList[clsctrl
                                .classIndex
                                .value]['videos'][index]['description'],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "No videos available",
                      style: GoogleFonts.urbanist(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
