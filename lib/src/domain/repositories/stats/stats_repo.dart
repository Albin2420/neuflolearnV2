import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';

abstract class StatsRepo {
  Future<Either<Failure, Map<String, dynamic>>> weeklystats({
    required String accessToken,
  });
}
