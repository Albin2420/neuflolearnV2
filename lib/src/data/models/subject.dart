import 'chapter.dart';
import 'package:neuflo_learn/src/data/models/live_chapter.dart';

class Subject {
  final String icon;
  final String subjectName;
  final String completedCount;
  final String completedText;
  final List<LiveChapter> chapters;

  Subject({
    required this.icon,
    required this.subjectName,
    required this.completedCount,
    required this.completedText,
    required this.chapters,
  });

  // Factory constructor to create a Subject from a Map
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      icon: map['icon'] ?? '',
      subjectName: map['subjectName'] ?? '',
      completedCount: map['completedCount'] ?? '',
      completedText: map['completedText'] ?? '',
      chapters: (map['chapters'] as List<dynamic>? ?? [])
          .map(
            (chapter) => LiveChapter.fromMap(chapter as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
