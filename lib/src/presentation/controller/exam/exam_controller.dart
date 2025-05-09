import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/models/exam_report.dart';
import 'package:neuflo_learn/src/data/models/question.dart';
import 'package:neuflo_learn/src/data/repositories/exam/exam_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/domain/repositories/exam/exam_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/navigation/navigation_controller.dart';

class ExamController extends GetxController {
  final appctrl = Get.find<AppStartupController>();
  final nctr = Get.find<Navigationcontroller>();
  TokenRepo tokenRepo = TokenRepoImpl();

  RxInt min = RxInt(0);

  RxInt targetSecond = RxInt(0);

  ///for mockTest;
  var physicsIds = [];
  var chemistryIds = [];
  var botonyIds = [];
  var zoologyIds = [];

  /// exam repo
  ExamRepo examRepo = ExamRepoImpl();

  RxBool isReportLoading = RxBool(false);

  /// hive service
  HiveService hiveService = HiveService();

  /// firestore service
  FirestoreService firestoreService = FirestoreService();

  /// exam page view controller
  PageController pageController = PageController();

  /// toggle all exam numbers
  RxBool isExpanded = RxBool(false);

  var resuLT = [].obs;

  /// current page number
  RxInt page = RxInt(0);

  /// flagged index list
  RxList<int> flagList = RxList([]);

  AppUserInfo? appUserInfo;

  /// current test instance id
  int currentTestInstanceId = 0;

  RxInt studentId = RxInt(0);

  /// current subject name
  String currentSubjectName = '';

  Rx<Ds<List<Question>>> examState = Rx(Initial());

  RxInt lastSkippedIndex = RxInt(0);

  RxInt testInstanceId = RxInt(0);

  RxInt testId = RxInt(0); //v2

  RxBool showExplanation = RxBool(true);

  RxString accessToken = RxString('');
  RxString refreshToken = RxString('');

  RxBool instantEvaluvation = RxBool(true);

  RxBool timeLimit = RxBool(false);

  RxBool timerExpired = RxBool(false);

  void setCurrentPageIndex({required int index}) {
    page.value = index;
  }

  @override
  void onInit() async {
    super.onInit();
    getUserInfo();
    accessToken.value = await appctrl.getAccessToken() ?? '';
    refreshToken.value = await appctrl.getRefreshToken() ?? '';

    log("accessToken :$accessToken\nrefreshToken :$refreshToken");
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
    appUserInfo = await firestoreService.getCurrentUserDocument(
      userName: docName,
    );
    studentId.value = int.parse(appUserInfo?.id.toString() ?? '0');
    log("studentId:${studentId.value} in getUserInfo()");
    return appUserInfo;
  }

  /// Go to next page
  void gotoNext() {
    if (page.value < questionList.length - 1) {
      log("current page : ${page.value}");

      // Save the last index before navigating
      lastVisitedIndex.value = page.value;

      log(" SETTING ===>  lastVisitedIndex =>  $lastVisitedIndex");

      page.value = page.value + 1;
      // log("going to page : ${page.value}");
      pageController.animateToPage(
        page.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      lastVisitedIndex.value = page.value;
      // setCurrentVisitedIndex(index: page.value);
    }
  }

  /// Go to previous page
  void gotoPrev() {
    // Save the last index before navigating
    lastVisitedIndex.value = page.value;
    log(" SETTING ===>  lastVisitedIndex =>  $lastVisitedIndex");

    if (page.value > 0) {
      // Prevent going to index 0 when already on the first page
      page.value = page.value - 1; // Update the RxInt
      pageController.animateToPage(
        page.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      lastVisitedIndex.value = page.value;
    } else {
      log("Already on the first page!");
    }
  }

  /// Go to previous page
  void gotoPage({required int pageIndex}) {
    log("JUMPING TO INDEX : $pageIndex");

    // log("currentQuestionIndex : $currentQuestionIndex");

    currentQuestionIndex.value = pageIndex;
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  RxInt checkIndex = RxInt(0);
  void indexupdate({required int index}) {
    checkIndex.value = index;
  }

  void toggleIsxapanded() {
    isExpanded.value = !isExpanded.value;
    // log("isExpanded => $isExpanded");
  }

  /// add flags
  void markFlagged({required int index}) {
    if (flagList.contains(index)) {
      flagList.remove(index);
    } else {
      flagList.add(index);
    }
  }

  RxInt secondsLeft = 0.obs; // Start with 0 seconds for unlimited timer
  Timer? _timer;
  bool isTimerRunning = false; // To track if the timer is running

  // Start the timer
  void startTimer() {
    if (isTimerRunning) return; // Prevent starting another timer

    isTimerRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      secondsLeft.value++; // Increment seconds left every second

      // log(
      //   "TOTAL TIME ELAPSED : ${secondsLeft.value}, target :${targetSecond.value}, timeLimit : ${timeLimit.value}",
      // );
      if (secondsLeft.value > targetSecond.value && timeLimit.value) {
        timerExpired.value = true;
        stopTimer();
      }
    });
  }

  RxString leVEl = RxString('');

  // Stop the timer
  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      isTimerRunning = false;
    }
  }

  // Reset the timer
  void resetTimer() {
    stopTimer(); // Stop the current timer
    secondsLeft.value = 0; // Reset to initial time (0 seconds)
  }

  RxDouble minutespassed = RxDouble(0);

  // Get the formatted time in HH:mm:ss
  String get formattedTime {
    int hours = (secondsLeft.value / 3600).floor();
    int minutes = ((secondsLeft.value % 3600) / 60).floor();
    int seconds = secondsLeft.value % 60;

    // Format time as HH:mm:ss
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  // Helper function to format numbers with two digits (e.g., 09 instead of 9)
  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  /// time taken to submit
  ///
  ///

  RxInt elapsedTime = RxInt(0); // initial time set to 0
  RxBool isAvgTimerRunning = RxBool(false); // To track if the timer is running
  Timer? _avgTimer; // Use a Timer object instead of relying on Future.delayed

  // Start the timer when the question loads
  void startAvgTimer() {
    if (isAvgTimerRunning.value) return; // Avoid starting multiple timers
    isAvgTimerRunning.value = true;
    _avgTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime.value++; // Increment the counter every second
      // log('elapsedTime ==> ${elapsedTime.value}');
    });
  }

  // Reset the timer when the user submits an answer or on page change
  void resetAvgTimer() {
    _avgTimer?.cancel(); // Stop any existing timer
    elapsedTime.value = 0; // Reset the counter to 0
    isAvgTimerRunning.value = false; // Ensure the timer is marked as stopped
  }

  ////

  void setSubjectName({required String subj}) {
    currentSubjectName = subj;
  }

  void setTestInstanceId({required int id}) {
    currentTestInstanceId = id;
    log("current test test instance id : $currentTestInstanceId");
  }

  /// get practice test exam questions
  Future getPracticeTestQuestions({
    required String subjectName,
    required String testlevel,
  }) async {
    final result = await examRepo.getPracticeTestQuestions(
      studentId: studentId.value,
      subjectName: currentSubjectName,
      testlevel: testlevel,
      accessToken: accessToken.value,
    );

    result.fold(
      (failure) async {
        log("failure:${failure.message}");
        if (failure.message == "user is not authorised" ||
            failure.message == 'api rejected our request') {
          log("attempt the refresh token");
          //call the refreshtoken then update the access token then call this method

          final resp = await tokenRepo.getNewTokens(
            refreshToken: refreshToken.value,
          );
          resp.fold(
            (l) {
              log("failed to get new token:${l.message}");
              examState.value = Failed();
            },
            (r) async {
              accessToken.value = r['access_token'];
              refreshToken.value = r['refresh_token'];
              await appctrl.saveToken(
                accessToken: r['access_token'],
                refreshToken: r['refresh_token'],
              );
              getPracticeTestQuestions(
                subjectName: subjectName,
                testlevel: testlevel,
              );
            },
          );
        } else {
          questionList.value = [];
          examState.value = Failed();
        }
      },
      (data) {
        questionList.value = data["questions"];
        tempQuestionList.value = data["questions"];
        testId.value = data["practiceTestID"];
        log("testIDvAlue:$testId");

        examState.value = Success(data: questionList);
        startTimer();

        if (kDebugMode) {
          log(
            "${questionList.length} QUESTIONS LOADED FOR $currentSubjectName",
          );
        }
      },
    );
  }

  initiatemockTest() async {
    try {
      examState.value = Loading();
      setSubjectName(subj: 'MockTest');
      getMockTestQuestions(studentId: studentId.value);
    } catch (e) {
      log("Error:$e");
      examState.value = Failed();
    }
  }

  Future getMockTestQuestions({required int studentId}) async {
    final result = await examRepo.getmockTestQuestions(
      studentId: studentId,
      accesstoken: accessToken.value,
    );

    result.fold(
      (failure) async {
        log("Failure:${failure.message}");

        if (failure.message == 'user is not authorised') {
          final resp = await tokenRepo.getNewTokens(
            refreshToken: refreshToken.value,
          );
          resp.fold(
            (l) {
              log("failed to get new token:${l.message}");
              examState.value = Failed();
            },
            (r) async {
              accessToken.value = r['access_token'];
              refreshToken.value = r['refresh_token'];
              await appctrl.saveToken(
                accessToken: r['access_token'],
                refreshToken: r['refresh_token'],
              );
              await getMockTestQuestions(studentId: studentId);
            },
          );
        }

        questionList.value = [];
        examState.value = Failed();
      },
      (data) {
        testId.value = data["mock_test_id"];
        physicsIds = data["physicsIds"];
        chemistryIds = data["chemistryIds"];
        botonyIds = data["BotanyIds"];
        zoologyIds = data["ZoologyIds"];
        questionList.value = data["questions"];
        tempQuestionList.value = data["questions"];
        examState.value = Success(data: questionList);
        startTimer();
      },
    );
  }

  RxInt totalAttenDed = RxInt(0);
  RxList userAttendedPhysicSAnswers = RxList([]);
  RxList userAttendedChemisTryAnswers = RxList([]);
  RxList biologyAnswers = RxList([]);

  Future submitMockTestAnswers() async {
    log("Mock Test Submission");
    log("Test ID: $testId");

    // Calculate total attended questions
    int totalAttended =
        questionList.where((q) => q.selectedOption != null).length;
    log("Attended: $totalAttended");

    // Logging correct and incorrect answers
    log("Correct Answers: ${correctList.length}");
    log("Incorrect Answers: ${inCorrectList.length}");

    // Convert ID lists to Sets for faster lookup
    var physicsIdSet = physicsIds.toSet();
    var chemistryIdSet = chemistryIds.toSet();
    var botanyIdSet = botonyIds.toSet();
    var zoologyIdSet = zoologyIds.toSet();

    // Filter user-attended questions
    var userAnswer =
        questionList.where((q) => q.selectedOption != null).toList();

    // Lists to store categorized answers
    var userAttendedPhysicsAnswers = [];
    var userAttendedChemistryAnswers = [];
    var userAttendedBotanyAnswers = [];
    var userAttendedZoologyAnswers = [];

    // Process user-attended answers and categorize them
    for (var user in userAnswer) {
      var timeValue = answerMap.containsKey(user.questionId.toString())
          ? answerMap[user.questionId.toString()]["time"]
          : null;

      var answerData = {
        "question_id": user.questionId,
        "student_answer": user.selectedOption,
        "original_answer": user.answer,
        "time_taken": timeValue,
      };

      if (physicsIdSet.contains(user.questionId)) {
        userAttendedPhysicsAnswers.add(answerData);
      } else if (chemistryIdSet.contains(user.questionId)) {
        userAttendedChemistryAnswers.add(answerData);
      } else if (botanyIdSet.contains(user.questionId)) {
        userAttendedBotanyAnswers.add(answerData);
      } else if (zoologyIdSet.contains(user.questionId)) {
        userAttendedZoologyAnswers.add(answerData);
      }
    }

    // Final logs for categorized answers
    log("Physics Answers : ${userAttendedPhysicsAnswers.length}");

    log("Chemistry Answers : ${userAttendedChemistryAnswers.length}");
    log("Botany Answers : ${userAttendedChemistryAnswers.length}");
    log("Zoology Answers : ${userAttendedZoologyAnswers.length}");

    totalAttenDed.value = totalAttended;
    userAttendedPhysicSAnswers.value = userAttendedPhysicsAnswers;
    userAttendedChemisTryAnswers.value = userAttendedChemistryAnswers;
    biologyAnswers.value =
        userAttendedBotanyAnswers + userAttendedZoologyAnswers;

    return await subMitMockTest();
  }

  Future<bool> subMitMockTest() async {
    log("Submitting mock test answers...");
    bool isSuccess = false;

    final resp = await examRepo.submitMockTestAnswers(
      accessToken: accessToken.value,
      mockTestId: testId.value,
      studentId: studentId.value,
      totalAttended: totalAttenDed.value,
      correctNumber: correctList.length,
      incorrectNumber: inCorrectList.length,
      physicsAnswers: userAttendedPhysicSAnswers,
      chemistryAnswers: userAttendedChemisTryAnswers,
      totalTimeTaken: secondsLeft.value,
      biologyAnswers: biologyAnswers,
    );

    await resp.fold(
      (f) async {
        log("Error IN FOLD(): ${f.message}");

        if (f.message == 'user is not authorised') {
          log("Attempting to refresh token...");

          final tokenResp = await tokenRepo.getNewTokens(
            refreshToken: refreshToken.value,
          );
          await tokenResp.fold(
            (tokenError) {
              log("Failed to refresh token: ${tokenError.message}");
              examReportState.value = Failed(e: 'Authentication Failed');
              isSuccess = false;
            },
            (tokenSuccess) async {
              log("New token obtained: ${tokenSuccess['access_token']}");

              // Update the tokens
              accessToken.value = tokenSuccess['access_token'];
              refreshToken.value = tokenSuccess['refresh_token'];

              // Save new tokens
              await appctrl.saveToken(
                accessToken: tokenSuccess['access_token'],
                refreshToken: tokenSuccess['refresh_token'],
              );

              log("Retrying API call after token refresh...");
              isSuccess =
                  await subMitMockTest(); // Retry API call with new token
            },
          );
        } else {
          examReportState.value = Failed(e: 'something went wrong');
          isSuccess = false;
        }
      },
      (r) async {
        try {
          log("API Response: ${r["rank"]}");
          log("Before update: ${examReportState.value}");

          examReportState.value = Success(
            data: ExamReport(
              rank: r['rank'] ?? 0,
              score: r['score'] ?? 0,
              timeTaken: r["total_time_taken"] ?? 0,
              percentage: (r['score_percentage'] as num?)?.toDouble() ?? 0.0,
            ),
          );

          log("After update: ${examReportState.value}");
          isSuccess = true;
        } catch (e) {
          log("Error in processing response: $e");
          examReportState.value = Failed(e: e.toString());
          isSuccess = false;
        }
      },
    );

    return isSuccess;
  }

  /// practice test exam start entry point
  Future initiatePracticeTestExam({
    required String subjectName,
    required String testlevel,
  }) async {
    examState.value = Loading();

    try {
      log("initiated --- initiatePracticeTestExam()");

      // await generatePracticeTest();
      // await getPracticeTestQuestionList();
      await getPracticeTestQuestions(
        subjectName: subjectName,
        testlevel: testlevel.toLowerCase(),
      );
    } on Exception {
      examState.value = Failed(e: 'Cannot start exam');
    }
  }

  /// custom test exam start entry point
  Future initiateCustomTestExam({
    required List physicsChapters,
    required List chemistryChapters,
    required List biologyChapters,
    required int noOfQuestions,
  }) async {
    examState.value = Loading();
    try {
      await getCustomTestQuestionList(
        physicsChapters: physicsChapters,
        chemistryChapters: chemistryChapters,
        biologyChapters: biologyChapters,
        noOfQuestions: noOfQuestions,
      );
    } catch (e) {
      examState.value = Failed(e: 'Cannot start exam');
    }
  }

  Future getCustomTestQuestionList({
    required List physicsChapters,
    required List chemistryChapters,
    required List biologyChapters,
    required int noOfQuestions,
    int retryCount = 0, // Add retry count
  }) async {
    if (retryCount > 2) {
      // Limit retries to avoid infinite loops
      log("Max retry attempts reached. Aborting...");
      examState.value = Failed();
      return;
    }

    final result = await examRepo.getCustomTestQuestions(
      accesstoken: accessToken.value,
      studentId: studentId.value,
      physicsChapters: physicsChapters,
      chemistryChapters: chemistryChapters,
      biologyChapters: biologyChapters,
      noOfQuestions: noOfQuestions,
    );

    await result.fold(
      (failure) async {
        log("Failure in fold: ${failure.message}");

        if (failure.message == "user is not authorised" ||
            failure.message == "api rejected our request") {
          log("Attempting refresh token... (Retry: $retryCount)");

          final resp = await tokenRepo.getNewTokens(
            refreshToken: refreshToken.value,
          );

          await resp.fold(
            (l) {
              log("Failed to get new token: ${l.message}");
              examState.value = Failed();
              questionList.value = [];
            },
            (r) async {
              // Save new tokens
              String newAccessToken = r['access_token'];
              String newRefreshToken = r['refresh_token'];

              if (newAccessToken == accessToken.value) {
                log(
                  "New token is the same as old token. Avoiding infinite loop.",
                );
                examState.value = Failed();
                return;
              }

              accessToken.value = newAccessToken;
              refreshToken.value = newRefreshToken;
              await appctrl.saveToken(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );

              await getCustomTestQuestionList(
                physicsChapters: physicsChapters,
                chemistryChapters: chemistryChapters,
                biologyChapters: biologyChapters,
                noOfQuestions: noOfQuestions,
                retryCount: retryCount + 1,
              );
            },
          );
        } else {
          questionList.value = [];
          examState.value = Failed();
        }
      },
      (data) async {
        testId.value = data["custom_test_id"];
        questionList.value = data["questions"];
        tempQuestionList.value = data["questions"];
        examState.value = Success(data: questionList);
        setSubjectName(subj: 'Custom Test');
        startTimer();
      },
    );
  }

  // Future getCustomTestQuestionList({
  //   required List physicsChapters,
  //   required List chemistryChapters,
  //   required List biologyChapters,
  //   required int noOfQuestions,
  // }) async {
  //   final result = await examRepo.getCustomTestQuestions(
  //     studentId: studentId.value,
  //     physicsChapters: physicsChapters,
  //     chemistryChapters: chemistryChapters,
  //     biologyChapters: biologyChapters,
  //     noOfQuestions: noOfQuestions, // Use the provided parameter
  //   );

  //   await result.fold((failure) async {
  //     log("Failure in fold: ${failure.message}");

  //     if (failure.message == "user is not authorised" ||
  //         failure.message == "api rejected our request") {
  //       log("Attempting refresh token...");

  //       final resp =
  //           await tokenRepo.getNewTokens(refreshToken: refreshToken.value);

  //       await resp.fold((l) {
  //         log("Failed to get new token: ${l.message}");
  //         examState.value = Failed();
  //         questionList.value = [];
  //       }, (r) async {
  //         // Save new tokens
  //         accessToken.value = r['access_token'];
  //         refreshToken.value = r['refresh_token'];
  //         await appctrl.saveToken(
  //             accessToken: r['access_token'], refreshToken: r['refresh_token']);

  //         // Retry fetching the questions after refreshing the token
  //         await getCustomTestQuestionList(
  //           physicsChapters: physicsChapters,
  //           chemistryChapters: chemistryChapters,
  //           biologyChapters: biologyChapters,
  //           noOfQuestions: noOfQuestions,
  //         );
  //       });
  //     } else {
  //       questionList.value = [];
  //       examState.value = Failed();
  //     }
  //   }, (data) async {
  //     testId.value = data["custom_test_id"];
  //     questionList.value = data["questions"];
  //     tempQuestionList.value = data["questions"];
  //     examState.value = Success(data: questionList);
  //     setSubjectName(subj: 'Custom Test');
  //     startTimer();

  //     if (kDebugMode) {
  //       log("${questionList.length} QUESTIONS LOADED FOR CUSTOM TEST");
  //     }
  //   });
  // }

  //// EXAM LOGIC
  ///
  ///

  /// stores list questions for the current exam
  RxList<Question> questionList = RxList([]);

  /// stores list questions for the current exam
  RxList<Question> tempQuestionList = RxList([]);

  /// current question
  Rx<Question> currentQuestion = Rx(Question());

  /// current question answer
  Rx<String> currentQnAnswer = RxString('');

  /// user selected option
  Rx<String?> currentUserSelectedOption = Rx<String?>(null);

  /// is question skipped
  RxBool isSkipped = RxBool(false);

  /// is question flagged
  RxBool isFlagged = RxBool(false);

  /// is question flagged
  RxBool isSelected = RxBool(false);

  RxInt lstvalue = RxInt(0);

  /// is question attempted
  RxBool isAttempted = RxBool(false);

  RxInt currentQuestionIndex = RxInt(0);

  ///count of skipped
  RxInt skippedValue = RxInt(0);

  /// set current question
  void setCurrentQuestion({required Question question}) {
    currentQuestion.value = question;
    setCurrentAnswer(answer: currentQuestion.value.answer ?? '');
    setCurrentUserSelectedOption(option: currentQuestion.value.selectedOption);
  }

  void setCurrentQuestionIndex({required int index}) {
    currentQuestionIndex.value = index;
  }

  /// set current answer
  void setCurrentAnswer({required String answer}) {
    currentQnAnswer.value = answer;
    // log("currentQnAnswer => $currentQnAnswer");
  }

  /// set current user selected option
  void setCurrentUserSelectedOption({required String? option}) {
    currentUserSelectedOption.value = option;

    // log("------ currentUserSelectedOption ===> $currentUserSelectedOption");
  }

  void resetToCurrentDeafults() {
    isSubmitted.value = currentQuestion.value.isAttempted ?? false;
    log("submitted or not in resetToCurrentDeafults():$isSubmitted");
    setCurrentUserSelectedOption(option: currentQuestion.value.selectedOption);

    // log(" currentQuestion.value.isMarkedCorrect : ${currentQuestion.value.isMarkedCorrect}");
    // canShowSolution.value =
    //     currentQuestion.value.isMarkedCorrect == true ? false : true;
  }

  RxString optionValueFromTile = RxString('');

  /// set current user selected option
  void setOptionFromTile({required String option}) {
    optionValueFromTile.value = option;

    // log("optionValueFromTile : $optionValueFromTile");
  }

  RxBool isSubmitted = RxBool(false);

  void setSubmittedStatus({required bool staus}) {
    log("submitted or not in submittstatus:$staus");
    isSubmitted.value = staus;
  }

  void submitAnswer() {
    isSubmitted.value = true;
    if (currentUserSelectedOption.value != null) {
      updateIsAttempted();
    }

    canShowAnswer();
    updateSelectedOption();
  }

  RxList<int> correctList = RxList([]);
  RxList<String> correctIdList = RxList([]);
  RxList<int> inCorrectList = RxList([]);

  RxList<String> inCorrectIdList = RxList([]);
  RxList<int> skippedList = RxList([]);
  RxList<String> skippedIds = RxList([]);

  generateCorrectList({required int index, required String id}) {
    correctList.add(index);
    correctIdList.add(id);

    log("NO OF CORRECT ==> ${correctList.length}");
  }

  generateIncorrectList({required int index}) {
    inCorrectList.add(index);

    log("NO OF INCORRECT ==> ${inCorrectList.length}");
  }

  generateIncorrectIdList({required String id}) {
    inCorrectIdList.add(id);
    log("INCORRECT ID LIST : $inCorrectIdList");
    log("skipped list:$skippedList");
  }

  generateSkippedList({required int index, required String id}) {
    log("add to skip :$index id :$id");
    skippedList.add(index);
    skippedIds.add(id);
    log("NO OF SKIPPED ==> ${skippedList.length}");
  }

  void resetValues() {
    optionValueFromTile.value = '';
    isSubmitted.value = false;
    canShowSolution.value = false;
  }

  String mapIndexToOption({required int index}) {
    if (index == 0) {
      return 'a';
    } else if (index == 1) {
      return 'b';
    } else if (index == 2) {
      return 'c';
    } else {
      return 'd';
    }
  }

  /// update value of isSkipped in the object
  void updateIsSkipped() {
    Question? que = questionList.firstWhereOrNull(
      (q) => q.questionId == currentQuestion.value.questionId,
    );

    if (que != null) {
      int index = questionList.indexOf(que);
      Question updated = que.copyWith(isSkipped: true);
      questionList[index] = updated;
    }
    update();
  }

  /// update value of selected option in the object
  void updateSelectedOption() {
    Question? que = questionList.firstWhereOrNull(
      (q) => q.questionId == currentQuestion.value.questionId,
    );

    if (que != null) {
      int index = questionList.indexOf(que);
      Question updated = que.copyWith(
        selectedOption: currentUserSelectedOption.value,
      );
      questionList[index] = updated;
    }

    update();
  }

  /// update value of isSkipped in the object
  void updateIsFlagged() {
    Question? que = questionList.firstWhereOrNull(
      (q) => q.questionId == currentQuestion.value.questionId,
    );

    if (que != null) {
      int index = questionList.indexOf(que);
      isFlagged.value = currentQuestion.value.isFlagged ?? false;
      isFlagged.value = !isFlagged.value;
      Question updated = que.copyWith(isFlagged: isFlagged.value);
      questionList[index] = updated;
    }
    update();
  }

  Future<String> formatSecondsDuration(int seconds) async {
    return "00:30";
  }

  /// update value of isSkipped in the object
  void updateIsAttempted() {
    int currentQuestionIndex = questionList.indexOf(currentQuestion.value);
    Question tempQ = questionList[currentQuestionIndex];

    Question updated = tempQ.copyWith(isAttempted: true);
    questionList[currentQuestionIndex] = updated;
    update();
  }

  /// update value of isSkipped in the object
  void updateIsMarkedCorrect() {
    Question? que = questionList.firstWhereOrNull(
      (q) => q.questionId == currentQuestion.value.questionId,
    );

    if (que != null) {
      int index = questionList.indexOf(que);
      bool isCorrect = currentQnAnswer.value != currentUserSelectedOption.value;

      // log("IS MARKED CORRECT => $isCorrect");
      Question updated = que.copyWith(isMarkedCorrect: isCorrect);
      questionList[index] = updated;
    }
    update();
  }

  RxBool canShowSolution = RxBool(false);
  void canShowAnswer() {
    // log("isSubmitted : $isSubmitted");
    // log("currentQnAnswer : $currentQnAnswer");

    // log("currentUserSelectedOption : $currentUserSelectedOption");

    if (isSubmitted.value) {
      if (currentUserSelectedOption.value != null) {
        if (currentQnAnswer.value != currentUserSelectedOption.value) {
          canShowSolution.value = true;
        } else {
          canShowSolution.value = false;
        }
      }

      if (currentUserSelectedOption.value != null) {
        updateIsMarkedCorrect();
      }
    }
  }

  /// set current user selected option
  void setanShowAnswer() {
    canShowSolution.value =
        currentQuestion.value.isMarkedCorrect == true ? false : true;

    // log("------ currentUserSelectedOption ===> $currentUserSelectedOption");
  }

  void addData({
    required int id,
    required int timeTaken,
  }) {
    resuLT.add({
      "$id": "$timeTaken",
    });
    update();
  }

  void addDetailedAnswer(
      {required int questionId,
      required int subjectId,
      required int chapterId,
      required String selectedAnswer,
      required String originalAnswer,
      required bool isCorrect,
      required int timeTaken}) {
    try {
      detailedAnswers.add({
        "question_id": questionId,
        "subject_id": subjectId,
        "chapter_id": chapterId,
        "selected_answer": selectedAnswer,
        "original_answer": originalAnswer,
        "is_correct": isCorrect,
        "time_taken": timeTaken
      });
      update();
    } catch (e) {
      log("Error:$e");
    }
  }

  Map<String, dynamic> answerMap = {};

  RxInt currentSubjectId = RxInt(0);

  void saveResult() {
    answerMap['${currentQuestion.value.questionId}'] = {
      "answer": currentUserSelectedOption.value,
      "time": elapsedTime.toString(),
    };

    log("ANSWER MAP ==> $answerMap");
  }

  RxString examCompletionTime = RxString('initial');

  Rx<Ds<ExamReport>> examReportState = Rx(Initial());
  Set<int> addedIds = {};

  RxBool goforNext = RxBool(false);

  Future<bool> generateExamReport({
    required String level,
    required String type,
  }) async {
    isReportLoading.value = true;
    examReportState.value = Loading();
    goforNext.value = false;

    if (currentSubjectName == "Physics") {
      currentSubjectId.value = 1;
    } else if (currentSubjectName == "Chemistry") {
      currentSubjectId.value = 2;
    } else if (currentSubjectName == "Biology") {
      currentSubjectId.value = 3;
    }

    log("ANSWERS MAP : $answerMap");
    log("type:$type");

    try {
      bool isSuccess = false;
      if (type == 'PracticeTest') {
        isSuccess = await submitPractiseTest(level: level, type: type);
        if (isSuccess) {
          dailyExamReport(
            subject: currentSubjectName,
            level: level,
            docname: nctr.docName.value,
          );
        } else {
          isReportLoading.value = false;
        }
      } else if (type == 'mocktest') {
        isSuccess = await submitMockTestAnswers();
        if (!isSuccess) {
          isReportLoading.value = false;
        }
      } else {
        isSuccess = await submitCustomTest();
        if (!isSuccess) {
          isReportLoading.value = false;
        }
      }

      if (isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error in generateExamReport: $e");
      isReportLoading.value = false;
      return false;
    }
  }

  dailyExamReport({
    required String subject,
    required String level,
    required String docname,
  }) async {
    log("dailyExamReport() :-> docname:$docname,subject:$subject,level:$level");
    await firestoreService.updateDailyExamReport(
      subject: subject,
      level: level,
      docname: docname,
    );
  }

  // Future generateExamReport(
  //     {required String level, required String type}) async {
  //   examReportState.value = Loading();
  //   goforNext.value = false;
  //   if (currentSubjectName == "Physics") {
  //     currentSubjectId.value = 1;
  //   }
  //   if (currentSubjectName == "Chemistry") {
  //     currentSubjectId.value = 2;
  //   }
  //   if (currentSubjectName == "Biology") {
  //     currentSubjectId.value = 3;
  //   }
  //   log("ANSWERS MAP : $answerMap");
  //   log("type:$type");
  //   try {
  //     if (type == 'PracticeTest') {
  //       await submitPractiseTest(level: level, type: type);
  //     } else if (type == 'mocktest') {
  //       await submitMockTestAnswers();
  //     } else {
  //       await submitCustomTest();
  //     }
  //   } on Exception {
  //     examReportState.value = Failed(
  //       e: 'Exam Report Creation Failed, Try again',
  //     );
  //   } catch (e) {
  //     examReportState.value =
  //         Failed(e: "Exam Report Creation Failed, Try again");
  //   }
  // }

  RxMap<String, String> ansWer = RxMap({});
  RxMap<String, dynamic> qstnAvGTime = RxMap({});

  Future<bool> submitCustomTest() async {
    try {
      log("submit:submitCustomTest()");
      // Calculate total attended questions
      int totalAttended =
          questionList.where((q) => q.selectedOption != null).length;

      totalAttenDed.value = totalAttended;

      Map<String, String> answer = {};
      Map<String, dynamic> qstnAvgTime = {};

      for (int i = 0; i < questionList.length; i++) {
        if (questionList[i].selectedOption != null) {
          String questionId = questionList[i].questionId.toString();

          // Store selected option in answer map
          answer[questionId] = questionList[i].selectedOption.toString();

          // Fetch the time value from answerMap
          if (answerMap.containsKey(questionId)) {
            log("dt:${answerMap[questionId]['time']}");
            qstnAvgTime[questionId] = answerMap[questionId]['time'];
          }
        }
      }
      log("ans:$answer");
      ansWer.value = answer;

      log("qstnAvgTime:$qstnAvgTime");
      qstnAvGTime.value = qstnAvgTime;

      log("timer:${secondsLeft.value}");

      return await submitCustomTestAnswers();
    } catch (e) {
      log("Error in submitCustomTest():$e");
      return false;
    }
  }

  Future<bool> submitCustomTestAnswers({bool isRetrying = false}) async {
    try {
      final resp = await examRepo.submitCustomTestAnswers(
        accesstoken: accessToken.value,
        studentId: studentId.value,
        customTestId: testId.value,
        totalAttended: totalAttenDed.value,
        correctNumber: correctList.length,
        incorrectNumber: inCorrectList.length,
        testAverageTime: secondsLeft.value,
        answer: ansWer,
        questionAvgTime: qstnAvGTime,
      );

      return resp.fold(
        (failure) async {
          log("Submission failed: ${failure.message}");

          // If the token has expired and it's not a retry, refresh and retry
          if ((failure.message == "user is not authorised" ||
                  failure.message == "api rejected our request") &&
              !isRetrying) {
            log("Access token expired. Attempting to refresh...");

            final tokenResp = await tokenRepo.getNewTokens(
              refreshToken: refreshToken.value,
            );

            return tokenResp.fold(
              (tokenFailure) {
                log("Failed to refresh token: ${tokenFailure.message}");
                return false; // Token refresh failed, return failure
              },
              (newTokens) async {
                // Save new tokens
                accessToken.value = newTokens['access_token'];
                refreshToken.value = newTokens['refresh_token'];

                await appctrl.saveToken(
                  accessToken: newTokens['access_token'],
                  refreshToken: newTokens['refresh_token'],
                );

                log("Token refreshed. Retrying submission...");
                return await submitCustomTestAnswers(
                  isRetrying: true,
                ); // Retry API
              },
            );
          }

          return false; // Return failure if not token-related
        },
        (data) {
          examReportState.value = Success(
            data: ExamReport(
              rank: data['rank'],
              score: data['score'],
              timeTaken: data["total_time_taken"],
              percentage: (data['score_percentage'] as num).toDouble(),
            ),
          );
          return true;
        },
      );
    } catch (e) {
      log("Error: $e");
      return false;
    }
  }

  var detailedAnswers = [].obs;
  var resultquestionIdTime;
  final RxSet<String> missingIds = <String>{}.obs;

  Future submitPractiseTest({
    required String level,
    required String type,
  }) async {
    missingIds.clear();
    log("CURRENT SUBJECT ID : $currentSubjectId");
    log("keys:${answerMap.keys},runtimetype:${answerMap.values.runtimeType}");
    log("resuLT 1:$resuLT");

    Set<int> addedIds = {};

    for (int i = 0; i < questionList.length; i++) {
      int id = questionList[i].questionId ?? 0;
      String idString = id.toString(); // Convert ID to string

      if (!addedIds.contains(id)) {
        int timeTaken = 0; // Default to 0

        if (answerMap.containsKey(idString)) {
          var timeValue =
              answerMap[idString]["time"]; // Get the time value safely
          log("timevalue in :$timeValue");
          if (timeValue is int) {
            timeTaken = timeValue; // Assign if it's already an int
          } else if (timeValue is String) {
            timeTaken =
                int.tryParse(timeValue) ?? 1; // Convert String to int safely
          } else {
            log("Invalid time format for ID: $idString");
          }
        } else {
          if (!correctIdList.contains("$id") &&
              !inCorrectIdList.contains("$id") &&
              !skippedIds.contains("$id")) {
            log("id not found and not in any list: $idString");
            missingIds.add(idString);
          }
        }

        addData(
          id: id,
          timeTaken: timeTaken, // Use the correct timeTaken value
        );

        addDetailedAnswer(
            questionId: id,
            subjectId: currentSubjectId.value,
            chapterId: questionList[i].chapterId ?? 0,
            selectedAnswer: questionList[i].selectedOption == null
                ? 'unattempted'
                : questionList[i].selectedOption ?? '',
            originalAnswer: questionList[i].answer ?? '',
            isCorrect: questionList[i].selectedOption == questionList[i].answer
                ? true
                : false,
            timeTaken: timeTaken);

        addedIds.add(id); // Store the added ID
      }
    }

    Map<String, String> result =
        resuLT.fold({}, (acc, map) => {...acc, ...map});
    resultquestionIdTime = result;

    if (currentSubjectId.value == 1) {
    } else if (currentSubjectId.value == 2) {
    } else {
      log("Gotit..................................");
      currentSubjectId.value = 5;
    }
    leVEl.value = level;

    log("final resultquestionIdTime =======>:$resultquestionIdTime");
    log("detailed Answer:$detailedAnswers");
    log("corrected List:$correctIdList");
    log("corrected count:${correctIdList.length}");

    log("incorrect List:$inCorrectIdList");
    log("incorrect count:${inCorrectIdList.length}");

    log("unattempted ids:$missingIds");
    log("unattempted count:${missingIds.length}");

    log("skipped list:$skippedList");
    log("len skipped:${skippedList.length}");
    // return await submitPracticetestAnswers();
  }

  // Future<void> submitPracticetestAnswers() async {
  //   final resp = await examRepo.sumbitPracticeTestAnswers(
  //       accessToken: accessToken.value,
  //       practiceTestId: testId.value,
  //       studentId: studentId.value,
  //       subjectId: currentSubjectId.value,
  //       testLevel: leVEl.value,
  //       totalTimeTaken: secondsLeft.value,
  //       questions: resuLT);

  //   resp.fold((l) async {
  //     log("error:${l.message}");
  //     if (l.message == 'user is not authorised') {
  //       log("attempt the refresh token");
  //       //call the refreshtoken then update the access token then call this method

  //       final resp =
  //           await tokenRepo.getNewTokens(refreshToken: refreshToken.value);

  //       resp.fold((l) {
  //         log("failed to get new token:${l.message}");
  //         examReportState.value = Failed();
  //       }, (r) async {
  //         accessToken.value = r['access_token'];
  //         refreshToken.value = r['refresh_token'];
  //         await appctrl.saveToken(
  //             accessToken: r['access_token'], refreshToken: r['refresh_token']);
  //         await submitPracticetestAnswers();
  //       });
  //     } else {
  //       examReportState.value =
  //           Failed(e: 'Exam Report Creation Failed, Try again');
  //     }
  //   }, (r) async {
  //     log("success:$r");
  //     int? rank = r['rank'] ?? 0;
  //     int? score = r['score'] ?? 0;

  //     double? scorepercentage = r['score_percentage'];

  //     examReportState.value = Success(
  //       data: ExamReport(
  //           rank: rank,
  //           score: score,
  //           timeTaken: r["total_time_taken"],
  //           percentage: scorepercentage),
  //     );
  //   });
  // }

  Future<bool> submitPracticetestAnswers() async {
    log("Submitting practice test answers...");

    final resp = await examRepo.sumbitPracticeTestAnswers(
        accessToken: accessToken.value,
        totalquestions: questionList.length,
        correctAnswer: correctList.length,
        incorrectAnswer: inCorrectIdList.length,
        skippedAnswer: skippedIds.length,
        unattemptedAnswer: missingIds.length,
        totalAttended: correctList.length + inCorrectIdList.length,
        practiceTestId: testId.value,
        subjectId: currentSubjectId.value,
        testLevel: leVEl.value,
        totalTimeTaken: secondsLeft.value,
        detailedAnswers: detailedAnswers,
        subjectName: currentSubjectName,
        questionIdTime: resultquestionIdTime);

    bool isSuccess = false;

    await resp.fold(
      (l) async {
        log("Error: ${l.message}");

        if (l.message == 'user is not authorised') {
          log("Attempting to refresh token...");

          final tokenResp = await tokenRepo.getNewTokens(
            refreshToken: refreshToken.value,
          );
          await tokenResp.fold(
            (tokenError) {
              log("Failed to refresh token: ${tokenError.message}");
              examReportState.value = Failed(e: 'Authentication Failed');
              update(); // Ensure UI updates
              isSuccess = false;
            },
            (tokenSuccess) async {
              log("New token obtained: ${tokenSuccess['access_token']}");

              accessToken.value = tokenSuccess['access_token'];
              refreshToken.value = tokenSuccess['refresh_token'];

              await appctrl.saveToken(
                accessToken: tokenSuccess['access_token'],
                refreshToken: tokenSuccess['refresh_token'],
              );

              log("Retrying API call after token refresh...");
              isSuccess =
                  await submitPracticetestAnswers(); // ✅ Returns a boolean
            },
          );
        } else {
          examReportState.value = Failed(
            e: 'Exam Report Creation Failed, Try again',
          );
          update();
          isSuccess = false;
        }
      },
      (result) async {
        try {
          log("API Response: ${result["rank"]}");
          log("Before update: ${examReportState.value}");

          examReportState.value = Success(
            data: ExamReport(
              rank: result["rank"] ?? 0,
              score: result["score"] ?? 0,
              timeTaken: result["total_time_taken"] ?? 0,
              percentage: result["score_percentage"] ?? 0.0,
            ),
          );

          goforNext.value = true;
          update(); // Ensure GetX updates UI

          log("After update: ${examReportState.value}");
          isSuccess = true;
        } catch (e) {
          log("Error in processing response: $e");
          examReportState.value = Failed(e: e.toString());
          update();
          isSuccess = false;
        }
      },
    );

    return isSuccess;
  }

  // Future<void> submitPracticetestAnswers() async {
  //   log("Submitting practice test answers...");

  //   final resp = await examRepo.sumbitPracticeTestAnswers(
  //       accessToken: accessToken.value,
  //       practiceTestId: testId.value,
  //       studentId: studentId.value,
  //       subjectId: currentSubjectId.value,
  //       testLevel: leVEl.value,
  //       totalTimeTaken: secondsLeft.value,
  //       questions: resuLT);

  //   resp.fold((l) async {
  //     log("Error: ${l.message}");

  //     if (l.message == 'user is not authorised') {
  //       log("Attempting to refresh token...");

  //       final tokenResp =
  //           await tokenRepo.getNewTokens(refreshToken: refreshToken.value);
  //       tokenResp.fold((tokenError) {
  //         log("Failed to refresh token: ${tokenError.message}");
  //         examReportState.value = Failed(e: 'Authentication Failed');
  //         update(); // Force UI update (GetX)
  //       }, (tokenSuccess) async {
  //         log("New token obtained: ${tokenSuccess['access_token']}");

  //         accessToken.value = tokenSuccess['access_token'];
  //         refreshToken.value = tokenSuccess['refresh_token'];

  //         await appctrl.saveToken(
  //             accessToken: tokenSuccess['access_token'],
  //             refreshToken: tokenSuccess['refresh_token']);

  //         log("Retrying API call after token refresh...");
  //         await submitPracticetestAnswers();
  //       });
  //     } else {
  //       examReportState.value =
  //           Failed(e: 'Exam Report Creation Failed, Try again');
  //     }
  //   }, (result) async {
  //     try {
  //       log("API Response: ${result["rank"]}");
  //       log("Before update: ${examReportState.value}");
  //       examReportState.value = Success(
  //         data: ExamReport(
  //           rank: result["rank"] ?? 0,
  //           score: result["score"] ?? 0,
  //           timeTaken: result["total_time_taken"] ?? 0,
  //           percentage: result["score_percentage"] ?? 0.0,
  //         ),
  //       );
  //       goforNext.value = true;
  //       update();
  //       log("after update: ${examReportState.value}");
  //     } catch (e) {
  //       log("Error in my point:$e");
  //       examReportState.value = Failed(e: e.toString());
  //     }
  //   });
  // }

  // Future<void> submitPracticetestAnswers() async {
  //   log("Submitting practice test answers...");

  //   final resp = await examRepo.sumbitPracticeTestAnswers(
  //       accessToken: accessToken.value,
  //       practiceTestId: testId.value,
  //       studentId: studentId.value,
  //       subjectId: currentSubjectId.value,
  //       testLevel: leVEl.value,
  //       totalTimeTaken: secondsLeft.value,
  //       questions: resuLT);

  //   resp.fold((l) async {
  //     log("Error: ${l.message}");

  //     if (l.message == 'user is not authorised') {
  //       log("Attempting to refresh token...");

  //       final tokenResp =
  //           await tokenRepo.getNewTokens(refreshToken: refreshToken.value);
  //       tokenResp.fold((tokenError) {
  //         log("Failed to refresh token: ${tokenError.message}");
  //         examReportState.value = Failed(e: 'Authentication Failed');
  //       }, (tokenSuccess) async {
  //         accessToken.value = tokenSuccess['access_token'];
  //         refreshToken.value = tokenSuccess['refresh_token'];

  //         await appctrl.saveToken(
  //             accessToken: tokenSuccess['access_token'],
  //             refreshToken: tokenSuccess['refresh_token']);

  //         await submitPracticetestAnswers();
  //         // Retry submission
  //       });
  //     } else {
  //       examReportState.value =
  //           Failed(e: 'Exam Report Creation Failed, Try again');
  //     }
  //   }, (r) async {
  //     log("API Response: $r");

  //     if (r.containsKey('rank') &&
  //         r.containsKey('score') &&
  //         r.containsKey('score_percentage')) {
  //       examReportState.value = Success(
  //         data: ExamReport(
  //             rank: r['rank'] ?? 0,
  //             score: r['score'] ?? 0,
  //             timeTaken: r["total_time_taken"] ?? 0,
  //             percentage: r['score_percentage'] ?? 0.0),
  //       );
  //     } else {
  //       log("Unexpected response format: $r");
  //       examReportState.value = Failed(e: 'Invalid response format');
  //     }
  //   });
  // }

  int calculateUnattemptedQnNumber() {
    int unAttempted = 0;
    for (var q in questionList) {
      if (!answerMap.containsKey(q.questionId.toString())) {
        unAttempted++;
      }
    }
    return unAttempted;
  }

  void resetExamValues() {
    resetAvgTimer();
  }

  /// handle ship logic
  ///
  RxInt lastVisitedIndex = (-1).obs;

  void goToLastVisited() {
    // Save the last visited index before jumping
    log("lastVisitedIndex : $lastVisitedIndex");
    lastVisitedIndex.value = page.value;
    page.value = lastVisitedIndex.value;
    gotoPage(pageIndex: lastVisitedIndex.value);
  }

  RxString filterStatus = RxString('All');

  void filterAll() {
    questionList.value = tempQuestionList;
    filterStatus.value = "All";
    if (kDebugMode) {
      log("ALL : ${questionList.length}");
    }
  }

  void filterCorrect() {
    filterStatus.value = "Correct";
    questionList.value = [];
    questionList.value = tempQuestionList;
    questionList.value =
        questionList.where((q) => q.answer == q.selectedOption).toList();

    if (kDebugMode) {
      log("CORRECT : ${questionList.length}");
    }
  }

  void filterInCorrect() {
    filterStatus.value = "Incorrect";
    questionList.value = [];
    questionList.value = tempQuestionList;
    questionList.value = questionList
        .where(
          (q) => (q.answer != q.selectedOption && q.selectedOption != null),
        )
        .toList();

    if (kDebugMode) {
      log("INCORRECT : ${questionList.length}");
    }
  }

  void filterSkipped() {
    filterStatus.value = "Skipped";
    questionList.value = [];
    questionList.value = tempQuestionList;
    questionList.value =
        questionList.where((q) => q.selectedOption == null).toList();

    if (kDebugMode) {
      log("SKIPPED : ${questionList.length}");
    }
  }

  void skippedCount() {
    log("skip updating manuallyyyyyyyyyyyy");
    int unattempted = 0;
    for (int i = 0; i < questionList.length; i++) {
      if (questionList[i].selectedOption == null) {
        unattempted++;
      }
    }
    // log("skipped counter:$unattempted");
    skippedValue.value = unattempted;
    update();
  }

  @override
  void onClose() {
    // Ensure we cancel the timer if the controller is disposed
    log("disposed.......");
    isReportLoading.value = false;
    _avgTimer?.cancel();
    _timer?.cancel();
    stopTimer();
    startAvgTimer();
    super.onClose();
  }
}
