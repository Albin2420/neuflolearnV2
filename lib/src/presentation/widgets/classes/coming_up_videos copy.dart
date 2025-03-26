import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/video_listtile.dart';

class ComingUpVideos extends StatelessWidget {
  const ComingUpVideos({super.key});

  @override
  Widget build(BuildContext context) {
    VideosController videosController = Get.find<VideosController>();
    return Expanded(
      child: ListView.builder(
        itemCount: videosController.videoLessons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                // log("videosController.videoLessons[index].videoUrl => ${videosController.videoLessons[index].videourl}");
                videosController.onItemTapped(
                    context, index); // Update the video URL
                videosController.updateKey(); // Refresh the player
              },
              child: VideoListtile(
                index: index,
                onTap: () {},
                title: '',
                subTitle: '',
              ));
        },
      ),
    );
  }
}


