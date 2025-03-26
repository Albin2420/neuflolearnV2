import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';

abstract class SubjectRepo {
  Future<Either<Failure, Map<String, dynamic>>> fetchSubjects();

  Future<Either<Failure, Map<String, dynamic>>> fetchLive();
}
