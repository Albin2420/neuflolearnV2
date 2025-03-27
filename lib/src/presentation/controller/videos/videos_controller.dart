import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideosController extends GetxController {
  RxString videoName = "Electric Charges & ElectroMagnetic Fields".obs;
  RxList<Map<String, dynamic>> videoLessons = <Map<String, dynamic>>[].obs;
  RxString selectedVideoUrl = "".obs;
  RxString selectedVideoTitle = "".obs;

  Rx<UniqueKey> videoKey = Rx(UniqueKey());
  RxBool showAppbar = true.obs;

  @override
  void onInit() {
    log("i am here");
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    log("i am back disposed");
  }

  void setupVideos({required List<Map<String, dynamic>> listOfVideos}) {
    videoLessons.value = listOfVideos;
    if (videoLessons.isNotEmpty) {
      selectedVideoUrl.value = videoLessons.first['videoUrl'] ?? "";
      selectedVideoTitle.value = videoLessons.first['videoTitle'] ?? "";
    }
    log("videoLessons: $videoLessons");
  }

  void updateKey() {
    videoKey.value = UniqueKey(); // Updates key to rebuild the player
    log("Key updated");
  }

  void onItemTapped(BuildContext context, int index) {
    if (index >= 0 && index < videoLessons.length) {
      selectedVideoUrl.value = videoLessons[index]['videoUrl'] ?? "";
      selectedVideoTitle.value = videoLessons[index]['videoTitle'] ?? "";
      updateKey(); // Force player update
      log("New Video URL => ${selectedVideoUrl.value} | New Video Title => ${selectedVideoTitle.value}");
    } else {
      log("Invalid index: $index");
    }
  }

  Duration convertSecondsToDuration(int seconds) {
    return Duration(seconds: seconds);
  }
}
