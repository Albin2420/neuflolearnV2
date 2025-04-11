import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/coming_up_videos.dart';
import 'package:neuflo_learn/src/presentation/widgets/chat/liveChat.dart';
import 'package:neuflo_learn/src/presentation/widgets/yt_player/yt_player.dart';

class PlayVideo extends StatelessWidget {
  int chapterNo;
  String topic;
  String subjectName;
  List videos;
  bool isLive;

  PlayVideo(
      {super.key,
      required this.currentVideoUrl,
      required this.chapterNo,
      required this.topic,
      required this.subjectName,
      required this.videos,
      required this.isLive});

  final String currentVideoUrl;

  @override
  Widget build(BuildContext context) {
    VideosController videosController = Get.put(VideosController());

    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: videosController.showAppbar.value
            ? AppBar(
                backgroundColor: Colors.white,
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                    child: Icon(Icons.close),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          topic,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$subjectName - Chapter $chapterNo",
                          style: GoogleFonts.urbanist(
                              color: Colors.black, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
              )
            : null,
        body: Column(
          children: [
            YtPlayer(
              // durationNow: videosController.convertSecondsToDuration(300),
              isfakeLive: isLive,
              url: currentVideoUrl,
              isLive: isLive,
              key: videosController.videoKey.value,
              fullScreen: (x) {
                x == true
                    ? videosController.showAppbar.value = false
                    : videosController.showAppbar.value = true;
              },
              // isvideoEnded: (y) {},
            ),
            isLive
                ? Expanded(child: LiveChat())
                : ComingUpVideos(
                    videos: videos,
                  )
          ],
        ),
      );
    });
  }
}
