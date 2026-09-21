import '../models/student.dart';
import '../state/bci_store.dart';

class StudentRepository {
  StudentRepository({required BciStore store}) : _store = store;

  final BciStore _store;

  List<Student> fetchStudents() => _store.students;

  void saveStudent(Student student) => _store.addStudent(student);

  void updateStudent(Student student, {required String originalId}) =>
      _store.updateStudent(student, originalId: originalId);

  void deleteStudent(String studentId) => _store.removeStudent(studentId);
}
