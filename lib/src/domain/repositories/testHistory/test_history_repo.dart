import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';

abstract class TestHistoryRepo {
  Future<Either<Failure, Map<String, dynamic>>> fetchTestHistorys({
    required String accessToken,
  });

  Future<Either<Failure, Map<String, dynamic>>> fetchTestDetails({
    required int testId,
    required String accestoken,
    required String testName,
  });
}
