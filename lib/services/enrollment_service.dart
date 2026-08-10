import '../models/course.dart';
import '../models/student.dart';
import '../state/bci_store.dart';

/// This service handles enrollment logic separately from the user interface and application state.
abstract class EnrollmentServiceContract {
  List<Student> getStudents();
  List<Course> getCoursesForStudent(String studentId);
  void assignCourses(String studentId, List<String> courseIds);
  void enrolStudentInCourse(String studentId, String courseId);
}

class EnrollmentService implements EnrollmentServiceContract {
  EnrollmentService({required BciStore store}) : _store = store;

  final BciStore _store;

  @override
  List<Student> getStudents() => _store.students;

  @override
  List<Course> getCoursesForStudent(String studentId) => _store.getCoursesForStudent(studentId);

  @override
  void assignCourses(String studentId, List<String> courseIds) {
    _store.setCoursesForStudent(studentId, courseIds);
  }

  @override
  void enrolStudentInCourse(String studentId, String courseId) {
    _store.enrolStudentInCourse(studentId, courseId);
  }
}
