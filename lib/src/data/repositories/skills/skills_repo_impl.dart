import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/services/data_access/api_service.dart';
import 'package:neuflo_learn/src/domain/repositories/skills/skills_repo.dart';

class SkillsRepoImpl extends SkillsRepo {
  ApiService apiService = ApiService();
  @override
  Future saveSkills({required Map<String, dynamic> data}) async {
    if (kDebugMode) {
      log('${Url.baseUrl1}/${Url.saveSkill}');
      log("data:$data");
    }
    try {
      final response = await apiService.post(
        url: '${Url.baseUrl1}/${Url.saveSkill}',
        headers: {"Content-Type": "application/json"},
        data: json.encode(data),
      );

      log('response : ${(response as Response).statusCode}');
      dynamic result = handleResponse(response);

      log("passed data:$data");

      if (result is Failure) {
        return Left(result);
      }

      return Right('success');
    } on FormatException catch (e) {
      debugPrint('exception : $e');
      return const Left(Failure(message: 'Format Exception'));
    } on SocketException catch (e) {
      debugPrint('exception : $e');
      return const Left(
        Failure(
          code: ResponseCode.NO_INTERNET_CONNECTION,
          message: ResponseMessage.NO_INTERNET_CONNECTION,
        ),
      );
    } on Exception catch (e) {
      debugPrint('exception : $e');
      return const Left(Failure(message: 'Unknown error, Try again later'));
    }
  }
}
