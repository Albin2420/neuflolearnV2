import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/models/exam_report.dart';
import 'package:neuflo_learn/src/data/models/question.dart';
import 'package:neuflo_learn/src/data/services/data_access/api_service.dart';
import 'package:neuflo_learn/src/domain/repositories/exam/exam_repo.dart';

class ExamRepoImpl extends ExamRepo {
  ApiService apiService = ApiService();
  @override
  Future<Either<Failure, bool>> checkTestCompletion({
    required String studentId,
    required String instanceId,
  }) async {
    if (kDebugMode) {
      log('${Url.baseUrl}/${Url.checkTestCompletion}');
    }
    try {
      final response = await apiService.get(
        url:
            '${Url.baseUrl}/${Url.checkTestCompletion}?instanceId=$instanceId&studentId=$studentId',
      );

      dynamic result = handleResponse(response);
      if (result is Failure) {
        return Left(result);
      }
      log('result => $result');
      log('checkTestCompletion of instanceId $instanceId  : ${result["completion_status"]["is_completed"]}');
      return Right(result["completion_status"]["is_completed"]);
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

  // @override
  // Future<Either<Failure, TestCompletionData>> getPracticeTestDetails({
  //   required String studentId,
  //   required String instanceId,
  // }) async {
  //   if (kDebugMode) {
  //     log('${Url.baseUrl}/${Url.getPracticeTestDetails}');
  //   }
  //   try {
  //     final response = await apiService.post(
  //       headers: {'Content-Type': 'application/json'},
  //       url: '${Url.baseUrl}/${Url.getPracticeTestDetails}',
  //       data: json.encode(
  //         {
  //           "instance_id": instanceId,
  //           "student_id": studentId,
  //         },
  //       ),
  //     );
  //     dynamic result = handleResponse(response);

  //     log("result : ===== $result");

  //     if (result is Failure) {
  //       return Right(
  //         TestCompletionData(
  //           physicsCounter: 0,
  //           chemistryCounter: 0,
  //           biologyCounter: 0,
  //           phy: TestCompletionResult(),
  //           che: TestCompletionResult(),
  //           bio: TestCompletionResult(),
  //         ),
  //       );
  //     }

  //     int physicsCounter = 0;
  //     int chemistryCounter = 0;
  //     int biologyCounter = 0;

  //     List items = (result["details"] as List<dynamic>);

  //     TestCompletionResult? phyTestCompletionResult;
  //     TestCompletionResult? cheTestCompletionResult;
  //     TestCompletionResult? bioTestCompletionResult;

  //     for (int i = 0; i < items.length; i++) {
  //       if (kDebugMode) {
  //         // log("items[$i] : ${items[i]}");
  //       }
  //       Map data = items[i];
  //       if (data['subjectname'] == "Chemistry") {
  //         if (data["iscompleted"] == true) {
  //           chemistryCounter++;
  //         }
  //         cheTestCompletionResult = TestCompletionResult(
  //           subjectname: data['subjectname'],
  //           iscompleted: data["iscompleted"],
  //         );
  //       }

  //       if (data['subjectname'] == "Biology") {
  //         if (data["iscompleted"] == true) {
  //           biologyCounter++;
  //         }
  //         bioTestCompletionResult = TestCompletionResult(
  //           subjectname: data['subjectname'],
  //           iscompleted: data["iscompleted"],
  //         );
  //       }

  //       if (data['subjectname'] == "Physics") {
  //         if (data["iscompleted"] == true) {
  //           physicsCounter++;
  //         }
  //         phyTestCompletionResult = TestCompletionResult(
  //           subjectname: data['subjectname'],
  //           iscompleted: data["iscompleted"],
  //         );
  //       }
  //     }

  //     return Right(
  //       TestCompletionData(
  //         physicsCounter: physicsCounter,
  //         chemistryCounter: chemistryCounter,
  //         biologyCounter: biologyCounter,
  //         phy: phyTestCompletionResult ??
  //             TestCompletionResult(
  //               subjectname: "Physics",
  //               iscompleted: false,
  //             ),
  //         bio: bioTestCompletionResult ??
  //             TestCompletionResult(
  //               subjectname: "Chemistry",
  //               iscompleted: false,
  //             ),
  //         che: cheTestCompletionResult ??
  //             TestCompletionResult(
  //               subjectname: "Biology",
  //               iscompleted: false,
  //             ),
  //       ),
  //     );
  //   } on FormatException catch (e) {
  //     debugPrint('exception : $e');
  //     return const Left(
  //       Failure(message: 'Format Exception'),
  //     );
  //   } on SocketException catch (e) {
  //     debugPrint('exception : $e');
  //     return const Left(
  //       Failure(
  //         code: ResponseCode.NO_INTERNET_CONNECTION,
  //         message: ResponseMessage.NO_INTERNET_CONNECTION,
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     debugPrint('exception : $e');
  //     return const Left(
  //       Failure(message: 'Unknown error, Try again later'),
  //     );
  //   }
  // }

  @override
  Future<Either<Failure, int>> generatePracticeTestId(
      {required String studentId}) async {
    if (kDebugMode) {
      log('${Url.baseUrl}/${Url.generatePracticeTest}');
      log({
        'student_id': studentId,
      }.toString());
    }
    try {
      final response = await apiService.post(
        url: '${Url.baseUrl}/${Url.generatePracticeTest}',
        data: jsonEncode({
          'student_id': studentId,
        }),
        headers: {
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Content-Type': 'application/json'
        },
      );
      dynamic result = handleResponse(response);

      if (result is Failure) {
        return Left(result);
      }

      log("result =>: $result");

      return Right(result["testInstanceID"]);
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
  Future<Either<Failure, int>> getQuestionIds(
      {required int studentId, required int instanceId}) async {
    if (kDebugMode) {
      log('${Url.baseUrl}/${Url.getQuestionIds}?instanceId=$instanceId&studentId=$studentId');
    }
    try {
      final response = await apiService.get(
        url:
            '${Url.baseUrl}/${Url.getQuestionIds}?instanceId=$instanceId&studentId=$studentId',
      );

      dynamic result = handleResponse(response);

      log("IDS : $result");

      return Right(0);
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
  Future<Either<Failure, Map<String, dynamic>>> getPracticeTestQuestions({
    required int studentId,
    required String subjectName,
    required String testlevel,
    required String accessToken,
  }) async {
    if (kDebugMode) {
      log('${Url.baseUrl}/${Url.getPracticeTestQuestions}');
      log({
        "student_id:$studentId",
        "subject_name :$subjectName",
        "test_level :$testlevel"
      }.toString());
    }

    try {
      final https.Response response = await apiService.get(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        url:
            '${Url.baseUrl}/${Url.getPracticeTestQuestions}/?subject_name=$subjectName&test_level=$testlevel',
      );
      log("statusCode in getPracticeTestQuestions():${response.statusCode}");
      dynamic result = handleResponse(response);

      List<Question> questionList = [];

      if (result is Failure) {
        return Left(Failure(message: result.message));
      }

      if (result["questions"] == null) {
        questionList = [];
      } else {
        try {
          questionList = (result['questions'] as List<dynamic>)
              .map((e) => Question.fromJson(e))
              .toList();
        } catch (e) {
          log("Error in getPracticeTestQuestions():$e");
        }
      }

      return Right({
        "questions": questionList,
        "practiceTestID": result['practice_test_id'],
      });
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
  Future<Either<Failure, Map<String, dynamic>>> sumbitPracticeTestAnswers({
    required final String accessToken,
    required int practiceTestId,
    required int studentId,
    required int subjectId,
    required String testLevel,
    required int totalTimeTaken,
    required List<dynamic> questions,
  }) async {
    if (kDebugMode) {
      log("sumbitPracticeTestAnswers()");
      log("url:${Uri.parse('${Url.baseUrl}/${Url.submitPracticeTestAnswers}/')}");
      log({
        "practice_test_id": practiceTestId,
        "student_id": studentId,
        "subject_id": subjectId,
        "test_level": testLevel.toLowerCase(),
        "total_time_taken": totalTimeTaken,
        "questions": questions
      }.toString());
    }
    final url = Uri.parse('${Url.baseUrl}/${Url.submitPracticeTestAnswers}/');
    try {
      final response = await https.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            "practice_test_id": practiceTestId,
            // "student_id": studentId,
            "subject_id": subjectId,
            "test_level": testLevel.toLowerCase(),
            "total_time_taken": totalTimeTaken,
            "questions": questions
          }));

      dynamic result = handleResponse(response);

      log("response body :${response.body}");
      if (result is Failure) {
        return Left(Failure(message: result.message));
      }

      String? time = await convertSectoHourMinute(result["total_time_taken"]);

      return Right(({
        "score_percentage": result["score_percentage"],
        "total_time_taken": time,
        "score": result["score"],
        "rank": result["rank"]
      }));
    } catch (e) {
      log('error in sumbitPracticeTestAnswers():$e');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getmockTestQuestions(
      {required int studentId, required String accesstoken}) async {
    try {
      final url = Uri.parse('${Url.baseUrl}/${Url.generateMockTest}/');
      if (kDebugMode) {
        log("url:$url");
        log("studentId:$studentId");
      }
      final response = await https.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accesstoken',
        },
        body: jsonEncode({"student_id": studentId}),
      );

      dynamic result = handleResponse(response);

      if (result is Failure) {
        return Left(result);
      }

      if (response.statusCode == 200) {
        dynamic result = handleResponse(response);
        List<Question> physicsQuestions = [];
        List<Question> chemistryQuestions = [];
        List<Question> zoologyQuestions = [];
        List<Question> botanyQuestions = [];

        List<Question> finalQuestion = [];

        if (result.containsKey("questions")) {
          var questionsData = result["questions"];

          // Extract Physics Questions
          if (questionsData.containsKey("Physics")) {
            var physics = questionsData["Physics"];
            if (physics.containsKey("sectionA")) {
              physicsQuestions.addAll(
                (physics["sectionA"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
            if (physics.containsKey("sectionB")) {
              physicsQuestions.addAll(
                (physics["sectionB"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
          }

          // Extract Chemistry Questions
          if (questionsData.containsKey("Chemistry")) {
            var chemistry = questionsData["Chemistry"];
            if (chemistry.containsKey("sectionA")) {
              chemistryQuestions.addAll(
                (chemistry["sectionA"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
            if (chemistry.containsKey("sectionB")) {
              chemistryQuestions.addAll(
                (chemistry["sectionB"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
          }

          // Extract Botany Questions
          if (questionsData.containsKey("Botany")) {
            var botany = questionsData["Botany"];
            if (botany.containsKey("sectionA")) {
              botanyQuestions.addAll(
                (botany["sectionA"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
            if (botany.containsKey("sectionB")) {
              botanyQuestions.addAll(
                (botany["sectionB"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
          }

          // Extract Zoology Questions
          if (questionsData.containsKey("Zoology")) {
            var zoology = questionsData["Zoology"];
            if (zoology.containsKey("sectionA")) {
              zoologyQuestions.addAll(
                (zoology["sectionA"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
            if (zoology.containsKey("sectionB")) {
              zoologyQuestions.addAll(
                (zoology["sectionB"] as List)
                    .map((q) => Question.fromJson(q))
                    .toList(),
              );
            }
          }
        }

        finalQuestion = physicsQuestions +
            chemistryQuestions +
            botanyQuestions +
            zoologyQuestions;

        log("Physics Questions: ${physicsQuestions.length}");
        log("Chemistry Questions: ${chemistryQuestions.length}");
        log("Botany Questions: ${botanyQuestions.length}");
        log("Zoology Questions: ${zoologyQuestions.length}");

        log("final Questions: ${finalQuestion.length}");

        return Right({
          "mock_test_id": result['mock_test_id'],
          "questions": finalQuestion,
          "physicsIds": result["question_ids"]["Physics"],
          "chemistryIds": result["question_ids"]["Chemistry"],
          "BotanyIds": result["question_ids"]["Botany"],
          "ZoologyIds": result["question_ids"]["Zoology"]
        });
      }

      return left(Failure(message: response.statusCode.toString()));
    } catch (e) {
      log("Error in getmockTestQuestionsImpl():$e");
      return Left(Failure(message: 'failed'));
    }
  }

  @override
  Future<Either<Failure, ExamReport>> getPracticeTestResultsSubjectwise({
    required int studentId,
    required int instanceId,
    required int subjectTestId,
  }) async {
    if (kDebugMode) {
      log('${Url.baseUrl}/${Url.calculatePracticeTestResultsSubjectwise}');

      log({
        "student_id": studentId,
        "test_instance_id": instanceId,
        "subject_test_id": subjectTestId,
      }.toString());
    }
    try {
      final https.Response response = await apiService.post(
        url: '${Url.baseUrl}/${Url.calculatePracticeTestResultsSubjectwise}',
        headers: {'Content-Type': 'application/json'},
        data: json.encode({}),
      );

      dynamic result = handleResponse(response);

      if (result is Failure) {
        return Left(result);
      }

      ExamReport report = ExamReport.fromJson(result["details"]);

      return Right(report);
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
  Future<Either<Failure, Map<String, dynamic>>> getCustomTestQuestions({
    required String accesstoken,
    required int studentId,
    required List physicsChapters,
    required List chemistryChapters,
    required List biologyChapters,
    required int noOfQuestions,
  }) async {
    if (kDebugMode) {
      log('${Url.baseUrl}/${Url.generateCustomTest}');
    }
    try {
      final url = Uri.parse('${Url.baseUrl}/${Url.generateCustomTest}');
      if (kDebugMode) {
        log("url:$url  physicsChapter:$physicsChapters");
      }
      final response = await https.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accesstoken',
        },
        body: jsonEncode({
          "student_id": studentId,
          "subjectwise_chapter": {
            "1": physicsChapters,
            "2": chemistryChapters,
            "3": biologyChapters
          },
          "total_questions": noOfQuestions,
          "total_time": noOfQuestions,
          "organization_id": 1,
        }),
      );
      log("response:${response.body}");

      dynamic result = handleResponse(response);

      if (result is Failure) {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['detail'] ?? 'Unknown error occurred';
        log("Error Message:$errorMessage");
        return Left(Failure(message: ''));
      }

      log("response 1 go:${result["questions"][0]}");

      List<Question> questionList = [];

      questionList = (result["questions"] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList();

      return Right({
        "custom_test_id": result["custom_test_id"],
        "questions": questionList,
      });
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
    } catch (e) {
      log("Error in getCustomTestQuestions():$e");
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitMockTestAnswers({
    required String accessToken,
    required int mockTestId,
    required int studentId,
    required int totalAttended,
    required int correctNumber,
    required int incorrectNumber,
    required int totalTimeTaken,
    required List<dynamic> physicsAnswers,
    required List<dynamic> chemistryAnswers,
    required List<dynamic> biologyAnswers,
  }) async {
    try {
      final url = "${Url.baseUrl}/${Url.submitMockquestion}/";
      if (kDebugMode) {
        log('url:${Url.baseUrl}/${Url.submitMockquestion}/');
      }
      final response = await https.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(({
          "mock_test_id": mockTestId,
          "student_id": studentId,
          "total_attended": totalAttended,
          "correct_number": correctNumber,
          "incorrect_number": incorrectNumber,
          "answers": {
            "Physics": physicsAnswers,
            "Chemistry": chemistryAnswers,
            "Biology": biologyAnswers
          },
          "test_average_time": totalTimeTaken,
        })),
      );

      log("statusCode submitMockTest():${response.statusCode}");
      dynamic result = handleResponse(response);

      if (result is Failure) {
        return Left(Failure(message: result.message));
      }

      log("result of mocktest:$result");

      String? time =
          await convertSectoHourMinute(result["total_time_taken"]); //got it;

      return Right(({
        "score_percentage": result["score_percentage"],
        "total_time_taken": time,
        "score": result["score"],
        "rank": result["rank"]
      }));
    } catch (e) {
      log("Error in submitMockTest():$e");
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitCustomTestAnswers({
    required String accesstoken,
    required int studentId,
    required int customTestId,
    required int totalAttended,
    required int correctNumber,
    required int incorrectNumber,
    required int testAverageTime,
    required var answer,
    required var questionAvgTime,
  }) async {
    try {
      final url = "${Url.baseUrl}/${Url.submitCustomTest1}";
      if (kDebugMode) {
        log('url:${Url.baseUrl}/${Url.submitCustomTest1}');
        log(({
          "custom_id": customTestId,
          "student_id": studentId,
          "total_attended": totalAttended,
          "correct_number": correctNumber,
          "incorrect_number": incorrectNumber,
          "test_average_time": testAverageTime,
          "question_average_time": questionAvgTime,
          "answers": answer
        }).toString());
      }
      final response = await https.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accesstoken',
        },
        body: jsonEncode(({
          "custom_id": customTestId,
          "student_id": studentId,
          "total_attended": totalAttended,
          "correct_number": correctNumber,
          "incorrect_number": incorrectNumber,
          "test_average_time": testAverageTime,
          "question_average_time": questionAvgTime,
          "answers": answer
        })),
      );
      dynamic result = handleResponse(response);
      if (result is Failure) {
        return Left(Failure(message: result.message));
      }
      log("res:${response.statusCode}");
      log("result:${response.body}");
      String? time = await convertSectoHourMinute(result["total_time_taken"]);
      return Right({
        "score_percentage": result["score_percentage"],
        "total_time_taken": time,
        "score": result["score"],
        "rank": result["rank"]
      });
    } catch (e) {
      log("Error in submitCustomTestAnswersImpl():$e");
      return Left(Failure(message: e.toString()));
    }
  }

  ///casual function for time handling
  Future<String> convertSectoHourMinute(dynamic seconds) async {
    if (seconds == null) return "00:00";

    int totalSeconds = seconds is double
        ? seconds.toInt()
        : int.tryParse(seconds.toString()) ?? 0;
    int minutes = totalSeconds ~/ 60;
    int hours = minutes ~/ 60;
    minutes %= 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }
}
