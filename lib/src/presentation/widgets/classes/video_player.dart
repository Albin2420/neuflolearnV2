import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';
import 'package:neuflo_learn/src/presentation/widgets/yt_player/yt_player.dart';
import 'package:yt_player/yt_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    VideosController videosController = Get.find<VideosController>();
    String currentVideoUrl = "";

    return Obx(() => YtPlayer(
          key: videosController.videoKey.value, // Refresh player
          url: videosController.selectedVideoUrl.value.isNotEmpty
              ? videosController.selectedVideoUrl.value
              : currentVideoUrl, // Ensure video updates
          fullScreen: (bool) {}, isLive: false,
        ));
  }
}
