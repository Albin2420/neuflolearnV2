import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/domain/repositories/profile/profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchweekGrowth(
      {required String accestoken}) async {
    try {
      final url = Uri.parse('${Url.baseUrl}/${Url.timepercentage}');
      if (kDebugMode) {
        log("fetchweekGrowth()");
        log("${Url.baseUrl}/${Url.timepercentage}");
      }
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $accestoken"});

      log("status code in fetchweekGrowth():${response.statusCode}");

      dynamic result = handleResponse(response);
      if (result is Failure) {
        return Left(result);
      }
      return Right({
        "time": result["total_time_spent"],
        "physics": result["subject_wise_time_percentage"]["Physics"] ?? 0,
        "chemistry": result["subject_wise_time_percentage"]["Chemistry"] ?? 0,
        "Biology": result["subject_wise_time_percentage"]["Biology"] ?? 0,
      });
    } catch (e) {
      log("Error in fetchweekGrowth():$e");
      return Left(Failure(message: e.toString()));
    }
  }
}
