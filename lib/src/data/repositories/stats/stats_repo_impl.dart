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
      {required int studentId}) async {
    try {
      if (kDebugMode) {
        log("initializing in fetchStatus()");
        log("'${Url.baseUrl}/${Url.weeklystats}/$studentId'");
      }

      final response = await http
          .get(Uri.parse('${Url.baseUrl}/${Url.weeklystats}/$studentId'));

      dynamic result = handleResponse(response);
      if (response.statusCode == 200) {
        log("response in API:${response.body}");
        // Extracting stats
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
          "daily_average_time": practiceTestStats["daily_average_time"],
          "subjectwise_correct_percentage":
              practiceTestStats["subjectwise_correct_percentage"],
          "subjectwise_incorrect_percentage":
              practiceTestStats["subjectwise_incorrect_percentage"],
          "average_score": practiceTestStats["average_score"],
          "average_time_per_question":
              practiceTestStats["average_time_per_question"],
        };

        final mockStatsMap = {
          "total_mock_tests_attended":
              mockTestStats["total_mock_tests_attended"],
          "total_time_spent": mockTestStats["total_time_spent"],
          "daily_average_time": mockTestStats["daily_average_time"],
          "subjectwise_correct_percentage":
              mockTestStats["subjectwise_correct_percentage"],
          "subjectwise_incorrect_percentage":
              mockTestStats["subjectwise_incorrect_percentage"],
          "average_score": mockTestStats["average_score"],
          "average_time_per_question":
              mockTestStats["average_time_per_question"],
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
      } else {
        log("failed.....");
        return Left(Failure(message: response.statusCode.toString()));
      }
    } catch (e) {
      log("Error:$e");
      return Left(Failure(message: e.toString()));
    }
  }
}
