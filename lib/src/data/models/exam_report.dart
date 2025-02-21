class ExamReport {
  final int? rank;
  final int? score;
  final int? correctAnswers;
  final int? incorrectAnswers;
  final double? averageAnsweringTimeSeconds;
  final String? lastResponseDate;

  //
  final String? timeTaken;
  final double? percentage;
  final int? unAttempted;

  ExamReport({
    this.rank,
    this.score,
    this.correctAnswers,
    this.incorrectAnswers,
    this.averageAnsweringTimeSeconds,
    this.lastResponseDate,
    this.timeTaken,
    this.percentage,
    this.unAttempted,
  });

  ExamReport copyWith({
    int? score,
    int? correctAnswers,
    int? incorrectAnswers,
    double? averageAnsweringTimeSeconds,
    String? lastResponseDate,
    String? timeTaken,
    double? percentage,
    int? unAttempted,
  }) =>
      ExamReport(
        score: score ?? this.score,
        correctAnswers: correctAnswers ?? this.correctAnswers,
        incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
        averageAnsweringTimeSeconds:
            averageAnsweringTimeSeconds ?? this.averageAnsweringTimeSeconds,
        lastResponseDate: lastResponseDate ?? this.lastResponseDate,
        timeTaken: timeTaken ?? this.timeTaken,
        percentage: percentage ?? this.percentage,
        unAttempted: unAttempted ?? this.unAttempted,
      );

  factory ExamReport.fromJson(Map<String, dynamic> json) => ExamReport(
        score: json["score"],
        correctAnswers: json["correct_answers"],
        incorrectAnswers: json["incorrect_answers"],
        averageAnsweringTimeSeconds: json["average_answering_time_seconds"],
        lastResponseDate: json["last_response_date"],
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "correct_answers": correctAnswers,
        "incorrect_answers": incorrectAnswers,
        "average_answering_time_seconds": averageAnsweringTimeSeconds,
        "last_response_date": lastResponseDate,
      };

  @override
  String toString() {
    return 'ExamReport(score: $score, correctAnswers: $correctAnswers, incorrectAnswers: $incorrectAnswers, averageAnsweringTimeSeconds: $averageAnsweringTimeSeconds, lastResponseDate: $lastResponseDate, timeTaken: $timeTaken, percentage: $percentage, unAttempted: $unAttempted)';
  }
}
