// ignore_for_file: public_member_api_docs, sort_constructors_first
class TestCompletionResult {
  final String? subjectname;
  final bool? iscompleted;

  TestCompletionResult({
    this.subjectname,
    this.iscompleted,
  });

  TestCompletionResult copyWith({
    int? testinstanceid,
    String? subjectname,
    bool? iscompleted,
  }) =>
      TestCompletionResult(
        subjectname: subjectname ?? this.subjectname,
        iscompleted: iscompleted ?? this.iscompleted,
      );

  factory TestCompletionResult.fromJson(Map<String, dynamic> json) =>
      TestCompletionResult(
        subjectname: json["subjectname"],
        iscompleted: json["iscompleted"],
      );

  @override
  String toString() =>
      'TestCompletionResult(subjectname: $subjectname, iscompleted: $iscompleted)';
}

