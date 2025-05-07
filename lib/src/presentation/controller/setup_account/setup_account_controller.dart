import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';
import 'package:neuflo_learn/src/data/models/course.dart';
import 'package:neuflo_learn/src/data/models/student.dart';
import 'package:neuflo_learn/src/data/repositories/chapter/chapter_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/course/course_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/skills/skills_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/user/user_repo_impl.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/domain/repositories/chapter/chapter_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/course/course_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/skills/skills_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/user/user_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class SetupAccountController extends GetxController {
  /// hive service
  HiveService hiveService = HiveService();

  RxInt organization = RxInt(-1);

  //user Repo

  UserRepo userRepo = UserRepoImpl();

  /// firestore service
  FirestoreService firestoreService = FirestoreService();

  /// chapter reposity
  ChapterRepo chapterRepo = ChapterRepoImpl();

  /// chapter reposity
  SkillsRepo skillsRepo = SkillsRepoImpl();

  /// course repository
  CourseRepo courseRepo = CourseRepoImpl();

  /// courseId
  RxInt courseId = RxInt(0);

  RxString isFailed = RxString("");

  /// selected course
  Rx<Course?> currentSelectedCourse = Rx(null);

  /// selected cpurse list
  RxList<Course> selectedCourseList = RxList([]);

  /// pagen index
  RxInt currentPageIndex = RxInt(0);

  /// stores strenths
  Map<String, dynamic> strengthMap = {};

  /// stores weakness
  Map<String, dynamic> weaknessMap = {};

  // page controller
  PageController pageController = PageController();

  /// course [success] & [error] states
  Rx<Ds<List<Course>>> courseState = Rx(Initial());

  /// chapter [success] & [error] states
  Rx<Ds<List<Chapter>>> chapterState = Rx(Initial());

  /// chapter [success] & [error] states
  Rx<Ds<String>> skillsState = Rx(Initial());

  /// scroll controller
  ScrollController scrollController = ScrollController();

  /// selected chapter count
  RxInt selectedChapterCount = RxInt(0);

  /// selected chapters
  RxList selectedChapters = RxList([]);

  var strongChapters = [];
  var weakChapters = [];

  TokenRepo tokenRepo = TokenRepoImpl();

  final appCtr = Get.find<AppStartupController>();

  /// fetch courses available
  Future fetchCourses() async {
    log("fetch course");
    courseState.value = Loading();
    final result = await courseRepo.getCourses();

    result.fold(
      (failure) {
        log('failure : $failure');
        courseState.value = Failed(e: failure.message);
      },
      (data) async {
        log('data : success :$data');
        await saveCoursesToLocal(list: data);
        courseState.value = Success(data: data);
      },
    );
  }

  Future saveCoursesToLocal({required List<Course> list}) async {
    final courseBox = await hiveService.openBox<List<Course>>('courses');
    await courseBox.put("course_list", list);
  }

  /// set course id
  void setCourse({required Course course}) {
    log('Course ID => ${course.courseId}');
    if (!selectedCourseList.contains(course)) {
      selectedCourseList.add(course);
      currentSelectedCourse.value = course;
    } else {
      selectedCourseList.remove(course);
      currentSelectedCourse.value = null;
    }
  }

  /// set selected course
  void setSelectedCourses({required Course course}) {
    currentSelectedCourse.value = course;
    log('Course ID => $courseId');
  }

  // Function to update the current page index
  void setPageIndex(int index) {
    currentPageIndex.value = index;
  }

  // Function to handle the navigation based on the button pressed
  void navigatePage(int index) {
    setPageIndex(index);
    pageController.jumpToPage(index);
  }

  /// handle profile
  // Future<bool> completeAccountSetup() async {
  //   log("initiating complteAccountsetup");
  //   String docName = await getDocumentName();

  //   AppUserInfo? appUserInfo = await getUserInfo();

  //   Get.find<AppStartupController>().appUser.value = appUserInfo;

  //   int currentdayindex = getCurrentDayIndex();
  //   List<int> streaklist = generateDaysList(currentdayindex);

  //   await firestoreService.addBasicDetails(
  //     userName: docName,
  //     phonenum: appUserInfo?.phone ?? '',
  //     email: appUserInfo?.email ?? '',
  //     name: appUserInfo?.name ?? '',
  //     id: appUserInfo?.id ?? 0,
  //     imageUrl: appUserInfo?.imageUrl ?? '',
  //     isProfileSetupComplete: true,
  //     streaklist: streaklist,
  //     currentstreakIndex: currentdayindex,
  //     organization: organization.value,
  //   );
  //   userAccountSetupState.value = Success(data: true);
  //   iscompleteUserSetup.value = false;
  //   return true;
  // }

  Future<bool> completeAccountSetup({required int studentId}) async {
    log("initiating complteAccountsetup");
    String docName = await getDocumentName();

    AppUserInfo? appUserInfo = await getUserInfo();

    Get.find<AppStartupController>().appUser.value = appUserInfo;

    int currentdayindex = getCurrentDayIndex();
    List<int> streaklist = generateDaysList(currentdayindex);

    await firestoreService.addBasicDetails(
      userName: docName,
      phonenum: appUserInfo?.phone ?? '',
      email: appUserInfo?.email ?? '',
      name: appUserInfo?.name ?? '',
      id: studentId,
      imageUrl: appUserInfo?.imageUrl ?? '',
      isProfileSetupComplete: true,
      streaklist: streaklist,
      currentstreakIndex: currentdayindex,
      organization: organization.value,
    );
    userAccountSetupState.value = Success(data: true);
    iscompleteUserSetup.value = false;
    return true;
  }

  int getCurrentDayIndex() {
    DateTime now = DateTime.now();

    // Get the weekday (1 = Monday, 7 = Sunday)
    int weekday = now.weekday;

    // Adjust so that 0 = Sunday, 1 = Monday, ..., 6 = Saturday
    int currentDayIndex = (weekday % 7);

    return currentDayIndex;
  }

  List<int> generateDaysList(int currentDayIndex) {
    List<int> days = List.filled(7, -1); // Start by filling all days with -1

    // Set the current day to 0
    days[currentDayIndex] = 0;

    for (int i = currentDayIndex + 1; i < days.length; i++) {
      days[i] = 1;
    }
    return days;
  }

  /// generate document name
  Future<String> getDocumentName() async {
    final userInfoBox = await hiveService.getBox("basic_user_info");

    String? userInfo = userInfoBox.get('phno');
    String? curretntUserPhoneNumber = userInfo;

    String docUsername = "$curretntUserPhoneNumber@neuflo.io";
    return docUsername;
  }

  Future<AppUserInfo?> getUserInfo() async {
    String docName = await getDocumentName();
    AppUserInfo? userInfo = await firestoreService.getCurrentUserDocument(
      userName: docName,
    );
    return userInfo;
  }

  RxBool iscompleteUserSetup = RxBool(false);

  Future completeUserSetup() async {
    iscompleteUserSetup.value = true;
    userAccountSetupState.value = Loading();
    try {
      await saveUserInfo();
      // userAccountSetupState.value = Success(data: isSetupSuccess);
    } on Exception catch (e) {
      userAccountSetupState.value = Failed(e: e.toString());
    }
  }

  /// handle strengths
  void addStrength({
    required String subject,
    required String chapterName,
    required int chapterId,
  }) {
    String name = subject.substring(0, 3);
    int key = mapSubjectToId(name);
    if (strengthMap.containsKey('$key')) {
      final list = List.from(strengthMap['$key']);
      if (list.contains(chapterId)) {
        list.remove(chapterId);
      } else {
        list.add(chapterId);
      }

      strengthMap['$key'] = list;
    } else {
      strengthMap['$key'] = [chapterId];
    }

    log('strengthMap : $strengthMap');
  }

  /// handle weakness

  void addWeakness({
    required String subject,
    required String chapterName,
    required int chapterId,
  }) {
    String name = subject.substring(0, 3);
    int key = mapSubjectToId(name);
    if (weaknessMap.containsKey('$key')) {
      final list = List.from(weaknessMap['$key']);
      if (list.contains(chapterId)) {
        list.remove(chapterId);
      } else {
        list.add(chapterId);
      }

      weaknessMap['$key'] = list;
    } else {
      weaknessMap['$key'] = [chapterId];
    }

    log('weaknessMap : $weaknessMap');
  }

  /// map subject name to its [ID]
  int mapSubjectToId(String name) {
    int key = 0;
    if (name == "Phy") {
      key = 1;
    }
    if (name == "Che") {
      key = 2;
    }

    if (name == "Bio") {
      key = 3;
    }
    return key;
  }

  RxInt strengthPhysicsSelected = RxInt(0);
  RxInt strengthChemistrySelected = RxInt(0);
  RxInt strengthBiolgySelected = RxInt(0);

  RxInt weaknessPhysicsSelected = RxInt(0);
  RxInt weaknessChemistrySelected = RxInt(0);
  RxInt weaknessBiologySelected = RxInt(0);

  /// set selected chapter count
  void setChapterCount({required String title, required String type}) {
    int key = mapSubjectToId(title.substring(0, 3));

    if (type == "Strength") {
      if (strengthMap.isNotEmpty) {
        selectedChapters.value = List.from(strengthMap['$key'] ?? []);
        if (title == "Physics") {
          strengthPhysicsSelected.value = selectedChapters.length;
        } else if (title == "Chemistry") {
          strengthChemistrySelected.value = selectedChapters.length;
        } else {
          strengthBiolgySelected.value = selectedChapters.length;
        }
      }
    } else {
      if (weaknessMap.isNotEmpty) {
        selectedChapters.value = List.from(weaknessMap['$key'] ?? []);
        if (title == "Physics") {
          weaknessPhysicsSelected.value = selectedChapters.length;
        } else if (title == "Chemistry") {
          weaknessChemistrySelected.value = selectedChapters.length;
        } else {
          weaknessBiologySelected.value = selectedChapters.length;
        }
      }
    }

    update();
  }

  // /// fetch chapters
  // Future fetchChapters({required int subId}) async {
  //   chapterState.value = Loading();

  //   final List<dynamic>? data =
  //       await hiveService.get('${subId}_chapters', "chapters");

  //   List<Chapter>? savedChapters = [];
  //   for (var i = 0; i < (data ?? []).length; i++) {
  //     savedChapters.add((data?[i] as Chapter));
  //   }

  //   log('saved chapters loading => $savedChapters');
  //   if (savedChapters.isEmpty) {
  //     final result = await chapterRepo.fetchChapters(subjectId: subId);
  //     result.fold((failure) {
  //       chapterState.value = Failed(e: failure.message);
  //     }, (data) async {
  //       await saveChaptersToLocal(subId: subId, list: data);
  //       chapterState.value = Success(data: data);
  //     });
  //   } else {
  //     chapterState.value = Success(data: savedChapters);
  //   }
  // }

  // Future saveChaptersToLocal({
  //   required subId,
  //   required List<Chapter> list,
  // }) async {
  //   final chaptersBox =
  //       await hiveService.getBox<List<Chapter>>('${subId}_chapters');
  //   await chaptersBox.put('chapters', list);
  // }

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

  /// save skills
  // Future<bool> saveSkills({required int studentId}) async {
  //   iscompleteUserSetup.value = true;
  //   log("saveSkills()");
  //   if (userAccountSetupState.value is! Loading) {
  //     userAccountSetupState.value = Loading();
  //   }
  //   AppUserInfo? appUserInfo = await getUserInfo();

  //   List<String> subjectIdOfStrengths = strengthMap.keys.toList();
  //   List<String> subjectIdOfWeaknes = weaknessMap.keys.toList();

  //   List<String> uniqueSubIdList = List.from(
  //     Set.from(subjectIdOfStrengths + subjectIdOfWeaknes),
  //   );

  //   Map<String, dynamic> subjectInfoMap = {};
  //   List<Map<String, dynamic>> subjectInfoMapList = [];

  //   for (var i = 0; i < uniqueSubIdList.length; i++) {
  //     List<int> strengths = [];
  //     List<int> weakness = [];

  //     if (strengthMap.containsKey(uniqueSubIdList[i])) {
  //       strengths = List<int>.from(strengthMap[uniqueSubIdList[i]]);
  //     }

  //     if (weaknessMap.containsKey(uniqueSubIdList[i])) {
  //       weakness = List<int>.from(weaknessMap[uniqueSubIdList[i]]);
  //     }

  //     subjectInfoMap = {
  //       "subject_id": uniqueSubIdList[i],
  //       "strong_chapters": strengths,
  //       "weak_chapters": weakness,
  //     };
  //     subjectInfoMapList.add(subjectInfoMap);
  //   }
  //   strongChapters = strengthMap.values.expand((list) => list).toList();
  //   log("strongChapters:$strongChapters");
  //   weakChapters = weaknessMap.values.expand((list) => list).toList();
  //   log("weakchapters:$weakChapters");

  //   Map<String, dynamic> skillData = {
  //     "course_id": "${currentSelectedCourse.value?.courseId}",
  //     "student_id": "${appUserInfo?.id}",
  //     "strong_chapters": strongChapters,
  //     "weak_chapters": weakChapters,
  //   };

  //   log('skillData : $skillData');

  //   final result = await skillsRepo.saveSkills(data: skillData);

  //   return result.fold(
  //     (failure) {
  //       log("skill save failed");
  //       iscompleteUserSetup.value = false;
  //       userAccountSetupState.value = Failed(e: failure.message);
  //       throw Exception(failure.message);
  //     },
  //     (data) async {
  //       log("skill saved successfully");
  //       iscompleteUserSetup.value = true;
  //       String? fcmToken = await FirebaseMessaging.instance.getToken();

  //       final token = await tokenRepo.getToken(
  //         studentId: appUserInfo?.id ?? 0,
  //         phoneNumber: appUserInfo?.phone ?? '',
  //         fcmToken: fcmToken ?? '',
  //       );

  //       return await token.fold(
  //         (l) async {
  //           log("token failed");
  //           iscompleteUserSetup.value = false;
  //           userAccountSetupState.value = Failed(e: l.message);
  //           return false; // Return false if token retrieval fails
  //         },
  //         (r) async {
  //           log("access_token: ${r["access_token"]}");
  //           log("refresh_token: ${r["refresh_token"]}");
  //           iscompleteUserSetup.value = true;

  //           await appCtr.saveToken(
  //             accessToken: r['access_token'],
  //             refreshToken: r['refresh_token'],
  //           );

  //           return await completeAccountSetup(); // Return the result of `saveSkills`
  //         },
  //       );
  //     },
  //   );
  // }

  Rx<Ds<bool>> userAccountSetupState = Rx(Initial());
  Rx<Student> currentStudent = Rx(Student());

  Future<bool> saveSkills({required int studentId}) async {
    log("saveSkills()");
    if (userAccountSetupState.value is! Loading) {
      userAccountSetupState.value = Loading();
    }
    AppUserInfo? appUserInfo = await getUserInfo();

    List<String> subjectIdOfStrengths = strengthMap.keys.toList();
    List<String> subjectIdOfWeaknes = weaknessMap.keys.toList();

    List<String> uniqueSubIdList = List.from(
      Set.from(subjectIdOfStrengths + subjectIdOfWeaknes),
    );

    Map<String, dynamic> subjectInfoMap = {};
    List<Map<String, dynamic>> subjectInfoMapList = [];

    for (var i = 0; i < uniqueSubIdList.length; i++) {
      List<int> strengths = [];
      List<int> weakness = [];

      if (strengthMap.containsKey(uniqueSubIdList[i])) {
        strengths = List<int>.from(strengthMap[uniqueSubIdList[i]]);
      }

      if (weaknessMap.containsKey(uniqueSubIdList[i])) {
        weakness = List<int>.from(weaknessMap[uniqueSubIdList[i]]);
      }

      subjectInfoMap = {
        "subject_id": uniqueSubIdList[i],
        "strong_chapters": strengths,
        "weak_chapters": weakness,
      };
      subjectInfoMapList.add(subjectInfoMap);
    }
    strongChapters = strengthMap.values.expand((list) => list).toList();
    log("strongChapters:$strongChapters");
    weakChapters = weaknessMap.values.expand((list) => list).toList();
    log("weakchapters:$weakChapters");

    Map<String, dynamic> skillData = {
      "course_id": "${currentSelectedCourse.value?.courseId}",
      "student_id": "$studentId",
      "strong_chapters": strongChapters,
      "weak_chapters": weakChapters,
    };

    log('skillData : $skillData');

    final result = await skillsRepo.saveSkills(data: skillData);

    return result.fold(
      (failure) {
        log("skill save failed");
        userAccountSetupState.value = Failed(e: failure.message);
        iscompleteUserSetup.value = false;
        throw Exception(failure.message);
      },
      (data) async {
        log("skill saved successfully");
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        if (studentverificationpending.value) {
          isFailed.value = 'pending cases';
          iscompleteUserSetup.value = true;
          userAccountSetupState.value = Failed(e: "pending case");
          return false;
        } else {
          final token = await tokenRepo.getToken(
            studentId: studentId,
            phoneNumber: appUserInfo?.phone ?? '',
            fcmToken: fcmToken ?? '',
          );
          return await token.fold(
            (l) async {
              log("token failed");
              userAccountSetupState.value = Failed(e: l.message);
              iscompleteUserSetup.value = false;
              return false; // Return false if token retrieval fails
            },
            (r) async {
              log("access_token: ${r["access_token"]}");
              log("refresh_token: ${r["refresh_token"]}");

              await appCtr.saveToken(
                accessToken: r['access_token'],
                refreshToken: r['refresh_token'],
              );

              return await completeAccountSetup(
                studentId: studentId,
              ); // Return the result of `saveSkills`
            },
          );
        }
      },
    );
  }

  // Future<bool> saveUserInfo() async {
  //   AppUserInfo? appUserInfo = await getUserInfo();

  //   final result = await userRepo.saveStudent(
  //     student: Student(
  //       studentId: appUserInfo?.id,
  //       mailId: appUserInfo?.email,
  //       name: appUserInfo?.name,
  //       phoneNumber: appUserInfo?.phone,
  //     ),
  //   );

  //   return await result.fold(
  //     (f) async {
  //       isFailed.value = f.message;
  //       userAccountSetupState.value = Failed(e: f.message);
  //       iscompleteUserSetup.value = false;
  //       return false;
  //     },
  //     (student) async {
  //       currentStudent.value = student;
  //       organization.value = student.organization ?? -1;
  //       return await saveSkills();
  //     },
  //   );
  // }

  // Rx<Ds<bool>> userAccountSetupState = Rx(Initial());
  // Rx<Student> currentStudent = Rx(Student());
  RxBool studentverificationpending = RxBool(false);

  Future<bool> saveUserInfo() async {
    AppUserInfo? appUserInfo = await getUserInfo();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final result = await userRepo.saveStudent(
      student: Student(
        studentId: appUserInfo?.id,
        mailId: appUserInfo?.email,
        name: appUserInfo?.name,
        phoneNumber: appUserInfo?.phone,
      ),
      fcmToken: fcmToken ?? '',
    );

    return await result.fold(
      (f) async {
        isFailed.value = f.message;
        iscompleteUserSetup.value = false;
        userAccountSetupState.value = Failed(e: f.message);
        return false;
      },
      (student) async {
        try {
          log("studentId:${student['student_id']}");
          log("status_code:${student['status_code']}");
          log("org:${student['organization']}");
          await firestoreService.updateStudentId(
            userName: '${appUserInfo?.phone}@neuflo.io',
            iD: student['student_id'],
          );

          if (student['status_code'] == 420) {
            studentverificationpending.value = true;
            organization.value = student['organization'];
            iscompleteUserSetup.value = true;
            return await saveSkills(studentId: student['student_id']);
          } else {
            log("verification approved scenario");
            studentverificationpending.value = false;
            iscompleteUserSetup.value = true;
            organization.value = student['organization'];
            return await saveSkills(studentId: student['student_id']);
          }
        } catch (e) {
          log('error:$e');
          return false;
        }
      },
    );
  }

  /// completes profile setup
  Future completeProfileSetup() async {
    /// saving user phone number
    final userInfoBox = await hiveService.getBox("basic_user_info");

    String? userInfo = userInfoBox.get('phno');
    String? curretntUserPhoneNumber = userInfo;

    String docUsername = "$curretntUserPhoneNumber@neuflo.io";

    AppUserInfo? appUserInfo = await firestoreService.getCurrentUserDocument(
      userName: docUsername,
    );

    int currentdayindex = getCurrentDayIndex();
    List<int> streaklist = generateDaysList(currentdayindex);

    if (appUserInfo != null) {
      firestoreService.addBasicDetails(
        userName: docUsername,
        phonenum: appUserInfo.phone ?? '',
        email: appUserInfo.email,
        name: appUserInfo.name,
        id: appUserInfo.id ?? 0,
        imageUrl: appUserInfo.imageUrl,
        isProfileSetupComplete: true,
        streaklist: streaklist,
        currentstreakIndex: currentdayindex,
        organization: organization.value,
      );
    }
  }
}
