import 'package:flutter/foundation.dart';
import 'package:neuflo_learn/src/data/models/image.dart';
import 'package:neuflo_learn/src/data/models/options.dart';

class QstnHistoryModel {
  final String? question;
  final Options? options;
  final String? answer;
  final String? explanation;
  final int? questionId;
  final List<Image>? images;
  final String? submittedAnswer;

  ///
  final String? selectedOption;
  final bool? isSelected;
  final bool? isAttempted;
  final bool? isSkipped;
  final bool? isFlagged;
  final bool? isMarkedCorrect;

  QstnHistoryModel({
    this.question,
    this.options,
    this.answer,
    this.explanation,
    this.questionId,
    this.images,
    this.selectedOption,
    this.isSelected = false,
    this.isAttempted = false,
    this.isSkipped = false,
    this.isFlagged = false,
    this.isMarkedCorrect = false,
    this.submittedAnswer,
  });

  QstnHistoryModel copyWith({
    String? question,
    Options? options,
    String? answer,
    String? explanation,
    int? questionId,
    List<Image>? images,
    bool? isSelected,
    bool? isAttempted,
    bool? isSkipped,
    bool? isFlagged,
    String? selectedOption,
    bool? isMarkedCorrect,
  }) =>
      QstnHistoryModel(
        question: question ?? this.question,
        options: options ?? this.options,
        answer: answer ?? this.answer,
        explanation: explanation ?? this.explanation,
        questionId: questionId ?? this.questionId,
        images: images ?? this.images,
        isSelected: isSelected ?? this.isSelected,
        isAttempted: isAttempted ?? this.isAttempted,
        isSkipped: isSkipped ?? this.isSkipped,
        isFlagged: isFlagged ?? this.isFlagged,
        selectedOption: selectedOption ?? this.selectedOption,
        isMarkedCorrect: isMarkedCorrect ?? this.isMarkedCorrect,
      );

  factory QstnHistoryModel.fromJson(Map<String, dynamic> json) =>
      QstnHistoryModel(
          question: json["text"],
          options:
              json["options"] == null ? null : Options.fromMap(json["options"]),
          answer: json["answer"],
          explanation: json["explanation"],
          questionId: json["question_id"],
          submittedAnswer: json["student_answer"]
          // images: json["has_image"] == false
          //     ? []
          //     : List<Image>.from(json["has_image"]?.map((x) => x)),
          );

  @override
  String toString() {
    return 'Question(question: $question, options: $options, answer: $answer, explanation: $explanation, questionId: $questionId, images: $images, isAttempted: $isAttempted, isSkipped: $isSkipped, isFlagged: $isFlagged,isSelected: $isSelected,isMarkedCorrect : $isMarkedCorrect)';
  }

  @override
  bool operator ==(covariant QstnHistoryModel other) {
    if (identical(this, other)) return true;

    return other.question == question &&
        other.options == options &&
        other.answer == answer &&
        other.explanation == explanation &&
        other.questionId == questionId &&
        listEquals(other.images, images) &&
        other.isAttempted == isAttempted &&
        other.isSkipped == isSkipped &&
        other.isFlagged == isFlagged;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        options.hashCode ^
        answer.hashCode ^
        explanation.hashCode ^
        questionId.hashCode ^
        images.hashCode ^
        isAttempted.hashCode ^
        isSkipped.hashCode ^
        isFlagged.hashCode;
  }
}
