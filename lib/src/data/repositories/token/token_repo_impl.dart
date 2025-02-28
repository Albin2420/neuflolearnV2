import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';

class TokenRepoImpl extends TokenRepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> getToken(
      {required int studentId, required String phoneNumber}) async {
    try {
      if (kDebugMode) {
        log("getToken()");
        log('${Url.baseUrl}/${Url.getToken}');
        log(
          "studentId:$studentId phoneNumber: $phoneNumber in getToken() ",
        );
      }
      final response = await http.post(
        Uri.parse('${Url.baseUrl}/${Url.getToken}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "student_id": studentId,
          "phone_number": phoneNumber,
        }),
      );

      log("body:${response.body}");
      log("statuscode:${response.statusCode}");

      if (response.statusCode == 200) {
        dynamic result = handleResponse(response);
        return Right({
          "access_token": result["access_token"],
          "refresh_token": result["refresh_token"]
        });
      } else {
        log("respstatuscode:${response.statusCode}");
        return Left(Failure(message: '${response.statusCode}'));
      }
    } catch (e) {
      log("Error in getToken():$e");
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getNewTokens({
    required String refreshToken,
  }) async {
    try {
      if (kDebugMode) {
        log("getNewTokens()");
        log("refreshToken:$refreshToken");
      }
      final response = await http.post(
        Uri.parse("${Url.baseUrl}/${Url.refreshToken}"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "refresh_token": refreshToken,
        }),
      );

      log("body in getNewTokens():${response.body}");

      if (response.statusCode == 200) {
        dynamic result = handleResponse(response);
        return Right({
          "access_token": result["access_token"],
          "refresh_token": result["refresh_token"]
        });
      } else {
        return Left(Failure(message: '${response.statusCode}'));
      }
    } catch (e) {
      log("Error in getNewTokens():$e");
      return Left(Failure(message: e.toString()));
    }
  }
}
