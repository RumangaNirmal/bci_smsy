import '../models/student.dart';
import '../state/bci_store.dart';

/// This service contains the student-related business rules and separates them from the UI layer.
abstract class StudentServiceContract {
  List<Student> getStudents();
  List<Student> searchStudents(String query);
  void addStudent(Student student);
  void updateStudent(Student student, {required String originalId});
  void deleteStudent(String studentId);
}

class StudentService implements StudentServiceContract {
  StudentService({required BciStore store}) : _store = store;

  final BciStore _store;

  @override
  List<Student> getStudents() => _store.students;

  @override
  List<Student> searchStudents(String query) {
    final String normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return getStudents();
    }

    return getStudents().where((Student student) {
      return student.id.toLowerCase().contains(normalizedQuery) ||
          student.name.toLowerCase().contains(normalizedQuery) ||
          student.program.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  @override
  void addStudent(Student student) {
    _store.addStudent(student);
  }

  @override
  void updateStudent(Student student, {required String originalId}) {
    _store.updateStudent(student, originalId: originalId);
  }

  @override
  void deleteStudent(String studentId) {
    _store.removeStudent(studentId);
  }
}
