import '../core/services/search_service.dart';
import '../models/student.dart';
import '../state/bci_store.dart';

/// For student management logic to the main function.
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
    final String normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return getStudents();
    }

    return getStudents().where((Student student) {
      return SearchService.matchesQuery(student.id, normalizedQuery) ||
          SearchService.matchesQuery(student.name, normalizedQuery) ||
          SearchService.matchesQuery(student.program, normalizedQuery);
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
