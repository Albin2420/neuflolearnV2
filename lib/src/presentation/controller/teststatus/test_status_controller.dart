import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/navigationcontroller/navigationcontroller.dart';

class TestStatusController extends GetxController {
  final ctr = Get.find<Navigationcontroller>();
  RxInt currentPageIndex = RxInt(0);
  PageController pageController = PageController(initialPage: 0);
  var stdataPracticeTest = {}.obs;
  var stdataMockTest = {}.obs;

  @override
  void onInit() {
    stdataPracticeTest.value = ctr.statsData["practice_test_stats"];
    log("data in onInit in PracticeTest():$stdataPracticeTest");
    stdataMockTest.value = ctr.statsData['mock_test_stats'];
    log("stdataMockTest:$stdataMockTest");
    super.onInit();
  }

  void changePageIndex(int x) {
    log("index :$x");
    currentPageIndex.value = x;

    pageController.jumpToPage(currentPageIndex.value);
  }
}
