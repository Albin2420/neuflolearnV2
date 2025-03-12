import 'dart:developer';

import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/exam_record.dart';
import 'package:neuflo_learn/src/data/models/testHistoryModel/qstnhistoryresult.dart';
import 'package:neuflo_learn/src/data/repositories/testHistory/test_history_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/domain/repositories/testHistory/test_history_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/test_history_result.dart';

class TestHistoryController extends GetxController {
  final appctr = Get.find<AppStartupController>();
  TestHistoryRepo tstRepo = TestHistoryRepoImpl();
  TokenRepo trp = TokenRepoImpl();
  List<String> filters = [
    "All",
    "Mock Test",
    "Custom Test",
    "Biology",
    "Chemistry",
    "Physics"
  ].obs;
  RxInt selectedFilter = RxInt(0);
  RxList<ExamRecord> testHistorys = RxList();
  RxList<ExamRecord> mockTest = RxList();
  RxList<ExamRecord> customTest = RxList();
  RxList<ExamRecord> physics = RxList();
  RxList<ExamRecord> chemistry = RxList();
  RxList<ExamRecord> biology = RxList();

  Rx<Ds> state = Rx(Initial());
  RxString sub = RxString("");

  RxInt timetaken = RxInt(-1);
  RxInt score = RxInt(-1);
  RxInt rAnK = RxInt(-1);
  RxInt correct = RxInt(-1);
  RxInt incorrect = RxInt(-1);
  RxInt unAttempted = RxInt(-1);
  RxInt percentage = RxInt(-1);
  RxInt totalAttended = RxInt(-1);

  RxList<QstnHistoryModel> qstnsAll = RxList();
  RxList<QstnHistoryModel> skipped = RxList();
  RxList<QstnHistoryModel> correctfiltered = RxList();
  RxList<QstnHistoryModel> incorrectfiltered = RxList();

  RxString filterStatus = RxString('All');
  RxInt filterindex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    fetch();
    selectedFilter.value = Get.arguments ?? 0;
  }

  Future<void> fetch() async {
    final result = await tstRepo.fetchTestHistorys(
        accessToken: await appctr.getAccessToken() ?? '');
    result.fold((l) async {
      log("failed in fetchHistory()");

      if (l.message == "user is not authorised") {
        log("user is not authorised");
        final tokens = await trp.getNewTokens(
            refreshToken: await appctr.getRefreshToken() ?? "");
        tokens.fold((l) {
          log("token failed in fetchHistory()");
        }, (R) {
          appctr.saveToken(
              accessToken: R["access_token"], refreshToken: R["refresh_token"]);
          fetch();
        });
      } else {
        state.value = Failed();
      }
    }, (r) {
      testHistorys.value = r['mockTests'] +
          r['customTests'] +
          r['physics'] +
          r['chemistry'] +
          r['biology']; // add physics,chemistry,biology

      physics.value = r['physics'];
      chemistry.value = r['chemistry'];
      biology.value = r['biology'];
      mockTest.value = r['mockTests'];
      customTest.value = r['customTests'];
    });
  }

  Future<void> fetchDetailedHistory(
      {required int testId, required String testName}) async {
    log("test Id:$testId");
    final result = await tstRepo.fetchTestDetails(
        testId: testId,
        accestoken: await appctr.getAccessToken() ?? '',
        testName: testName);

    result.fold((l) async {
      if (l.message == "user is not authorised") {
        final tokens = await trp.getNewTokens(
            refreshToken: await appctr.getRefreshToken() ?? "");
        tokens.fold((l) {
          log("token failed in fetchDetailedHistory()");
        }, (r) {
          appctr.saveToken(
              accessToken: r["access_token"], refreshToken: r["refresh_token"]);
          fetchDetailedHistory(testId: testId, testName: testName);
        });
      } else {
        state.value = Failed();
      }
    }, (r) async {
      try {
        log("detailed test history :${r['']}");
        Get.to(() => TestHistoryResult());

        totalAttended.value = r['totalAttended'] ?? 0;
        correct.value = r['correct'] ?? 0;
        incorrect.value = r['incorrect'] ?? 0;
        unAttempted.value = r['unAttempted'] ?? 0;
        qstnsAll.value = r['qstns'];
        sub.value = r['test_name'];
        percentage.value = r["percentage"] ?? 0;

        score.value = r['score']; //done

        filter();

        state.value = Success(data: r);
      } catch (e) {
        log("error:$e");
        state.value = Failed();
      }
    });
  }

  void filter() {
    try {
      // correctfiltered.value = qstnsAll
      //     .where((q) => q.submittedAnswer == (q.answer)?.toUpperCase())
      //     .toList();
      // incorrectfiltered.value = qstnsAll
      //     .where((q) =>
      //         q.submittedAnswer != (q.answer)?.toUpperCase() &&
      //         q.submittedAnswer != "UNATTEMPTED")
      //     .toList();
      // skipped.value =
      //     qstnsAll.where((q) => q.submittedAnswer == "UNATTEMPTED").toList();

      correctfiltered.value = qstnsAll
          .where((q) =>
              q.submittedAnswer?.trim().toLowerCase() ==
              q.answer?.trim().toLowerCase())
          .toList();

      incorrectfiltered.value = qstnsAll
          .where((q) =>
              q.submittedAnswer?.trim().toLowerCase() !=
                  q.answer?.trim().toLowerCase() &&
              q.submittedAnswer?.trim().toLowerCase() != "unattempted")
          .toList();

      skipped.value = qstnsAll
          .where(
              (q) => q.submittedAnswer?.trim().toLowerCase() == "unattempted")
          .toList();
    } catch (e) {
      log("Error:$e");
    }
  }

  void selectFilter(int index) {
    selectedFilter.value = index;
    log("selectedFilter value:${selectedFilter.value}");
  }

  void filterAll({required int index}) {
    filterStatus.value = "All";
    filterindex.value = index;
  }

  void filterCorrect({required int index}) {
    filterStatus.value = "Correct";
    filterindex.value = index;
  }

  void filterInCorrect({required int index}) {
    filterStatus.value = "Incorrect";
    filterindex.value = index;
  }

  void filterSkipped({required int index}) {
    filterStatus.value = "Skipped";
    filterindex.value = index;
  }
}
