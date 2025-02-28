import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/models/student.dart';
import 'package:neuflo_learn/src/data/services/data_access/api_service.dart';
import 'package:neuflo_learn/src/domain/repositories/user/user_repo.dart';

class UserRepoImpl extends UserRepo {
  ApiService apiService = ApiService();
  @override
  Future<Either<Failure, Student>> saveStudent(
      {required Student student}) async {
    try {
      if (kDebugMode) {
        log('${Url.baseUrl}/${Url.studentProfile}');
        log({
          "student_id": student.studentId,
          "mail_id": student.mailId,
          "name": student.name,
          "phone_number": student.phoneNumber,
          "organization": 1,
          "is_active": true
        }.toString());
      }
      final response = await apiService.post(
        url: '${Url.baseUrl}/${Url.studentProfile}',
        headers: {
          "Content-Type": "application/json",
        },
        data: json.encode({
          "student_id": student.studentId,
          "mail_id": student.mailId,
          "name": student.name,
          "phone_number": student.phoneNumber,
          "organization": 1,
          "is_active": true,
          "token_version": 0,
          "current_identfier": "",
        }),
      );

      dynamic result = handleResponse(response);
      log("status code for saveStudent():${response.statusCode}");

      if (result is Failure) {
        return Left(result);
      }

      log("result =>: $result");
      return Right(Student.fromJson(result));
    } on FormatException catch (e) {
      debugPrint('exception : $e');
      return const Left(
        Failure(message: 'Format Exception'),
      );
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
      return const Left(
        Failure(message: 'Unknown error, Try again later'),
      );
    }
  }
}
