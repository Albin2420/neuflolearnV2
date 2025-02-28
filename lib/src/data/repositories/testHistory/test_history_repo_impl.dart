import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/models/exam_record.dart';
import 'package:neuflo_learn/src/data/models/testHistoryModel/qstnhistoryresult.dart';
import 'package:neuflo_learn/src/domain/repositories/testHistory/test_history_repo.dart';

class TestHistoryRepoImpl extends TestHistoryRepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchTestHistorys(
      {required String accessToken}) async {
    try {
      if (kDebugMode) {
        log("${Url.baseUrl}/${Url.studentTestHistory}");
      }
      final response = await http.get(
          Uri.parse('${Url.baseUrl}/${Url.studentTestHistory}'),
          headers: {"Authorization": "Bearer $accessToken"});
      log("body:${response.body}");

      dynamic result = handleResponse(response);

      log("res:${response.statusCode}");
      log("body:${result["practice_tests"]}");

      final data = handleResponse(response);
      List<ExamRecord> physics = [];
      List<ExamRecord> chemistry = [];
      List<ExamRecord> biology = [];

      // Parse mock tests
      List<ExamRecord> mockTests = (data['mock_tests'] as List)
          .map((e) => ExamRecord.fromJson(e))
          .toList();

      // Parse custom tests
      List<ExamRecord> customTests = (data['custom_tests'] as List)
          .map((e) => ExamRecord.fromJson(e))
          .toList();

      physics = (result["practice_tests"]['physics'] as List)
          .map((e) => ExamRecord.fromJson(e))
          .toList();

      chemistry = (result["practice_tests"]['chemistry'] as List)
          .map((e) => ExamRecord.fromJson(e))
          .toList();

      biology = (result["practice_tests"]['biology'] as List)
          .map((e) => ExamRecord.fromJson(e))
          .toList();

      log("Parsed Mock Tests: $mockTests");
      log("Parsed Custom Tests: $customTests");

      // log("Parsed Practice Tests: $practiceTests");

      return Right({
        "mockTests": mockTests,
        "customTests": customTests,
        "physics": physics,
        "chemistry": chemistry,
        "biology": biology
      });
    } catch (e) {
      log("Error :$e");
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchTestDetails(
      {required int testId,
      required String accestoken,
      required String testName}) async {
    try {
      if (kDebugMode) {
        log('${Url.baseUrl}/${Url.detailstudentTestHistory}?test_id=$testId&test_name=$testName');
      }
      final response = await http.get(
          Uri.parse(
              '${Url.baseUrl}/${Url.detailstudentTestHistory}?test_id=$testId&test_name=$testName'),
          headers: {"Authorization": "Bearer $accestoken"});

      log("response:${response.statusCode}");

      dynamic result = handleResponse(response);
      log("result:$result");

      if (result is Failure) {
        return Left(result);
      }

      List<QstnHistoryModel> qstns = (result["questions"] as List)
          .map((e) => QstnHistoryModel.fromJson(e))
          .toList();

      return Right({
        "test_name": result["test_name"],
        "score": result["score"],
        "totalAttended": result["total_attended"],
        "averageTime": result["test_average_time"],
        "correct": result["correct_number"],
        "incorrect": result["incorrect_number"],
        "unAttempted": result["unattempted"],
        "qstns": qstns
      });
    } catch (e) {
      log("Error:$e");
      return Left(Failure(message: e.toString()));
    }
  }
}
