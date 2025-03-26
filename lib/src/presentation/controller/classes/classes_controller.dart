import 'dart:developer';

import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/question.dart';
import 'package:neuflo_learn/src/data/repositories/subject/subject_repo_impl.dart';
import 'package:neuflo_learn/src/domain/repositories/subject/subject_repo.dart';
import 'package:neuflo_learn/src/presentation/screens/chapter/chapter_screen.dart';

import '../../../data/models/subject.dart';

class ClassesController extends GetxController {
  RxList<String> subjectNames = RxList<String>();
  RxString selectedSubjectName = "".obs;
  Map<String, dynamic> subjectData = {};
  RxList<Map<String, dynamic>> chapters = RxList<Map<String, dynamic>>();
  Rxn<Subject> selectedSubject = Rxn<Subject>();
  SubjectRepo subjectRepo = SubjectRepoImpl();
  RxList physics = RxList([]);
  RxList chemistry = RxList([]);
  RxList biology = RxList([]);
  RxList currentSelectedList = RxList([]);

  Rx<Ds<List>> chapterstate = Rx(Initial());

  @override
  void onInit() {
    super.onInit();
    fetchLive();
    fetchSubjects();
  }

  Future<void> fetchLive() async {
    try {
      dynamic res = await subjectRepo.fetchLive();
      res.fold((l) {}, (R) {});
    } catch (e) {
      log('Error :$e');
    }
  }

  /// Fetch subjects from repository
  Future<void> fetchSubjects() async {
    try {
      chapterstate.value = Loading();
      dynamic res = await subjectRepo.fetchSubjects();
      res.fold((l) {
        log("failed in get classes");
        chapterstate.value = Failed();
      }, (R) {
        physics.value = R["Physics"];
        chemistry.value = R["Chemistry"];
        biology.value = R["Biology"];
        log("physics.length => ${physics.length}");
        log("chemistry.length => ${chemistry.length}");
        log("biology.length => ${biology.length}");
      });
      log("Fetched subject data: $subjectData");
      subjectNames.value = subjectData.keys.toList();
      log("Subjects fetched successfully: $subjectNames");
      chapterstate.value = Success(data: subjectNames);
    } catch (e) {
      log("Error in fetchSubjects: $e");
      chapterstate.value = Failed();
    }
  }

  /// Handle subject selection
  void onSubjectSelected({required int subject}) {
    log("user selected : $subject");
    if (subject == 1) {
      selectedSubjectName.value = "Physics";
      currentSelectedList.value = physics;
      Get.to(ChapterPage(subjectName: "Physics"));
    } else if (subject == 2) {
      selectedSubjectName.value = "Chemistry";
      currentSelectedList.value = chemistry;
      Get.to(ChapterPage(subjectName: "Chemistry"));
    } else {
      selectedSubjectName.value = "Biology";
      currentSelectedList.value = biology;
      Get.to(ChapterPage(subjectName: "Biology"));
    }
  }

  /// Fetch chapters based on selected subject
  void fetchChapters(String subjectName) {
    log("Fetching chapters for subject: $subjectName");

    if (subjectData.containsKey(subjectName)) {
      var rawChapters = subjectData[subjectName];

      log("Raw chapters data: $rawChapters");

      if (rawChapters is List) {
        chapters.value = rawChapters.map<Map<String, dynamic>>((chapter) {
          if (chapter is Map<String, dynamic>) {
            return {
              "chaptername": chapter["chaptername"] ?? "Unknown Chapter",
              "videos": List<Map<String, dynamic>>.from(chapter["videos"] ?? [])
            };
          } else {
            log("Invalid chapter format: $chapter");
            return {};
          }
        }).toList();

        log("Processed chapters: $chapters"); // Final log of chapters
      } else {
        log("Expected List but found ${rawChapters.runtimeType}");
        chapters.clear();
      }
    } else {
      log("No chapters found for subject: $subjectName");
      chapters.clear();
    }
  }

  String formatDuration(int seconds) {
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }
}
