class ExamRecord {
  final int testId;
  final String testName;
  final DateTime completionDate;
  final int score;
  final int totalScore;

  ExamRecord(
      {required this.testId,
      required this.testName,
      required this.completionDate,
      required this.score,
      required this.totalScore});

  // Factory method to create an instance from JSON
  factory ExamRecord.fromJson(Map<String, dynamic> json) {
    return ExamRecord(
      testId: json['test_id'],
      testName: json['test_name'] ?? '',
      completionDate: DateTime.parse(json['completion_date']),
      score: json['score'] != null ? int.parse(json['score'].toString()) : 0,
      totalScore: json['total_score'],
    );
  }
}
