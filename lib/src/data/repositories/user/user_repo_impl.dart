// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:neuflo_learn/src/core/network/error_handler.dart';
// import 'package:neuflo_learn/src/core/network/failure.dart';
// import 'package:neuflo_learn/src/core/url.dart';
// import 'package:neuflo_learn/src/data/models/student.dart';
// import 'package:neuflo_learn/src/data/services/data_access/api_service.dart';
// import 'package:neuflo_learn/src/domain/repositories/user/user_repo.dart';

// class UserRepoImpl extends UserRepo {
//   ApiService apiService = ApiService();
//   @override
//   Future<Either<Failure, Student>> saveStudent({
//     required Student student,
//   }) async {
//     try {
//       if (kDebugMode) {
//         log('${Url.baseUrl1}/${Url.studentProfile}/');
//         log(
//           {
//             "student_id": student.studentId,
//             "mail_id": student.mailId,
//             "name": student.name,
//             "phone_number": student.phoneNumber,
//             "is_active": true,
//           }.toString(),
//         );
//       }
//       final response = await apiService.post(
//         url: '${Url.baseUrl1}/${Url.studentProfile}/',
//         headers: {"Content-Type": "application/json"},
//         data: json.encode({
//           "student_id": student.studentId,
//           "mail_id": student.mailId,
//           "name": student.name,
//           "phone_number": student.phoneNumber,
//           "is_active": true,
//           "token_version": 0,
//           "current_identifier": "",
//         }),
//       );

//       dynamic result = handleResponse(response);

//       log("status code for saveStudent():${response.statusCode}");

//       if (result is Failure) {
//         dynamic t1 = jsonDecode(response.body);
//         return Left(Failure(message: t1['detail']));
//       }

//       log("result of Savestudent =>: $result");
//       return Right(Student.fromJson(result));
//     } on FormatException catch (e) {
//       debugPrint('exception : $e');
//       return const Left(Failure(message: 'Format Exception'));
//     } on SocketException catch (e) {
//       debugPrint('exception : $e');
//       return const Left(
//         Failure(
//           code: ResponseCode.NO_INTERNET_CONNECTION,
//           message: ResponseMessage.NO_INTERNET_CONNECTION,
//         ),
//       );
//     } on Exception catch (e) {
//       debugPrint('exception : $e');
//       return const Left(Failure(message: 'Unknown error, Try again later'));
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:neuflo_learn/src/core/network/error_handler.dart';
// import 'package:neuflo_learn/src/core/network/failure.dart';
// import 'package:neuflo_learn/src/core/url.dart';
// import 'package:neuflo_learn/src/data/models/student.dart';
// import 'package:neuflo_learn/src/data/services/data_access/api_service.dart';
// import 'package:neuflo_learn/src/domain/repositories/user/user_repo.dart';

// class UserRepoImpl extends UserRepo {
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> saveStudent(
//       {required Student student}) async {
//     try {
//       final response = await apiService.post(
//         url: '${Url.baseUrl1}/${Url.studentProfile}/',
//         headers: {
//           "Content-Type": "application/json",
//         },
//         data: json.encode({
//           "phone_number": student.phoneNumber,
//           "token_version": 0,
//           "current_identifier": "",
//           "mail_id": student.mailId,
//           "name": student.name,
//           "academy": "organisation1",
//           "is_active": false
//         }),
//       );

//       dynamic result = handleResponse(response);
//       log("result of Savestudent =>: ${response.body}");

//       log("status code for saveStudent():${response.statusCode}");

//       if (result is Failure) {
//         dynamic t1 = jsonDecode(response.body);
//         log("t1detail:${t1['detail']}");
//         return Left(Failure(message: t1['detail']));
//       }

//       // log("result of Savestudent =>: $result");
//       return Right(Student.fromJson(result));
//     } on FormatException catch (e) {
//       debugPrint('exception : $e');
//       return const Left(
//         Failure(message: 'Format Exception'),
//       );
//     } on SocketException catch (e) {
//       debugPrint('exception : $e');
//       return const Left(
//         Failure(
//           code: ResponseCode.NO_INTERNET_CONNECTION,
//           message: ResponseMessage.NO_INTERNET_CONNECTION,
//         ),
//       );
//     } on Exception catch (e) {
//       debugPrint('exception : $e');
//       return const Left(
//         Failure(message: 'Unknown error, Try again later'),
//       );
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/models/student.dart';
import 'package:neuflo_learn/src/domain/repositories/user/user_repo.dart';

class UserRepoImpl extends UserRepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> saveStudent({
    required Student student,
    required String fcmToken,
  }) async {
    final uri = Uri.parse('${Url.baseUrl1}/${Url.studentProfile}/');

    final requestBody = json.encode({
      "phone_number": student.phoneNumber,
      "token_version": 0,
      "current_identifier": "",
      "mail_id": student.mailId,
      "name": student.name,
      "academy": "organisation1",
      "is_active": false,
      "fcm_token": fcmToken,
    });

    if (kDebugMode) {
      log('POST $uri');
      log('Request body: $requestBody');
    }

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (kDebugMode) {
        log("SaveStudent status code: ${response.statusCode}");
        log("SaveStudent response body: ${response.body}");
      }

      final result = handleResponse(response);

      if (result is Failure) {
        return Left(result);
      }

      return Right({
        "status_code": result['status_code'],
        "student_id": result['student_id'],
        "organization": result['organization'],
      });
    } on FormatException catch (e) {
      debugPrint('FormatException: $e');
      return const Left(Failure(message: 'Format Exception'));
    } on SocketException catch (e) {
      debugPrint('SocketException: $e');
      return const Left(
        Failure(
          code: ResponseCode.NO_INTERNET_CONNECTION,
          message: ResponseMessage.NO_INTERNET_CONNECTION,
        ),
      );
    } on Exception catch (e) {
      debugPrint('Unknown Exception: $e');
      return const Left(Failure(message: 'Unknown error, Try again later'));
    }
  }
}
