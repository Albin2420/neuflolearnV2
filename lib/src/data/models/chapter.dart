// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive/hive.dart';

part 'chapter.g.dart';

@HiveType(typeId: 1)
class Chapter {
  @HiveField(0)
  final String? chapterName;
  @HiveField(1)
  final int? chapterId;
  Chapter({
    this.chapterName,
    this.chapterId,
  });

  @override
  String toString() =>
      'Chapter(chapterName: $chapterName, chapterId: $chapterId)';

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;

    return other.chapterName == chapterName && other.chapterId == chapterId;
  }

  @override
  int get hashCode => chapterName.hashCode ^ chapterId.hashCode;
}
