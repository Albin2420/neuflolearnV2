import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/video_listtile.dart';

class ComingUpVideos extends StatelessWidget {
  final List videos;
  const ComingUpVideos({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    VideosController videosController = Get.find<VideosController>();
    // log("Videos inside coming up => $videos");
    return Expanded(
      child: Container(
        height: 300,
        color: AppColors.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20, top: 19),
              child: Text("Coming Up Next",
                  style: GoogleFonts.urbanist(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return VideoListtile(
                    index: index,
                    onTap: () {
                      videosController.onItemTapped(context, index);
                      videosController.updateKey();
                    },
                    title: videos[index]['title'],
                    subTitle: videos[index]['description'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    // return Expanded(
    //   child: ListView.builder(
    //     itemCount: videos.length,
    //     itemBuilder: (context, index) {
    // final video = videos[index];
    // return ListTile(
    //   tileColor: Colors.red,
    //   title: Text(
    //     video['videoTitle'] ?? "Untitled",
    //     style: TextStyle(color: Colors.black),
    //   ),
    //   onTap: () {
    //     log("Tapped on index: $index");
    //     log("Video URL => ${video['videoUrl']}");
    //     videosController.onItemTapped(context, index);
    //     videosController.updateKey();
    //   },
    // );
    //     },
    //   ),
    // );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';

// class ComingUpVideos extends StatelessWidget {
//   List videos;
//   ComingUpVideos({super.key, required this.videos});

//   @override
//   Widget build(BuildContext context) {
//     VideosController videosController = Get.find<VideosController>();
//     return Expanded(
//       child: ListView.builder(
//         itemCount: videosController.videoLessons.length,
//         itemBuilder: (context, index) {
//           return Text(
//             "data",
//             style: TextStyle(color: Colors.black),
//           );
//           // return Column(
//           //   children: [
//           //     VideoListtile(
//           //       title: '',
//           //       subTitle: '',
//           //       index: index,
//           //       onTap: () {
//           //         log("message");
//           //         // log("videosController.videoLessons[index].videoUrl => ${videosController.videoLessons[index].videoUrl}");
//           //         videosController.onItemTapped(
//           //             context, index); // Update the video URL
//           //         videosController.updateKey(); // Refresh the player
//           //       },
//           //     ),
//           //   ],
//           // );
//         },
//       ),
//     );
//   }
// }
