import '../models/course.dart';
import '../state/bci_store.dart';

class CourseRepository {
  CourseRepository({required BciStore store}) : _store = store;

  final BciStore _store;

  List<Course> fetchCourses() => _store.courses;

  void saveCourse(Course course) => _store.addCourse(course);

  void updateCourse(Course course, {required String originalId}) =>
      _store.updateCourse(course, originalId: originalId);

  void deleteCourse(String courseId) => _store.removeCourse(courseId);
}
