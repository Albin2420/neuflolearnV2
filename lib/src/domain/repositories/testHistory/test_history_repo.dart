import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';

abstract class TestHistoryRepo {
  Future<Either<Failure, Map<String, dynamic>>> fetchTestHistorys(
      {required int studentId});

  Future<Either<Failure, Map<String, dynamic>>> fetchTestDetails(
      {required int testId, required int studentId, required String testName});
}
