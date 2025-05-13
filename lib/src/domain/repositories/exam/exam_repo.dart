import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/data/models/exam_report.dart';

abstract class ExamRepo {
  Future<Either<Failure, bool>> checkTestCompletion({
    required String studentId,
    required String instanceId,
  });

  // Future<Either<Failure, TestCompletionData>> getPracticeTestDetails(
  //     {required String studentId, required String instanceId});

  Future<Either<Failure, int>> generatePracticeTestId({
    required String studentId,
  });

  Future<Either<Failure, int>> getQuestionIds({
    required int studentId,
    required int instanceId,
  });

  Future<Either<Failure, Map<String, dynamic>>> getPracticeTestQuestions({
    required int studentId,
    required String subjectName,
    required String testlevel,
    required String accessToken,
  }); //v2

  Future<Either<Failure, Map<String, dynamic>>> getmockTestQuestions({
    required int studentId,
    required String accesstoken,
  }); //v2

  Future<Either<Failure, Map<String, dynamic>>> getCustomTestQuestions({
    required String accesstoken,
    required int studentId,
    required List physicsChapters,
    required List chemistryChapters,
    required List biologyChapters,
    required int noOfQuestions,
  });

  Future<Either<Failure, Map<String, dynamic>>> sumbitPracticeTestAnswers(
      {required final String accessToken,
      required int totalquestions,
      required int totalAttended,
      required int correctAnswer,
      required int incorrectAnswer,
      required int skippedAnswer,
      required int unattemptedAnswer,
      required int practiceTestId,
      required int subjectId,
      required String testLevel,
      required int totalTimeTaken,
      required List<dynamic> detailedAnswers,
      required String subjectName,
      required Map<String, String> questionIdTime}); //v2

  Future<Either<Failure, ExamReport>> getPracticeTestResultsSubjectwise({
    required int studentId,
    required int instanceId,
    required int subjectTestId,
  });

  Future<Either<Failure, Map<String, dynamic>>> submitMockTestAnswers({
    required String accessToken,
    required int mockTestId,
    required int totalAttended,
    required int correctNumber,
    required int incorrectNumber,
    required int totalTimeTaken,
    required int skippedcount,
    required int unattempted,
    required int totalquestionCount,
    required Map<String, String> physicsAnswers,
    required Map<String, String> chemistryAnswers,
    required Map<String, String> biologyAnswers,
    required List<dynamic> detailedAnswers,
  });

  Future<Either<Failure, Map<String, dynamic>>> submitCustomTestAnswers({
    required String accesstoken,
    required int customTestId,
    required int totaltimeTaken,
    required int totalquestions,
    required int totalAttended,
    required int correctAnswer,
    required int incorrectanswers,
    required int skippedAnswer,
    required int unattemptedAnswers,
    required Map<String, String> physicsAnswers,
    required Map<String, String> chemistryAnswers,
    required Map<String, String> biologyAnswers,
    required List<dynamic> detailedAnswers,
  });
}
