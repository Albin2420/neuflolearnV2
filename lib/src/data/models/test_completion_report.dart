import 'package:neuflo_learn/src/data/models/test_completion_result.dart';

class TestCompletionReport {
  final int noOfExamsCompleted;
  final List<TestCompletionResult> completionResult;
  TestCompletionReport({
    required this.noOfExamsCompleted,
    required this.completionResult,
  });

  @override
  String toString() =>
      'TestCompletionReport(noOfExamsCompleted: $noOfExamsCompleted, completionResult: $completionResult)';
}
