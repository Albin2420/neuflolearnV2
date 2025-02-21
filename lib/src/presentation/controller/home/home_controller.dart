import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';
import 'package:neuflo_learn/src/data/models/test_completion_report.dart';
import 'package:neuflo_learn/src/data/models/test_completion_result.dart';
import 'package:neuflo_learn/src/data/repositories/chapter/chapter_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/exam/exam_repo_impl.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/domain/repositories/chapter/chapter_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/exam/exam_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class HomeController extends GetxController {
  HiveService hiveService = HiveService();

  ChapterRepo chapterRepo = ChapterRepoImpl();

  ExamRepo examRepo = ExamRepoImpl();

  FirestoreService firestoreService = FirestoreService();

  /// user image url
  RxString userImageUrl = RxString('');

  /// user name
  RxString userName = RxString('');

  /// handle home states
  Rx<Ds<bool>> homeState = Rx(Initial());

  /// current student id
  int studentId = 0;

  /// current user docName
  String docName = '';

  RxInt totalTestDonePerDay = RxInt(0);

  /// current user info
  Rx<AppUserInfo?> appUser = Rx(null);

  Rx<Ds<List<int>>> streaksState = Rx(Initial());

  RxList<String> level = ["Easy", "Medium", "Difficult"].obs;

  Map<String, int> weekDaysMap = {
    'Monday': 0,
    'Tuesday': 1,
    'Wednesday': 2,
    'Thursday': 3,
    'Friday': 4,
    'Saturday': 5,
    'Sunday': 6
  };
  List<String> weekdaysList = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  /// set user image url
  void setImageUrl({required String url}) {
    userImageUrl.value = url;
    if (kDebugMode) {
      // log('image url : ${userImageUrl.value}');
    }
  }

  /// set user name
  void setName({required String name}) {
    userName.value = name;
  }

  RxList<int> currentStreakValues = RxList([]);

  RxInt noOfTestCompletedToday = RxInt(0);

  Rx<Ds<List<int>>> homeExamState = Rx(Initial());

  @override
  void onInit() {
    initiate();
    super.onInit();
  }

  /// set user basic details
  Future setUserInfo() async {
    String docUsername = await getDocumentName();
    AppUserInfo? appUserInfo =
        await firestoreService.getCurrentUserDocument(userName: docUsername);
    Get.find<AppStartupController>().appUser.value = appUserInfo;
    appUser.value = appUserInfo;

    setName(name: appUserInfo?.name ?? "");
    setImageUrl(url: appUserInfo?.imageUrl ?? "");
  }

  Future initiate() async {
    await setUserInfo();
    studentId = (await getUserInfo())?.id ?? 0;
    // await init();
    await fetchStreakData();
  }

  /// fetch streak data from firestore
  Future fetchStreakData() async {
    String docName = await getDocumentName();
    await firestoreService.getStreakValueFromFirebase(userName: docName);
  }

  /// generate document name
  Future<String> getDocumentName() async {
    final userInfoBox = await hiveService.getBox("basic_user_info");

    String? userInfo = userInfoBox.get('phno');
    String? curretntUserPhoneNumber = userInfo;

    String docUsername = "$curretntUserPhoneNumber@neuflo.io";
    return docUsername;
  }

  List<Chapter> physicsChapters = [];
  List<Chapter> chemistryChapters = [];
  List<Chapter> biologyChapters = [];

  Future init() async {
    /// fetching chapters of each subjects

    // physicsChapters = await fetchChapters(subId: 1);
    // chemistryChapters = await fetchChapters(subId: 2);
    // biologyChapters = await fetchChapters(subId: 3);

    /// generate practice test id list
    await generatePracticeTestIds();

    // /// check test completion
    await checkTestCompletion();

    // /// get practice test details
    await getPracticeTestDeails();

    /// fetch current streak values
    await fetchAndUpdateStreakValues();
  }

  /// fetch chapters
  Future<List<Chapter>> fetchChapters({required int subId}) async {
    final List<dynamic>? data =
        await hiveService.get('${subId}_chapters', "chapters");

    List<Chapter>? savedChapters = [];
    for (var i = 0; i < (data ?? []).length; i++) {
      savedChapters.add((data?[i] as Chapter));
    }

    if (kDebugMode) {
      // log('saved subject $subId chapters loading => $savedChapters');
    }
    if (savedChapters.isEmpty) {
      final result = await chapterRepo.fetchChapters(subjectId: subId);
      result.fold((failure) {
        return [];
      }, (data) async {
        return data;
      });
    } else {
      return savedChapters;
    }
    return <Chapter>[];
  }

  List<int> testInstanceIDList = [];

  /// generate practice test ids
  Future generatePracticeTestIds() async {
    // log('docName => $docName');

    homeExamState.value = Loading();
    String date =
        await firestoreService.getTodateFromFirebase(userName: docName);
    String today = DateTime.now().toString().split(' ').first;
    // '2025-01-18';

    log('date : $date');

    if (date.compareTo(today) != 0) {
      firestoreService.updateTodate(userName: docName, date: today);
      firestoreService.updateListExamId(userName: docName, examId: []);
    }

    testInstanceIDList =
        List.from(await firestoreService.getListExamId(userName: docName))
            .cast<int>();

    if (testInstanceIDList.isEmpty || testInstanceIDList.length < 3) {
      for (var i = 0; i < 3; i++) {
        await generatePracticeTestId();
      }
    }

    if (testInstanceIDList.isNotEmpty) {
      if (testInstanceIDList.length == 3 &&
          (testInstanceIDList.contains(0) ||
              testInstanceIDList.every((e) => e == 0))) {
        homeExamState.value = Failed(e: 'TestInstanceId Not Loaded');
      } else {
        // log("CURRENT GENERATED TESTINSTANCE ID LIST ======> $testInstanceIDList");
        homeExamState.value = Success(data: testInstanceIDList);
      }
    } else {
      homeExamState.value = Failed(e: 'TestInstanceId Not Loaded');
    }
  }

  /// generate practice test ids
  Future generatePracticeTestId() async {
    final result = await examRepo.generatePracticeTestId(
      studentId: studentId.toString(),
    );

    result.fold(
      (failure) {
        testInstanceIDList.add(0);
      },
      (data) async {
        testInstanceIDList.add(data);
        await firestoreService.updateListExamId(
          userName: docName,
          examId: testInstanceIDList,
        );
      },
    );

    // log('practiceTestIdList => $testInstanceIDList');
  }

  Future<AppUserInfo?> getUserInfo() async {
    docName = await getDocumentName();
    AppUserInfo? userInfo =
        await firestoreService.getCurrentUserDocument(userName: docName);
    return userInfo;
  }

  /// used to findthe  number of test completed today
  Future checkTestCompletion() async {
    for (var i = 0; i < testInstanceIDList.length; i++) {
      final result = await examRepo.checkTestCompletion(
        studentId: studentId.toString(),
        instanceId: testInstanceIDList[i].toString(),
      );

      result.fold((failure) {
        noOfTestCompletedToday.value = 0;
      }, (data) {
        if (data == true) {
          noOfTestCompletedToday.value++;
        }
      });
    }
    // log('NO OF TEST COMPLETED TODAY ==> $noOfTestCompletedToday');
  }

  RxInt bioCount = RxInt(0);
  RxInt phyCount = RxInt(0);
  RxInt checCount = RxInt(0);

  RxList<TestCompletionResult> physicsResult = RxList([]);
  RxList<TestCompletionResult> chemistryResult = RxList([]);
  RxList<TestCompletionResult> biologyResult = RxList([]);

  RxList<TestCompletionReport> physicsTestCompletionReport = RxList([]);
  RxList<TestCompletionReport> chemistryTestCompletionReport = RxList([]);
  RxList<TestCompletionReport> biologyTestCompletionReport = RxList([]);

  Rxn<TestCompletionReport> phyTestCompletionReport = Rxn(null);
  Rxn<TestCompletionReport> cheTestCompletionReport = Rxn(null);
  Rxn<TestCompletionReport> bioTestCompletionReport = Rxn(null);

  // TestCompletionReport

  Future getPracticeTestDeails() async {
    for (var i = 0; i < 3; i++) {
      final result = await examRepo.getPracticeTestDetails(
        studentId: studentId.toString(),
        instanceId: testInstanceIDList[i].toString(),
      );

      result.fold((failure) {
        totalTestDonePerDay.value = 0;
      }, (data) {
        bioCount.value = bioCount.value + data.biologyCounter;
        // log('bioCount => ${bioCount.value}');
        phyCount.value = phyCount.value + data.physicsCounter;
        // log('phyCount => ${phyCount.value}');
        checCount.value = checCount.value + data.chemistryCounter;
        // log('checCount => ${checCount.value}');

        physicsResult.add(data.phy);
        chemistryResult.add(data.che);
        biologyResult.add(data.bio);

        // log("physicsResult => $physicsResult");
        // log("chemistryResult => $chemistryResult");
        // log("biologyResult => $biologyResult");

        totalTestDonePerDay.value =
            bioCount.value + phyCount.value + checCount.value;

        // log("TOTAL TEST DONR PER DAY ===> $totalTestDonePerDay");
      });
    }

    // physicsTestCompletionReport.add(
    //   TestCompletionReport(
    //     noOfExamsCompleted: phyCount.value,
    //     completionResult: physicsResult,
    //   ),
    // );
    phyTestCompletionReport.value = TestCompletionReport(
      noOfExamsCompleted: phyCount.value,
      completionResult: physicsResult,
    );

    // chemistryTestCompletionReport.add(
    //   TestCompletionReport(
    //     noOfExamsCompleted: checCount.value,
    //     completionResult: chemistryResult,
    //   ),
    // );
    cheTestCompletionReport.value = TestCompletionReport(
      noOfExamsCompleted: checCount.value,
      completionResult: chemistryResult,
    );

    // biologyTestCompletionReport.add(
    //   TestCompletionReport(
    //     noOfExamsCompleted: bioCount.value,
    //     completionResult: biologyResult,
    //   ),
    // );

    bioTestCompletionReport.value = TestCompletionReport(
      noOfExamsCompleted: bioCount.value,
      completionResult: biologyResult,
    );

    // log('PHYSICS TEST RESULTS : $phyTestCompletionReport');
    // log('CHEMISTRY TEST RESULTS : $cheTestCompletionReport');
    // log('BIOLOGY TEST RESULTS : $bioTestCompletionReport');
  }

  Future fetchAndUpdateStreakValues() async {
    streaksState.value = Loading();
    try {
      final streakFromFirebase =
          await firestoreService.getStreakValueFromFirebase(userName: docName);
      // log("streakFromFirebase : $streakFromFirebase");

      currentStreakValues.value =
          List<int>.from(findStreak(streakFromFirebase));

      await firestoreService.setStreakData(
        streakvalue: currentStreakValues,
        userName: docName,
      );
      streaksState.value = Success(data: currentStreakValues);
    } on Exception {
      streaksState.value = Success(data: [-1, -1, -1, -1, -1, -1, -1]);
    }

    // log("STREAKS DATA  : $currentStreakValues");
  }

  List findStreak(List streakList) {
    int todayResponse = 0;
    if (noOfTestCompletedToday.value == 3) {
      todayResponse = 1;
    } else {
      todayResponse = 0;
    }
    int? indexOfToday;
    String data = DateFormat('EEEE').format(DateTime.now());

    indexOfToday = weekDaysMap[data];
    // log("indexOfToday ==> $indexOfToday");
    streakList[indexOfToday ?? 0] = todayResponse;
    for (int j = (indexOfToday ?? 0) + 1; j < 7; j++) {
      streakList[j] = -1;
    }
    return streakList;
  }
}
