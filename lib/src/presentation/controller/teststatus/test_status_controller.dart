import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/presentation/controller/navigation/navigation_controller.dart';

class TestStatusController extends GetxController {
  final ctr = Get.find<Navigationcontroller>();
  RxInt currentPageIndex = RxInt(0);
  PageController pageController = PageController(initialPage: 0);
  var stdataPracticeTest = {}.obs;
  var stdataMockTest = {}.obs;
  var stdataChaptStatus = {}.obs;

  Rx<Ds<Map<String, dynamic>>> userState =
      Rx<Ds<Map<String, dynamic>>>(Initial());

  //chapter status;

  RxMap physics = RxMap({});
  RxMap chemistry = RxMap({});
  RxMap biology = RxMap({});

  RxInt chapIndex = RxInt(0);

  @override
  void onInit() {
    userState.value = Loading();
    super.onInit();
    log("controller initialized");
    listeNer();
  }

  void listeNer() {
    updateStats();
    ever(ctr.isLoading, (_) {
      log("breakpoint");
      if (ctr.isLoading.value) {
        userState.value = Loading();
        updateStats();
      }
    });
    ever(ctr.statsData, (_) {
      log("data updated");
      updateStats();
    });
  }

  void updateStats() {
    try {
      var statsData = Map<String, dynamic>.from(
          ctr.statsData); // Convert RxMap to a normal Map
      log("statsData: ${statsData["practice_test_stats"]}");

      if (statsData.isNotEmpty) {
        stdataPracticeTest.value = statsData["practice_test_stats"] ?? {};
        stdataMockTest.value = statsData["mock_test_stats"] ?? {};
        stdataChaptStatus.value = statsData["chapter_stats"] ?? {};

        log("stdataPracticeTest: $stdataPracticeTest");
        log("stdataMockTest: $stdataMockTest");
        log("stdataChaptStatus: $stdataChaptStatus");

        if (stdataChaptStatus.isNotEmpty) {
          seperateChapters();
        }

        // Update state to success with data
        userState.value = Success(data: statsData);
      } else {
        // If statsData is empty, set it as an error or empty state
        userState.value = Failed();
      }
    } catch (e) {
      log("Error updating stats: $e");
      userState.value = Failed();
    }
  }

  void seperateChapters() {
    log("in seperateChapters()");
    if (stdataChaptStatus.containsKey("Physics")) {
      physics.value = stdataChaptStatus['Physics'];
    }
    if (stdataChaptStatus.containsKey("Chemistry")) {
      chemistry.value = stdataChaptStatus["Chemistry"];
    }
    if (stdataChaptStatus.containsKey("Biology")) {
      biology.value = stdataChaptStatus["Biology"];
    }
  }

  void changeChapIndex({required int index}) {
    chapIndex.value = index;
  }

  void changePageIndex(int x) {
    log("index :$x");
    currentPageIndex.value = x;

    pageController.jumpToPage(currentPageIndex.value);
  }
}
