import 'package:dartz/dartz.dart';

import '../../../core/network/failure.dart';

abstract class TokenRepo {
  Future<Either<Failure, Map<String, dynamic>>> getToken(
      {required int studentId, required String phoneNumber});

  Future<Either<Failure, Map<String, dynamic>>> getNewTokens({
    required String refreshToken,
  });
}
