import 'package:dartz/dartz.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';

abstract class ChapterRepo {
  Future<Either<Failure, List<Chapter>>> fetchChapters({
    required int subjectId,
  });
}
