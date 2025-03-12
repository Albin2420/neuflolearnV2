// Chapter Model
class LiveChapter {
  final String chapterNo;
  final String chapterName;

  LiveChapter({
    required this.chapterNo,
    required this.chapterName,
  });

  // Factory constructor to create a Chapter from a Map
  factory LiveChapter.fromMap(Map<String, dynamic> map) {
    return LiveChapter(
      chapterNo: map['chapterNo'] ?? '',
      chapterName: map['chapterName'] ?? '',
    );
  }
}