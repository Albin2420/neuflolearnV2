import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/core/url.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';
import 'package:neuflo_learn/src/data/services/data_access/api_service.dart';
import 'package:neuflo_learn/src/domain/repositories/chapter/chapter_repo.dart';

class ChapterRepoImpl extends ChapterRepo {
  ApiService apiService = ApiService();
  @override
  Future<Either<Failure, List<Chapter>>> fetchChapters(
      {required int subjectId}) async {
    // chapter_names
    log("fetchChapters Impl");

    if (kDebugMode) {
      log('${Url.baseUrl}/${Url.getChapterNames}/$subjectId');
    }
    try {
      final response = await apiService.get(
          url: '${Url.baseUrl}/${Url.getChapterNames}/$subjectId');
      dynamic result = handleResponse(response);

      if (result is Failure) {
        return Left(result);
      }
      log("response in fetchChapters():${response.body}");

      Map<String, dynamic> chapterNames = result['chapter_names'];

      // Create a list to hold Chapter objects
      List<Chapter> chapters = [];

      // Iterate over the map and create Chapter objects
      chapterNames.forEach((chapterName, id) {
        chapters.add(Chapter(chapterName: chapterName, chapterId: id));
      });

      return Right(chapters);
    } on FormatException catch (e) {
      debugPrint('exception : $e');
      return const Left(
        Failure(message: 'Format Exception'),
      );
    } on SocketException catch (e) {
      debugPrint('exception : $e');
      return const Left(
        Failure(
          code: ResponseCode.NO_INTERNET_CONNECTION,
          message: ResponseMessage.NO_INTERNET_CONNECTION,
        ),
      );
    } on Exception catch (e) {
      debugPrint('exception : $e');
      return const Left(
        Failure(message: 'Unknown error, Try again later'),
      );
    }
  }
}
