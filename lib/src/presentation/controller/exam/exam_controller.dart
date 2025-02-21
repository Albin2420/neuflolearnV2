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
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/domain/repositories/exam/exam_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class ExamController extends GetxController {
  final appctrl = Get.find<AppStartupController>();

  RxInt min = RxInt(0);

  ///for mockTest;
  var physicsIds = [];
  var chemistryIds = [];
  var botonyIds = [];
  var zoologyIds = [];

  /// exam repo
  ExamRepo examRepo = ExamRepoImpl();

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

  void setCurrentPageIndex({required int index}) {
    page.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    // Get.to(() => TestSettingsSheet());
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
    appUserInfo =
        await firestoreService.getCurrentUserDocument(userName: docName);
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

      log("TOTAL TIME ELAPSED : ${secondsLeft.value}");
    });
  }

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
  Future getPracticeTestQuestions(
      {required String subjectName, required String testlevel}) async {
    final result = await examRepo.getPracticeTestQuestions(
        studentId: studentId.value,
        subjectName: currentSubjectName,
        testlevel: testlevel);

    result.fold((failure) {
      questionList.value = [];
    }, (data) {
      questionList.value = data["questions"];
      tempQuestionList.value = data["questions"];
      testId.value = data["practiceTestID"];

      if (kDebugMode) {
        log("${questionList.length} QUESTIONS LOADED FOR $currentSubjectName");
      }
    });
  }

  /// get practice test exam questions
  Future getCustomTestQuestionList({
    required List physicsChapters,
    required List chemistryChapters,
    required List biologyChapters,
    required int noOfQuestions,
  }) async {
    final result = await examRepo.getCustomTestQuestions(
      studentId: studentId.value,
      physicsChapters: physicsChapters,
      chemistryChapters: chemistryChapters,
      biologyChapters: biologyChapters,
      noOfQuestions: 20,
    );

    result.fold((failure) {
      questionList.value = [];
    }, (data) {
      testId.value = data["custom_test_id"];
      questionList.value = data["questions"];
      tempQuestionList.value = data["questions"];
      if (kDebugMode) {
        log("${questionList.length} QUESTIONS LOADED FOR CUSTOM TEST");
      }
    });
  }

  initiatemockTest() async {
    try {
      examState.value = Loading();
      await getMockTestQuestions(studentId: studentId.value);
      examState.value = Success(data: questionList);
      startTimer();
    } catch (e) {
      log("Error:$e");
    }
  }

  Future getMockTestQuestions({required int studentId}) async {
    final result = await examRepo.getmockTestQuestions(studentId: studentId);

    result.fold((failure) {
      questionList.value = [];
    }, (data) {
      testId.value = data["mock_test_id"];
      physicsIds = data["physicsIds"];
      chemistryIds = data["chemistryIds"];
      botonyIds = data["BotanyIds"];
      zoologyIds = data["ZoologyIds"];
      questionList.value = data["questions"];
      tempQuestionList.value = data["questions"];
    });
  }

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

    final resp = await examRepo.submitMockTestAnswers(
        mockTestId: testId.value,
        studentId: studentId.value,
        totalAttended: totalAttended,
        correctNumber: correctList.length,
        incorrectNumber: inCorrectList.length,
        physicsAnswers: userAttendedPhysicsAnswers,
        chemistryAnswers: userAttendedChemistryAnswers,
        totalTimeTaken: secondsLeft.value,
        biologyAnswers: userAttendedBotanyAnswers + userAttendedZoologyAnswers);

    resp.fold((f) {
      log("failed");
    }, (r) async {
      examReportState.value = Success(
        data: ExamReport(
            rank: r['rank'],
            score: r['score'],
            timeTaken: r["total_time_taken"],
            percentage: r['score_percentage']),
      );
    });
  }

  /// practice test exam start entry point
  Future initiatePracticeTestExam(
      {required String subjectName, required String testlevel}) async {
    examState.value = Loading();

    try {
      log("initiated --- initiatePracticeTestExam()");

      // await generatePracticeTest();
      // await getPracticeTestQuestionList();
      await getPracticeTestQuestions(
        subjectName: subjectName,
        testlevel: testlevel.toLowerCase(),
      );
      examState.value = Success(data: questionList);
      startTimer();
    } on Exception {
      examState.value = Failed(e: 'Cannot start exam');
    }
  }

  /// custom test exam start entry point
  Future initiateCustomTestExam(
      {required List physicsChapters,
      required List chemistryChapters,
      required List biologyChapters,
      required int noOfQuestions}) async {
    examState.value = Loading();
    try {
      // await generatePracticeTest();
      await getCustomTestQuestionList(
        physicsChapters: physicsChapters,
        chemistryChapters: chemistryChapters,
        biologyChapters: biologyChapters,
        noOfQuestions: noOfQuestions,
      );
      examState.value = Success(data: questionList);
      startTimer();
    } on Exception {
      examState.value = Failed(e: 'Cannot start exam');
    }
  }

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
  RxList<int> inCorrectList = RxList([]);

  RxList<int> inCorrectIdList = RxList([]);
  RxList<int> skippedList = RxList([]);

  generateCorrectList({required int index}) {
    correctList.add(index);

    log("NO OF CORRECT ==> ${correctList.length}");
  }

  generateIncorrectList({required int index}) {
    inCorrectList.add(index);

    log("NO OF INCORRECT ==> ${inCorrectList.length}");
  }

  generateIncorrectIdList({required int index}) {
    inCorrectIdList.add(index);
    log("INCORRECT ID LIST : $inCorrectIdList");
  }

  generateSkippedList({required int index}) {
    skippedList.add(index);
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
        (q) => q.questionId == currentQuestion.value.questionId);

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
        (q) => q.questionId == currentQuestion.value.questionId);

    if (que != null) {
      int index = questionList.indexOf(que);
      Question updated =
          que.copyWith(selectedOption: currentUserSelectedOption.value);
      questionList[index] = updated;
    }

    update();
  }

  /// update value of isSkipped in the object
  void updateIsFlagged() {
    Question? que = questionList.firstWhereOrNull(
        (q) => q.questionId == currentQuestion.value.questionId);

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
        (q) => q.questionId == currentQuestion.value.questionId);

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

  void addData(
      {required int id, required String selectedOpt, required int timeTaken}) {
    resuLT.add({
      "question_id": id,
      "selected_option": selectedOpt,
      "time_taken": timeTaken,
    });
    update();
  }

  Map<String, dynamic> answerMap = {};

  RxInt currentSubjectId = RxInt(0);

  void saveResult() {
    answerMap['${currentQuestion.value.questionId}'] = {
      "answer": currentUserSelectedOption.value,
      "time": elapsedTime.toString()
    };

    log("ANSWER MAP ==> $answerMap");
  }

  RxString examCompletionTime = RxString('initial');

  Rx<Ds<ExamReport>> examReportState = Rx(Initial());
  Set<int> addedIds = {};

  Future generateExamReport(
      {required String level, required String type}) async {
    examReportState.value = Loading();
    if (currentSubjectName == "Physics") {
      currentSubjectId.value = 1;
    }
    if (currentSubjectName == "Chemistry") {
      currentSubjectId.value = 2;
    }
    if (currentSubjectName == "Biology") {
      currentSubjectId.value = 3;
    }
    log("ANSWERS MAP : $answerMap");
    log("type:$type");
    try {
      if (type == 'PracticeTest') {
        await submitPractiseTest(level: level, type: type);
      } else if (type == 'mocktest') {
        await submitMockTestAnswers();
      } else {
        await submitCustomTest();
      }

      resetAvgTimer();
      resetTimer();
    } on Exception {
      examReportState.value = Failed(
        e: 'Exam Report Creation Failed, Try again',
      );
    }
  }

  Future<void> submitCustomTest() async {
    try {
      log("submit:submitCustomTest()");
      // Calculate total attended questions
      int totalAttended =
          questionList.where((q) => q.selectedOption != null).length;

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

      log("qstnAvgTime:$qstnAvgTime");

      log("timer:${secondsLeft.value}");

      final resp = await examRepo.submitCustomTestAnswers(
          studentId: studentId.value,
          customTestId: testId.value,
          totalAttended: totalAttended,
          correctNumber: correctList.length,
          incorrectNumber: inCorrectList.length,
          testAverageTime: secondsLeft.value,
          answer: answer,
          questionAvgTime: qstnAvgTime);

      resp.fold((f) {
        log("got it");
      }, (r) {
        examReportState.value = Success(
          data: ExamReport(
              rank: r['rank'],
              score: r['score'],
              timeTaken: r["total_time_taken"],
              percentage: r['score_percentage']),
        );
      });
    } catch (e) {
      log("Error in submitCustomTest():$e");
    }
  }

  Future submitPractiseTest(
      {required String level, required String type}) async {
    log("CURRENT SUBJECT ID : $currentSubjectId");
    log("keys:${answerMap.keys},runtimetype:${answerMap.keys.runtimeType}");
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
          if (timeValue is int) {
            timeTaken = timeValue; // Assign if it's already an int
          } else if (timeValue is String) {
            timeTaken =
                int.tryParse(timeValue) ?? 0; // Convert String to int safely
          } else {
            log("Invalid time format for ID: $idString");
          }
        } else {
          log("Not found: $idString"); // Log missing IDs
        }

        addData(
          id: id,
          selectedOpt: questionList[i].selectedOption == null
              ? 'unattempted'
              : questionList[i].selectedOption ?? '',
          timeTaken: timeTaken, // Use the correct timeTaken value
        );

        addedIds.add(id); // Store the added ID
      }
    }

    log("final res:$resuLT");

    if (currentSubjectId.value == 1) {
    } else if (currentSubjectId.value == 2) {
    } else {
      log("Gotit..................................");
      currentSubjectId.value = 5;
    }

    final resp = await examRepo.sumbitPracticeTestAnswers(
        practiceTestId: testId.value,
        studentId: studentId.value,
        subjectId: currentSubjectId.value,
        testLevel: level,
        totalTimeTaken: secondsLeft.value,
        questions: resuLT);

    resp.fold((l) {
      examReportState.value =
          Failed(e: 'Exam Report Creation Failed, Try again');
    }, (r) async {
      int? rank = r['rank'];
      int? score = r['score'];

      double? scorepercentage = r['score_percentage'];

      examReportState.value = Success(
        data: ExamReport(
            rank: rank,
            score: score,
            timeTaken: r["total_time_taken"],
            percentage: scorepercentage),
      );
    });
  }

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
            (q) => (q.answer != q.selectedOption && q.selectedOption != null))
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
    int count = 0;
    for (int i = 0; i < questionList.length; i++) {
      if (questionList[i].selectedOption == null) {
        count++;
      }
    }
    log("skipped count:$count");
    skippedValue.value = count;
    update();
  }

  @override
  void onClose() {
    // Ensure we cancel the timer if the controller is disposed
    log("disposed.......");
    _avgTimer?.cancel();
    _timer?.cancel();
    stopTimer();
    startAvgTimer();
    super.onClose();
  }
}
