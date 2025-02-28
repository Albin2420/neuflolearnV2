import 'package:dartz/dartz.dart';

import '../../../core/network/failure.dart';

abstract class ProfileRepo {
  Future<Either<Failure, Map<String, dynamic>>> fetchweekGrowth(
      {required String accestoken});
}
