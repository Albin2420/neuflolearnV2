import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
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

  // for live()
  RxString currentvideoClassid = RxString('');
  RxString currentgroupChatId = RxString('');
  RxString liveVideoUrl = RxString('');
  RxString liveTime = RxString('');
  RxString title = RxString('');
  RxString chaptername = RxString('');

  RxList<dynamic> physicsLive = RxList([]);
  RxList<dynamic> chemistryLive = RxList([]);
  RxList<dynamic> biologyLive = RxList([]);

  RxBool islive = RxBool(false);

  RxBool isalreadyFetched = RxBool(false);

  // Updated: Use List<Map<String, dynamic>> instead of List<dynamic>
  RxList<Map<String, dynamic>> afterfiltered = RxList([]);

  RxInt timerIndex = RxInt(0);
  Rx<DateTime> currentTime = DateTime.now().obs; // Observable time

  RxInt classIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    fetchLive();
    fetchSubjects();
  }

  Future<void> reFresh() async {
    try {
      fetchLive();
      fetchSubjects();
    } catch (e) {
      log("Error:$e");
    }
  }

  Future<void> fetchLive() async {
    try {
      dynamic res = await subjectRepo.fetchLive();
      res.fold(
        (l) {
          log("failure");
        },
        (R) {
          log("Resp fetchLive:${R['livevideos']}");

          // Check if the response contains 'livevideos' and it is a List<dynamic>
          if (R['livevideos'] is List) {
            // Cast it to List<Map<String, dynamic>> explicitly before passing to filter
            afterfiltered.value = filter(
              videoClasses: List<Map<String, dynamic>>.from(R['livevideos']),
            );

            log("afterfilter:$afterfiltered");
            if (afterfiltered.isNotEmpty) {
              removeExpired();
            }
          } else {
            log("Invalid format for live videos data.");
          }
        },
      );
    } catch (e) {
      log('Error fetchLive():$e');
    }
  }

  void removeExpired() {
    log("removeExpired()");
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (afterfiltered.isNotEmpty) {
        try {
          DateTime liveEndTime = DateTime.parse(
            afterfiltered[0]['live_end_time'],
          );
          DateTime currentTime = DateTime.now();

          if (currentTime.isAfter(liveEndTime)) {
            log("Live session expired: ${afterfiltered[0]}");
            afterfiltered.removeAt(0);
          }
        } catch (e) {
          log("Error parsing 'liveended' time: $e");
        }
      }
    });
  }

  Future<void> setchatId({required String chatId}) async {
    currentgroupChatId.value = chatId;
  }

  bool isLiveActive({required String liveEnd, required String liveBegins}) {
    try {
      DateTime liveEndTime = DateTime.parse(liveEnd);
      DateTime liveBeginTime = DateTime.parse(liveBegins);
      DateTime currentTime = DateTime.now();

      if (currentTime.isAfter(liveBeginTime) &&
          currentTime.isBefore(liveEndTime)) {
        int secondsElapsed = currentTime.difference(liveBeginTime).inSeconds;
        log("Seconds passed since live started: $secondsElapsed");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error in isLiveActive(): $e");
      return false;
    }
  }

  void refreshed() {
    log("catch it");
  }

  List<Map<String, dynamic>> filter({
    required List<Map<String, dynamic>> videoClasses,
  }) {
    try {
      DateTime now = DateTime.now(); // Current date and time

      // Filter out events that have already started
      List<Map<String, dynamic>> upcomingClasses = videoClasses.where((video) {
        try {
          DateTime liveTime = DateTime.parse(video['live_end_time']);
          return liveTime.isAfter(
            now,
          ); // Only keep events that start in the future
        } catch (e) {
          log(
            'Date parsing error: $e for live_time: ${video['live_time']}',
          );
          return false; // Exclude invalid dates
        }
      }).toList();

      // Sort the filtered list by live_time
      upcomingClasses.sort((a, b) {
        DateTime aLiveTime = DateTime.parse(a['live_time']);
        DateTime bLiveTime = DateTime.parse(b['live_time']);
        return aLiveTime.compareTo(bLiveTime);
      });

      return upcomingClasses;
    } catch (e) {
      log('Error in filter(): $e');
      chapterstate.value = Failed();
      return [];
    }
  }

  /// Fetch subjects from repository
  Future<void> fetchSubjects() async {
    try {
      isalreadyFetched.value == false
          ? chapterstate.value = Loading()
          : chapterstate;
      dynamic res = await subjectRepo.fetchSubjects();
      res.fold(
        (l) {
          log("failed in get classes");
          chapterstate.value = Failed();
        },
        (R) {
          physics.value = R["Physics"];
          chemistry.value = R["Chemistry"];
          biology.value = R["Biology"];
        },
      );
      subjectNames.value = subjectData.keys.toList();
      isalreadyFetched.value = true;
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
              "videos": List<Map<String, dynamic>>.from(
                chapter["videos"] ?? [],
              ),
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

// import 'dart:async';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:neuflo_learn/src/core/data_state/data_state.dart';
// import 'package:neuflo_learn/src/data/repositories/subject/subject_repo_impl.dart';
// import 'package:neuflo_learn/src/domain/repositories/subject/subject_repo.dart';
// import 'package:neuflo_learn/src/presentation/screens/chapter/chapter_screen.dart';
// import '../../../data/models/subject.dart';

// class ClassesController extends GetxController {
//   RxList<String> subjectNames = RxList<String>();
//   RxString selectedSubjectName = "".obs;
//   Map<String, dynamic> subjectData = {};
//   RxList<Map<String, dynamic>> chapters = RxList<Map<String, dynamic>>();
//   Rxn<Subject> selectedSubject = Rxn<Subject>();
//   SubjectRepo subjectRepo = SubjectRepoImpl();
//   RxList physics = RxList([]);
//   RxList chemistry = RxList([]);
//   RxList biology = RxList([]);
//   RxList currentSelectedList = RxList([]);

//   Rx<Ds<List>> chapterstate = Rx(Initial());

//   // for live()
//   RxString currentvideoClassid = RxString('');
//   RxString currentgroupChatId = RxString('');
//   RxString liveVideoUrl = RxString('');
//   RxString liveTime = RxString('');
//   RxString title = RxString('');
//   RxString chaptername = RxString('');

//   RxList<dynamic> physicsLive = RxList([]);
//   RxList<dynamic> chemistryLive = RxList([]);
//   RxList<dynamic> biologyLive = RxList([]);

//   RxBool islive = RxBool(false);

//   // Updated: Use List<Map<String, dynamic>> instead of List<dynamic>
//   RxList<Map<String, dynamic>> afterfiltered = RxList([]);

//   RxInt timerIndex = RxInt(0);
//   Timer? liveCheckTimer;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchLive();
//     fetchSubjects();
//     // Start a timer to periodically check for active live classes
//     liveCheckTimer = Timer.periodic(Duration(minutes: 1), (timer) {
//       updateActiveLiveClass();
//     });
//   }

//   @override
//   void onClose() {
//     liveCheckTimer?.cancel();
//     super.onClose();
//   }

//   Future<void> fetchLive() async {
//     try {
//       dynamic res = await subjectRepo.fetchLive();
//       res.fold((l) {
//         log("failure");
//       }, (R) {
//         log("Resp fetchLive:${R['livevideos']}");

//         // Check if the response contains 'livevideos' and it is a List<dynamic>
//         if (R['livevideos'] is List) {
//           // Cast it to List<Map<String, dynamic>> explicitly before passing to filter
//           afterfiltered.value = filter(
//               videoClasses: List<Map<String, dynamic>>.from(R['livevideos']));

//           log("afterfilter:$afterfiltered");

//           // After getting the filtered list, update the active live class
//           updateActiveLiveClass();
//         } else {
//           log("Invalid format for live videos data.");
//         }
//       });
//     } catch (e) {
//       log('Error fetchLive():$e');
//     }
//   }

//   // New method to check if there's an active live class based on current time
//   bool hasActiveLiveClass() {
//     if (afterfiltered.isEmpty) {
//       return false;
//     }

//     // Check if there's at least one live class that's currently active
//     for (int i = 0; i < afterfiltered.length; i++) {
//       final liveClass = afterfiltered[i];
//       if (liveClass.containsKey('live_time') &&
//           liveClass.containsKey('live_end_time')) {
//         final isActive = isLiveActive(
//             liveEnd: liveClass['live_end_time'],
//             liveBegins: liveClass['live_time']);

//         if (isActive) {
//           return true;
//         }
//       }
//     }

//     return false;
//   }

//   // New method to get the active live class data
//   Map<String, dynamic>? getActiveLiveClass() {
//     if (afterfiltered.isEmpty) {
//       return null;
//     }

//     for (int i = 0; i < afterfiltered.length; i++) {
//       final liveClass = afterfiltered[i];
//       if (liveClass.containsKey('live_time') &&
//           liveClass.containsKey('live_end_time')) {
//         final isActive = isLiveActive(
//             liveEnd: liveClass['live_end_time'],
//             liveBegins: liveClass['live_time']);

//         if (isActive) {
//           timerIndex.value =
//               i; // Update timerIndex to point to the active class
//           return liveClass;
//         }
//       }
//     }

//     return null;
//   }

//   // Method to update the timerIndex to point to the currently active live class
//   void updateActiveLiveClass() {
//     if (afterfiltered.isEmpty) {
//       return;
//     }

//     bool foundActive = false;

//     for (int i = 0; i < afterfiltered.length; i++) {
//       final liveClass = afterfiltered[i];
//       if (liveClass.containsKey('live_time') &&
//           liveClass.containsKey('live_end_time')) {
//         final isActive = isLiveActive(
//             liveEnd: liveClass['live_end_time'],
//             liveBegins: liveClass['live_time']);

//         if (isActive) {
//           timerIndex.value = i;
//           foundActive = true;
//           islive.value = true;
//           break;
//         }
//       }
//     }

//     if (!foundActive) {
//       islive.value = false;
//       // If no active class is found, set timerIndex to the closest upcoming class
//       DateTime now = DateTime.now();
//       int closestIndex = 0;
//       Duration closestDiff = Duration(days: 365); // Start with a large duration

//       for (int i = 0; i < afterfiltered.length; i++) {
//         final liveClass = afterfiltered[i];
//         if (liveClass.containsKey('live_time')) {
//           try {
//             DateTime liveTime = DateTime.parse(liveClass['live_time']);
//             if (liveTime.isAfter(now)) {
//               Duration diff = liveTime.difference(now);
//               if (diff < closestDiff) {
//                 closestDiff = diff;
//                 closestIndex = i;
//               }
//             }
//           } catch (e) {
//             log("Error parsing date in updateActiveLiveClass: $e");
//           }
//         }
//       }

//       timerIndex.value = closestIndex;
//     }

//     log("Active live class updated. timerIndex: ${timerIndex.value}, isLive: ${islive.value}");
//   }

//   Future<void> setchatId({required String chatId}) async {
//     currentgroupChatId.value = chatId;
//   }

//   bool isLiveActive({required String liveEnd, required String liveBegins}) {
//     try {
//       DateTime liveEndTime = DateTime.parse(liveEnd);
//       DateTime liveBeginTime = DateTime.parse(liveBegins);
//       DateTime currentTime = DateTime.now();

//       // Check if current time is between begin and end times
//       bool isActive = currentTime.isAfter(liveBeginTime) &&
//           currentTime.isBefore(liveEndTime);

//       if (isActive) {
//         int secondsElapsed = currentTime.difference(liveBeginTime).inSeconds;
//         log("Seconds passed since live started: $secondsElapsed");
//       }

//       return isActive;
//     } catch (e) {
//       log("Error in isLiveActive(): $e");
//       return false;
//     }
//   }

//   List<Map<String, dynamic>> filter({
//     required List<Map<String, dynamic>> videoClasses,
//   }) {
//     try {
//       DateTime now = DateTime.now(); // Current date and time
//       DateTime today =
//           DateTime(now.year, now.month, now.day); // Today's date without time

//       // Filter out events that are expired
//       List<Map<String, dynamic>> upcomingClasses = videoClasses.where((video) {
//         try {
//           DateTime liveTime = DateTime.parse(video['live_time']);

//           // Add a default end time if not present (2 hours after start)
//           if (!video.containsKey('live_end_time')) {
//             video['live_end_time'] =
//                 liveTime.add(Duration(hours: 2)).toString();
//             log("Added default end time: ${video['live_end_time']} for class starting at ${video['live_time']}");
//           }

//           return liveTime.isAfter(today) || liveTime.isAtSameMomentAs(today);
//         } catch (e) {
//           log('Date parsing error: $e for live_time: ${video['live_time']}');
//           return false; // Exclude invalid dates
//         }
//       }).toList();

//       // Sort the filtered list by live_time
//       upcomingClasses.sort((a, b) {
//         DateTime aLiveTime = DateTime.parse(a['live_time']);
//         DateTime bLiveTime = DateTime.parse(b['live_time']);
//         return aLiveTime.compareTo(bLiveTime);
//       });

//       return upcomingClasses;
//     } catch (e) {
//       log('Error in filter(): $e');
//       chapterstate.value = Failed();
//       return [];
//     }
//   }

//   /// Fetch subjects from repository
//   Future<void> fetchSubjects() async {
//     try {
//       chapterstate.value = Loading();
//       dynamic res = await subjectRepo.fetchSubjects();
//       res.fold((l) {
//         log("failed in get classes");
//         chapterstate.value = Failed();
//       }, (R) {
//         physics.value = R["Physics"];
//         chemistry.value = R["Chemistry"];
//         biology.value = R["Biology"];
//       });
//       subjectNames.value = subjectData.keys.toList();
//       chapterstate.value = Success(data: subjectNames);
//     } catch (e) {
//       log("Error in fetchSubjects: $e");
//       chapterstate.value = Failed();
//     }
//   }

//   /// Handle subject selection
//   void onSubjectSelected({required int subject}) {
//     log("user selected : $subject");
//     if (subject == 1) {
//       selectedSubjectName.value = "Physics";
//       currentSelectedList.value = physics;
//       Get.to(ChapterPage(subjectName: "Physics"));
//     } else if (subject == 2) {
//       selectedSubjectName.value = "Chemistry";
//       currentSelectedList.value = chemistry;
//       Get.to(ChapterPage(subjectName: "Chemistry"));
//     } else {
//       selectedSubjectName.value = "Biology";
//       currentSelectedList.value = biology;
//       Get.to(ChapterPage(subjectName: "Biology"));
//     }
//   }

//   /// Fetch chapters based on selected subject
//   void fetchChapters(String subjectName) {
//     log("Fetching chapters for subject: $subjectName");

//     if (subjectData.containsKey(subjectName)) {
//       var rawChapters = subjectData[subjectName];

//       log("Raw chapters data: $rawChapters");

//       if (rawChapters is List) {
//         chapters.value = rawChapters.map<Map<String, dynamic>>((chapter) {
//           if (chapter is Map<String, dynamic>) {
//             return {
//               "chaptername": chapter["chaptername"] ?? "Unknown Chapter",
//               "videos": List<Map<String, dynamic>>.from(chapter["videos"] ?? [])
//             };
//           } else {
//             log("Invalid chapter format: $chapter");
//             return {};
//           }
//         }).toList();

//         log("Processed chapters: $chapters"); // Final log of chapters
//       } else {
//         log("Expected List but found ${rawChapters.runtimeType}");
//         chapters.clear();
//       }
//     } else {
//       log("No chapters found for subject: $subjectName");
//       chapters.clear();
//     }
//   }

//   // String formatDuration(int seconds) {
//   //   int minutes = (seconds % 3600) ~/ 60;
//   //   int secs = seconds % 60;

//   //   return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
//   // }
// }
