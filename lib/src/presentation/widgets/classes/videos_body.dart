import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/tex.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
import 'package:validators/validators.dart';

import 'video_listtile.dart';

class VideosBody extends StatelessWidget {
  const VideosBody({super.key});

  @override
  Widget build(BuildContext context) {
    VideosController videosController = Get.find<VideosController>();

    return Column(
      children: [
        Container(height: 20, color: Colors.amber),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Classes",
              style: GoogleFonts.urbanist(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),

        VideoListtile(
          index: 1,
          onTap: () {
            log("br");
            // videosController.onItemTapped(context, index);
            // videosController.updateKey();
            // Get.to(() => PlayVideo(currentVideoUrl: ''));
          },
          title: '',
          subTitle: '',
        ),
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: videosController.videoLessons.length,
        //     itemBuilder: (context, index) {
        //       log("length:${videosController.videoLessons.length}");
        //       return VideoListtile(
        //         index: index,
        //         onTap: () {
        //           log("br");
        //           // videosController.onItemTapped(context, index);
        //           // videosController.updateKey();
        //           // Get.to(() => PlayVideo(currentVideoUrl: ''));
        //         },
        //         title: '',
        //         subTitle: '',
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
// import 'package:neuflo_learn/src/presentation/screens/play_video/play_video.dart';
// import 'video_listtile.dart';

// class VideosBody extends StatelessWidget {
//   const VideosBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     VideosController videosController = Get.find<VideosController>();

//     return Column(
//       children: [
//         SizedBox(height: 20),
//         Align(
//           alignment: Alignment.topLeft,
//           child: Row(
//             children: [
//               SizedBox(width: 20),
//               Text(
//                 "Classes",
//                 style: GoogleFonts.urbanist(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: videosController.videoLessons.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   videosController.onItemTapped(
//                       context, index); // Update the video URL
//                   videosController.updateKey(); // Refresh the player
//                   Get.to(() => PlayVideo(
//                       currentVideoUrl:
//                           videosController.selectedVideoUrl.value));
//                 },
//                 child: VideoListtile(index: index),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
