import 'dart:developer';

import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/models/chapter_model.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';

class ChapterController extends GetxController {
  final ClassesController classesController = Get.find<ClassesController>();
  VideosController videosController = Get.put(VideosController());

  RxList<ChapterModel> chapterList = RxList<ChapterModel>();
  RxString selectedSubjectName = "".obs;

  void fetchChapters() {
    Map<String, dynamic> data = classesController.subjectData;

    if (selectedSubjectName.value.isNotEmpty &&
        data.containsKey(selectedSubjectName.value)) {
      var subjectData = data[selectedSubjectName.value];

      List<ChapterModel> chapters = [];

      for (var chapter in subjectData) {
        chapters.add(ChapterModel(
          chapterName: chapter["chaptername"],
          chapterNo: (chapters.length + 1).toString(),
        ));
      }

      chapterList.assignAll(chapters);

      log("Chapters for ${selectedSubjectName.value} => ${chapters.map((c) => c.chapterName).toList()}");
    } else {
      chapterList.clear();
      log("No chapters found for ${selectedSubjectName.value}");
    }
  }

  void onChapterSelected(int index) {
    log("Chapter Selected");
    ChapterModel selectedChapter = chapterList[index];

    log("Selected Chapter => ${selectedChapter.chapterName}");

    // Fetch videos for the selected chapter
    // videosController.fetchVideosForChapter(selectedChapter.chapterName);

    // Navigate to Videos page with the selected chapter
    // Get.to(() => Videos(chapter: selectedChapter));
  }
}

// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:neuflo_learn/src/data/models/chapter_model.dart';
// import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';
// import '../../screens/videos/videos.dart';

// class ChapterController extends GetxController {
//   final ClassesController classesController = Get.find<ClassesController>();

//   RxList<ChapterModel> chapterList = RxList<ChapterModel>();
//   RxString selectedSubjectName = "".obs;

//   void fetchChapters() {
//     Map<String, dynamic> data = classesController.subjectData; // Full data map

//     if (selectedSubjectName.value.isNotEmpty &&
//         data.containsKey(selectedSubjectName.value)) {
//       var subjectData = data[selectedSubjectName.value];

//       List<ChapterModel> chapters = [];

//       for (var chapter in subjectData) {
//         chapters.add(ChapterModel(
//           chapterName: chapter["chaptername"],
//           chapterNo: (chapters.length + 1).toString(), // Assigning chapter number
//         ));
//       }

//       chapterList.assignAll(chapters);

//       log("Chapters for ${selectedSubjectName.value} => ${chapters.map((c) => c.chapterName).toList()}");
//     } else {
//       chapterList.clear();
//       log("No chapters found for ${selectedSubjectName.value}");
//     }
//   }

//   void onChapterSelected(int index) {
//     log("Chapter Selected");
//     ChapterModel selectedChapter = chapterList[index];
//     log("Selected Chapter => ${selectedChapter.chapterName}");
//     Get.to(Videos(chapter: selectedChapter));
//   }
// }
