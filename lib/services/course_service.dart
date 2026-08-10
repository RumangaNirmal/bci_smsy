import '../models/course.dart';
import '../state/bci_store.dart';

/// This service manages course-related business logic and keeps the user interface focused on presentation.
abstract class CourseServiceContract {
  List<Course> getCourses();
  List<Course> searchCourses(String query);
  void addCourse(Course course);
  void updateCourse(Course course, {required String originalId});
  void deleteCourse(String courseId);
}

class CourseService implements CourseServiceContract {
  CourseService({required BciStore store}) : _store = store;

  final BciStore _store;

  @override
  List<Course> getCourses() => _store.courses;

  @override
  List<Course> searchCourses(String query) {
    final String normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return getCourses();
    }

    return getCourses().where((Course course) {
      return course.code.toLowerCase().contains(normalizedQuery) ||
          course.name.toLowerCase().contains(normalizedQuery) ||
          course.description.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  @override
  void addCourse(Course course) {
    _store.addCourse(course);
  }

  @override
  void updateCourse(Course course, {required String originalId}) {
    _store.updateCourse(course, originalId: originalId);
  }

  @override
  void deleteCourse(String courseId) {
    _store.removeCourse(courseId);
  }
}
