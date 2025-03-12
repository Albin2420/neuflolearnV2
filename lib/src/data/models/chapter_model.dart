// Chapter Model
class ChapterModel {
  final String chapterNo;
  final String chapterName;

  ChapterModel({
    required this.chapterNo,
    required this.chapterName,
  });

  // Factory constructor to create a Chapter from a Map
  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      chapterNo: map['chapterNo'] ?? '',
      chapterName: map['chapterName'] ?? '',
    );
  }
}