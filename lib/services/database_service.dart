import '../models/student.dart';
import '../models/course.dart';

class DatabaseService {
  static List<Student> students = [];

  static List<Course> courses = [];

  static Map<int, List<int>> enrollments = {};
}