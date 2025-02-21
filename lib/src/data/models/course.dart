import 'package:hive/hive.dart';

part 'course.g.dart';

@HiveType(typeId: 0)
class Course {
  @HiveField(0)
  final int? courseId;
  @HiveField(1)
  final String? courseName;
  @HiveField(2)
  final String? courseDescription;
  @HiveField(3)
  final double? duration;
  @HiveField(4)
  final int? orgainisation;
  @HiveField(5)
  final bool? is_active;

  Course(
      {this.courseId,
      this.courseName,
      this.courseDescription,
      this.duration,
      this.orgainisation,
      this.is_active});

  Course copyWith(
          {int? courseId,
          String? courseName,
          String? courseDescription,
          double? duration,
          int? orgainisation,
          bool? is_active}) =>
      Course(
          courseId: courseId ?? this.courseId,
          courseName: courseName ?? this.courseName,
          courseDescription: courseDescription ?? this.courseDescription,
          duration: duration ?? this.duration,
          orgainisation: orgainisation ?? this.orgainisation,
          is_active: is_active ?? this.is_active);

  factory Course.fromJson(Map<String, dynamic> json) => Course(
      courseId: json["id"],
      courseName: json["name"],
      courseDescription: json["description"],
      duration: json["duration"],
      orgainisation: json["organization"],
      is_active: json["is_active"]);

  Map<String, dynamic> toJson() => {
        "id": courseId,
        "name": courseName,
        "description": courseDescription,
        "duration": duration,
        "organization": orgainisation,
        "is_active": is_active
      };

  @override
  String toString() {
    return 'Course(courseId: $courseId, courseName: $courseName, courseDescription: $courseDescription, duration: $duration)';
  }

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return other.courseId == courseId &&
        other.courseName == courseName &&
        other.courseDescription == courseDescription &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return courseId.hashCode ^
        courseName.hashCode ^
        courseDescription.hashCode ^
        duration.hashCode;
  }
}
