import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:neuflo_learn/src/core/network/error_handler.dart';
import 'package:neuflo_learn/src/core/network/failure.dart';
import 'package:neuflo_learn/src/domain/repositories/subject/subject_repo.dart';

class SubjectRepoImpl implements SubjectRepo {
  final String baseUrl = "http://13.233.101.63:8010";

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchSubjects() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/videos-by-chapter"));

      if (response.statusCode == 200) {
        dynamic result = handleResponse(response);

        List<dynamic> physics = result['Physics'] ?? [];
        List<dynamic> chemistry = result['Chemistry'] ?? [];
        List<dynamic> biology = result['Biology'] ?? [];

        log("PHYSICS: $physics");
        log("CHEMISTRY: $chemistry");
        log("BIOLOGY: $biology");

        return Right({
          "Physics": physics,
          "Chemistry": chemistry,
          "Biology": biology,
        });
      } else {
        throw Exception('Failed to fetch subjects: ${response.statusCode}');
      }
    } catch (e) {
      log("Error fetching subjects: $e");
      throw Exception("Network error: Unable to fetch subjects");
    }
  }
}
