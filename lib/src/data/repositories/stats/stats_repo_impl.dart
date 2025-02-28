import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/domain/repositories/stats/stats_repo.dart';

class StatsRepoImpl extends StatsRepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchStatus(
      {required String accessToken}) async {
    try {
      if (kDebugMode) {
        log("initializing in fetchStatus()");
        log("${Url.baseUrl}/${Url.weeklystats}");
      }

      final response = await http.get(
          Uri.parse('${Url.baseUrl}/${Url.weeklystats}'),
          headers: {"Authorization": "Bearer $accessToken"});

      dynamic result = handleResponse(response);

      log("response in fetchStatus():${response.statusCode}");

      if (result is Failure) {
        return Left(result);
      }

      final practiceTestStats =
          result["practice_test_stats"] as Map<String, dynamic>? ?? {};
      final mockTestStats =
          result["mock_test_stats"] as Map<String, dynamic>? ?? {};
      final chapterStats =
          result["chapter_stats"] as Map<String, dynamic>? ?? {};

      // Organizing stats into maps
      final practiceStatsMap = {
        "total_tests_attended": practiceTestStats["total_tests_attended"],
        "total_time_spent": practiceTestStats["total_time_spent"],
        "total_time_per_dayMap": practiceTestStats["total_time_per_day"],
        "daily_average_timeMap": practiceTestStats["daily_average_time"],
        "daily_average_scoreMap": practiceTestStats["daily_average_score"],
        "subjectwise_correct_percentage":
            practiceTestStats["subjectwise_correct_percentage"],
        "subjectwise_incorrect_percentage":
            practiceTestStats["subjectwise_incorrect_percentage"],
        "average_score": practiceTestStats["average_score"],
        "average_time": practiceTestStats["average_time"],
      };

      final mockStatsMap = {
        "total_tests_attended": mockTestStats["total_tests_attended"],
        "total_time_spent": mockTestStats["total_time_spent"],
        "total_time_per_dayMap": mockTestStats["total_time_per_day"],
        "daily_average_timeMap": mockTestStats["daily_average_time"],
        "daily_average_scoreMap": mockTestStats["daily_average_score"],
        "subjectwise_correct_percentage":
            mockTestStats["subjectwise_correct_percentage"],
        "subjectwise_incorrect_percentage":
            mockTestStats["subjectwise_incorrect_percentage"],
        "average_score": mockTestStats["average_score"],
        "average_time": mockTestStats["average_time"],
      };

      final chapterWiseStatsMap = chapterStats.map((subject, chapters) {
        return MapEntry(
            subject,
            (chapters as Map<String, dynamic>).map((chapter, stats) {
              return MapEntry(chapter, {
                "correct_percentage": stats["correct_percentage"],
                "incorrect_percentage": stats["incorrect_percentage"],
                "total_questions": stats["total_questions"],
              });
            }));
      });
      return Right(({
        "message": result["message"],
        "practice_test_stats": practiceStatsMap,
        "mock_test_stats": mockStatsMap,
        "chapter_stats": chapterWiseStatsMap,
      }));
    } catch (e) {
      log("Error in fetchStatus():$e");
      return Left(Failure(message: e.toString()));
    }
  }
}
