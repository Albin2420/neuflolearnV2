import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';
import 'package:neuflo_learn/src/data/repositories/chapter/chapter_repo_impl.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/domain/repositories/chapter/chapter_repo.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/test_settings/test_settings_sheet.dart';

class CustomTestController extends GetxController {
  /// hive service
  HiveService hiveService = HiveService();

  /// chapter repo
  ChapterRepo chapterRepo = ChapterRepoImpl();

  /// number of questions  needed in custom test
  RxInt questionCount = RxInt(20);

  /// is instant evaluation
  RxBool isInstantEvaluation = RxBool(true);

  /// has time timit for the exam
  RxBool hasTimeLimit = RxBool(false);

  /// chapter [success] & [error] states
  Rx<Ds<List<Chapter>>> chapterState = Rx(Initial());

  /// text editing controller
  TextEditingController txt = TextEditingController();

  RxString selectedSubjectName = RxString('Physics');

  RxInt currentSubjectId = RxInt(1);

  void toggelInstantEvaluation() {
    isInstantEvaluation.value = !isInstantEvaluation.value;
  }

  RxList<Chapter> chapterList = RxList([]);

  RxList<Chapter> selectedChapters = RxList([]);

  RxList physicsSelectedChapters = RxList([]);

  RxList chemistrySelectedChapters = RxList([]);

  RxList biologySelectedChapters = RxList([]);

  @override
  void onInit() {
    // fetchChapter();
    super.onInit();
    showTestSettings();
  }

  void showTestSettings() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.to(() => TestSettingsSheet());
    });
  }

  Future fetchChapter() async {
    await fetchChapters(subId: 1);
    await fetchChapters(subId: 2);
    await fetchChapters(subId: 3);
  }

  void setCurrentSubjectName({required String sub}) {
    selectedSubjectName.value = sub;
    mapSubjToId();

    // log("currentSubjectId ===> $currentSubjectId");
    if (currentSubjectId.value == 1) {
      chapterList.value = physicsChapters;
      // log('physicsChapters => $chapterList');
    }

    if (currentSubjectId.value == 2) {
      chapterList.value = chemistryChapters;
      // log('chemistryChapters => $chemistryChapters');
    }

    if (currentSubjectId.value == 3) {
      chapterList.value = biologyChapters;
      // log('biologyChapters => $biologyChapters');
    }
  }

  void toggelHasTimeLimit() {
    hasTimeLimit.value = !hasTimeLimit.value;
  }

  int mapSubjToId() {
    if (selectedSubjectName.value == "Physics") {
      currentSubjectId.value = 1;
    }

    if (selectedSubjectName.value == "Chemistry") {
      currentSubjectId.value = 2;
    }

    if (selectedSubjectName.value == "Biology") {
      currentSubjectId.value = 3;
    }

    return currentSubjectId.value;
  }

  /// physics chapters
  RxList<Chapter> physicsChapters = RxList([]);

  /// chemistry chapter
  RxList<Chapter> chemistryChapters = RxList([]);

  /// biology chapters
  RxList<Chapter> biologyChapters = RxList([]);

  Future fetchChapters({required int subId}) async {
    chapterState.value = Loading();

    List<Chapter> savedChapters = [];

    // Check if 'id_chapter' box exists in local storage
    final bool boxExists = await Hive.boxExists('${subId}_chapters');

    if (boxExists) {
      // If box exists, fetch the saved chapters from the local box
      List<dynamic> data =
          await hiveService.get('${subId}_chapters', "chapters") ?? [];

      for (var i = 0; i < (data).length; i++) {
        savedChapters.add((data[i] as Chapter));
      }

      mapSubjToId();

      if (currentSubjectId.value == 1) {
        physicsChapters.value = savedChapters;
        // log("PHYSICS SAVED CHAPTERS : ${savedChapters.length}");
      }

      if (currentSubjectId.value == 2) {
        chemistryChapters.value = (savedChapters);
        // log("CHEMISTRY SAVED CHAPTERS : ${savedChapters.length}");
      }

      if (currentSubjectId.value == 3) {
        biologyChapters.value = savedChapters;
        // log("BIOLOGY SAVED CHAPTERS : ${savedChapters.length}");
      }

      // If savedChapters is not empty, update the state with the saved data
      if (savedChapters.isNotEmpty) {
        chapterState.value = Success(data: savedChapters);
      } else {
        // If savedChapters is empty, fetch from API
        final result = await chapterRepo.fetchChapters(subjectId: subId);
        result.fold(
          (failure) {
            chapterState.value = Failed(e: failure.message);
          },
          (apiData) async {
            // Save the fetched chapters to local storage (id_chapter box)
            await saveChaptersToLocal(subId: subId, list: apiData);
            chapterState.value = Success(data: apiData);
          },
        );
      }
    } else {
      // If the box does not exist, fetch chapters from API
      final result = await chapterRepo.fetchChapters(subjectId: subId);
      result.fold(
        (failure) {
          chapterState.value = Failed(e: failure.message);
        },
        (apiData) async {
          // Save the fetched chapters to local storage (id_chapter box)
          await saveChaptersToLocal(subId: subId, list: apiData);
          chapterState.value = Success(data: apiData);
        },
      );
    }
  }

  // Helper method to save chapters to the local box
  Future<void> saveChaptersToLocal({
    required int subId,
    required List<dynamic> list,
  }) async {
    await hiveService.put('${subId}_chapters', "chapters", list);
  }

  void addChapter({required Chapter chapter}) {
    if (!selectedChapters.contains(chapter)) {
      selectedChapters.add(chapter);
    } else {
      selectedChapters.remove(chapter);
    }

    update();

    log("selectedChapters  : ${selectedChapters.length}");
  }

  void addPhysicsChapters(int? id) {
    if (!physicsSelectedChapters.contains(id)) {
      physicsSelectedChapters.add(id);
    } else {
      physicsSelectedChapters.remove(id);
    }
    log("physics selected chapter Ids:$physicsSelectedChapters");
  }

  void addChemistryChapters(int? id) {
    // chemistrySelectedChapters
    if (!chemistrySelectedChapters.contains(id)) {
      chemistrySelectedChapters.add(id);
    } else {
      chemistrySelectedChapters.remove(id);
    }
    log("Chemsitry selected chapter Ids:$chemistrySelectedChapters");
  }

  void addBiologyChapters(int? id) {
    // biologySelectedChapters
    if (!biologySelectedChapters.contains(id)) {
      biologySelectedChapters.add(id);
    } else {
      biologySelectedChapters.remove(id);
    }
    log("BIology selected chapter Ids:$biologySelectedChapters");
  }

  // Future<void> clearHiveBox() async {
  //   // Check if the box exists
  //   bool box1Exists = await Hive.boxExists('1_chapters');
  //   bool box2Exists = await Hive.boxExists('2_chapters');
  //   bool box3Exists = await Hive.boxExists('3_chapters');

  //   if (box1Exists) {
  //     var box = Hive.box<List<dynamic>>('1_chapters');
  //     await box.clear();
  //   }

  //   if (box2Exists) {
  //     var box = Hive.box<List<dynamic>>('2_chapters');
  //     await box.clear();
  //   }

  //   if (box3Exists) {
  //     var box = Hive.box<List<dynamic>>('3_chapters');
  //     await box.clear();
  //   }
  // }

  // A timer to implement the debounce
  Timer? _debounce;

  RxString searchQuery = RxString('');

  // A method to handle the input change with debounce logic
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel(); // Cancel the previous timer
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Perform your search or action here after the delay
      searchQuery.value = value;
      log("Search query: $value");
    });
  }

  void executeSearch({required String searchTerm}) {}
}
