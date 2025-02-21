import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/data/models/student.dart';

abstract class UserRepo {
  Future<Either<Failure, Student>> saveStudent({required Student student});
}
