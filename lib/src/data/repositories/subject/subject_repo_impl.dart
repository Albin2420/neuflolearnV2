import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/domain/repositories/subject/subject_repo.dart';

class SubjectRepoImpl implements SubjectRepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchSubjects() async {
    try {
      if (kDebugMode) {
        log("fetchSubjects()");
      }
      final response = await http.get(
        Uri.parse("${Url.baseUrl2}/videos-by-chapter"),
      );

      dynamic result = handleResponse(response);

      if (result is Failure) {
        return Left(Failure(message: 'failed'));
      }

      List<dynamic> physics = result['Physics'] ?? [];
      List<dynamic> chemistry = result['Chemistry'] ?? [];
      List<dynamic> biology = result['Biology'] ?? [];

      // log("PHYSICS: $physics");
      // log("CHEMISTRY: $chemistry");
      // log("BIOLOGY: $biology");

      return Right({
        "Physics": physics,
        "Chemistry": chemistry,
        "Biology": biology,
      });
    } catch (e) {
      log("Error fetching subjects: $e");
      throw Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchLive() async {
    try {
      final response = await http.get(
        Uri.parse("${Url.baseUrl2}/live-streaming"),
      );

      dynamic result = handleResponse(response);

      if (result is Failure) {
        return Left(Failure(message: 'failed'));
      }

      log("result of fetchLive():$result");

      return Right({"livevideos": result});
    } catch (e) {
      log("Error fetching live(): $e");
      throw Left(Failure(message: e.toString()));
    }
  }
}
