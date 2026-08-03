class Student {
  Student({
    required this.id,
    required this.regNo,
    required this.name,
    required this.major,
    List<String>? enrolledCourseIds,
  }) : enrolledCourseIds = enrolledCourseIds ?? [];

  final String id;
  String regNo;
  String name;
  String major;
  List<String> enrolledCourseIds;
}
