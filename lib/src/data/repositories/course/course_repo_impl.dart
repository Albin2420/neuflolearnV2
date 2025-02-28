import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/models/course.dart';
import 'package:neuflo_learn/src/data/services/data_access/api_service.dart';
import 'package:neuflo_learn/src/domain/repositories/course/course_repo.dart';

class CourseRepoImpl extends CourseRepo {
  ApiService apiService = ApiService();

  @override
  Future<Either<Failure, List<Course>>> getCourses() async {
    if (kDebugMode) {
      log("getCoursesImpl()");
      log('${Url.baseUrl}/${Url.courses}');
    }
    try {
      final response =
          await apiService.get(url: '${Url.baseUrl}/${Url.courses}');
      dynamic result = handleResponse(response);

      log("result : $response");

      if (result is Failure) {
        return Left(result);
      }
      List<Course> courseList =
          (result as List<dynamic>).map((e) => Course.fromJson(e)).toList();

      return Right(courseList);
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

  @override
  Future<Either<Failure, List<Course>>> setSkillLevels() async {
    try {
      final response =
          await apiService.get(url: '${Url.baseUrl}/${Url.setSkillLevels}');
      dynamic result = handleResponse(response);
      List<Course> courseList =
          (result as List<dynamic>).map((e) => Course.fromJson(e)).toList();

      return Right(courseList);
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
