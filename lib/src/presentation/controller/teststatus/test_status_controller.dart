import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/repositories/stats/stats_repo_impl.dart';
import 'package:neuflo_learn/src/domain/repositories/stats/stats_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/navigation/navigation_controller.dart';

class TestStatusController extends GetxController {
  final appctr = Get.find<AppStartupController>();
  final ctr = Get.find<Navigationcontroller>();
  RxInt currentPageIndex = RxInt(0);
  PageController pageController = PageController(initialPage: 0);
  var stdataPracticeTest = {}.obs;
  var stdataMockTest = {}.obs;
  var stdataChaptStatus = {}.obs;
  StatsRepo stRepo = StatsRepoImpl();

  Rx<Ds<Map<String, dynamic>>> userState =
      Rx<Ds<Map<String, dynamic>>>(Initial());

  //chapter status;

  RxMap physics = RxMap({});
  RxMap chemistry = RxMap({});
  RxMap biology = RxMap({});

  RxInt chapIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    log("TestStatusController initialized");
    userState.value = Loading();
    weeklystats();
  }

  Future<void> weeklystats() async {
    final result = await stRepo.weeklystats(
        accessToken: await appctr.getAccessToken() ?? '');

    result.fold((f) async {
      log("Error in weeklystats(): ${f.message}");
      userState.value = Failed();
    }, (r) {
      log("R:$r");
      stdataPracticeTest.value = r['practice_test_stats'];
      stdataMockTest.value = r['mock_test_stats'];
      stdataChaptStatus.value = r['chapter_stats'];

      if (stdataChaptStatus.isNotEmpty ||
          stdataMockTest.isNotEmpty ||
          stdataChaptStatus.isNotEmpty) {
        seperateChapters();
      }
    });
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
    userState.value = Success(data: {});
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
