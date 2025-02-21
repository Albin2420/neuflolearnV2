import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/data/models/course.dart';

abstract class CourseRepo {
  Future<Either<Failure, List<Course>>> getCourses();
  Future<Either<Failure, List<Course>>> setSkillLevels();
}
