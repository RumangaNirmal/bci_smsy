import '../models/student.dart';
import '../services/student_service.dart';

class StudentController {
  StudentController({required StudentServiceContract service}) : _service = service;

  final StudentServiceContract _service;

  List<Student> loadStudents() => _service.getStudents();

  List<Student> searchStudents(String query) => _service.searchStudents(query);

  void addStudent(Student student) => _service.addStudent(student);

  void updateStudent(Student student, {required String originalId}) =>
      _service.updateStudent(student, originalId: originalId);

  void deleteStudent(String studentId) => _service.deleteStudent(studentId);
}
