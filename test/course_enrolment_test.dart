import 'package:flutter_test/flutter_test.dart';

import 'package:bci_management_system/models/course.dart';
import 'package:bci_management_system/state/bci_store.dart';

void main() {
  group('course and enrolment management', () {
    test('supports add, update, delete and enrolment flows', () {
      final BciStore store = BciStore();
      final int initialCount = store.courses.length;

      final Course course = Course(
        id: 'CRS-999',
        code: 'CS999',
        name: 'Programming Fundamentals',
        credits: 3,
        description: 'Introductory programming',
        status: 'Active',
      );

      store.addCourse(course);
      expect(store.courses.length, initialCount + 1);

      store.updateCourse(
        course.copyWith(name: 'Programming Fundamentals II'),
        originalId: course.id,
      );
      expect(
        store.courses.where((Course item) => item.id == 'CRS-999').single.name,
        'Programming Fundamentals II',
      );

      store.enrolStudentInCourse('BCI-2026-001', 'CRS-999');
      expect(
        store.getCoursesForStudent('BCI-2026-001').any((Course item) => item.id == 'CRS-999'),
        isTrue,
      );

      store.removeCourse('CRS-999');
      expect(store.courses.any((Course item) => item.id == 'CRS-999'), isFalse);
    });
  });
}
