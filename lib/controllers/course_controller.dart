import '../models/course.dart';
import '../services/course_service.dart';

class CourseController {
  CourseController({required CourseServiceContract service}) : _service = service;

  final CourseServiceContract _service;

  List<Course> loadCourses() => _service.getCourses();

  List<Course> searchCourses(String query) => _service.searchCourses(query);

  void addCourse(Course course) => _service.addCourse(course);

  void updateCourse(Course course, {required String originalId}) =>
      _service.updateCourse(course, originalId: originalId);

  void deleteCourse(String courseId) => _service.deleteCourse(courseId);
}
