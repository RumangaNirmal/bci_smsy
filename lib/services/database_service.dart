import 'package:flutter/foundation.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../data/dummy_data.dart';

/// Simple in-memory data store shared across the whole app.
/// Swap the internals for SQLite/Hive/Firebase later without touching the UI,
/// as long as this public API stays the same.
class DatabaseService extends ChangeNotifier {
  DatabaseService._internal() {
    _students = seedStudents();
    _courses = seedCourses();
  }

  static final DatabaseService instance = DatabaseService._internal();

  late List<Student> _students;
  late List<Course> _courses;

  List<Student> get students => List.unmodifiable(_students);
  List<Course> get courses => List.unmodifiable(_courses);

  // ---------------- Students ----------------
  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(Student updated) {
    final index = _students.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _students[index] = updated;
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ---------------- Courses ----------------
  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void updateCourse(Course updated) {
    final index = _courses.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _courses[index] = updated;
      notifyListeners();
    }
  }

  void deleteCourse(String id) {
    _courses.removeWhere((c) => c.id == id);
    for (final s in _students) {
      s.enrolledCourseIds.remove(id);
    }
    notifyListeners();
  }

  // ---------------- Enrollment ----------------
  void enrollStudentInCourses(String studentId, List<String> courseIds) {
    final student = _students.firstWhere((s) => s.id == studentId);
    for (final id in courseIds) {
      if (!student.enrolledCourseIds.contains(id)) {
        student.enrolledCourseIds.add(id);
      }
    }
    notifyListeners();
  }

  void unenrollStudentFromCourse(String studentId, String courseId) {
    final student = _students.firstWhere((s) => s.id == studentId);
    student.enrolledCourseIds.remove(courseId);
    notifyListeners();
  }

  List<Course> coursesForStudent(String studentId) {
    final student = _students.firstWhere((s) => s.id == studentId);
    return _courses.where((c) => student.enrolledCourseIds.contains(c.id)).toList();
  }

  int get totalActiveEnrollments =>
      _students.fold(0, (sum, s) => sum + s.enrolledCourseIds.length);

  String newStudentId() => 's${DateTime.now().microsecondsSinceEpoch}';
  String newCourseId() => 'c${DateTime.now().microsecondsSinceEpoch}';
}
