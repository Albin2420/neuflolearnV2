import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/coming_up_videos.dart';
import 'package:neuflo_learn/src/presentation/widgets/yt_player/yt_player.dart';
import 'package:yt_player/yt_player.dart' show YtPlayer;

class PlayVideo extends StatelessWidget {
  int chapterNo;
  String chapterName;
  String subjectName;
  List videos;

  PlayVideo(
      {super.key,
      required this.currentVideoUrl,
      required this.chapterNo,
      required this.chapterName,
      required this.subjectName,
      required this.videos});

  final String currentVideoUrl;

  @override
  Widget build(BuildContext context) {
    VideosController videosController = Get.put(VideosController());
    log("chapterNo : $chapterNo, chapterName : $chapterName, subjectName : $subjectName");
    // log("Video List : $videos");
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
                          chapterName,
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

                // title: Row(
                //   children: [
                //     Column(
                //       children: [
                //         Expanded(
                // child: Text(
                //   chapterName,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: GoogleFonts.urbanist(
                //     color: Colors.black,
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                //         ),
                // Text(
                //   "$subjectName - Chapter $chapterNo",
                //   style: GoogleFonts.urbanist(
                //       color: Colors.black, fontSize: 12),
                // )
                //       ],
                //     ),
                //   ],
                // ),

                // title: PlayAppbar(
                //     chapterNo: chapterNo,
                //     chapterName: chapterName,
                //     subjectName: subjectName),
              )
            //         title: PlayAppbar(
            //             chapterNo: chapterNo,
            //             chapterName: chapterName,
            //             subjectName: subjectName),
            //       )
            //     // ? PlayAppbar(
            //     //     chapterNo: chapterNo,
            //     //     chapterName: chapterName,
            //     //     subjectName: subjectName,
            // ),
            : null,
        body: Column(
          children: [
            YtPlayer(
              url: currentVideoUrl,
              isLive: false,
              key: videosController.videoKey.value,
              fullScreen: (x) {
                log("Full screen : $x");
                x == true
                    ? videosController.showAppbar.value = false
                    : videosController.showAppbar.value = true;
                // videosController.showAppbar.value = false;
              },
            ),
            videosController.showAppbar.value
                ? SizedBox(
                    height: 20,
                  )
                : SizedBox.shrink(),
            ComingUpVideos(videos: videos),
          ],
        ),
        // body: SafeArea(
        //   child: Column(
        //     children: [
        //       YtPlayer(
        //         url: currentVideoUrl,
        //         // key: videosController.videoKey.value, // Refresh player
        //         // url: videosController.selectedVideoUrl.value.isNotEmpty
        //         //     ? videosController.selectedVideoUrl.value
        //         //     : currentVideoUrl, // Ensure video updates
        // fullScreen: (x) {
        //   log("Full screen : $x");
        //   videosController.showAppbar.value = false;
        // },
        //         isLive: false,
        //       ),
        //       videosController.showAppbar.value
        //           ? ComingUpTitle()
        //           : SizedBox.shrink(),
        //       videosController.showAppbar.value
        //           ? ComingUpVideos(
        //               videos: videos,
        //             )
        //           : SizedBox.shrink(),
        //     ],
        //   ),
        // ),
      );
    });
  }
}
