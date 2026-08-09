import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../models/course.dart';
import '../../services/database_service.dart';

class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({super.key});

  @override
  State<EnrollmentScreen> createState() =>
      _EnrollmentScreenState();
}

class _EnrollmentScreenState
    extends State<EnrollmentScreen> {

  Student? selectedStudent;
  Course? selectedCourse;

  void enroll() {
    if (selectedStudent == null ||
        selectedCourse == null) {
      return;
    }

    DatabaseService.enrollments
        .putIfAbsent(
      selectedStudent!.id,
      () => [],
    );

    DatabaseService.enrollments[
            selectedStudent!.id]!
        .add(selectedCourse!.id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Enrollments")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            DropdownButton<Student>(
              hint: const Text(
                  "Select Student"),
              value: selectedStudent,
              items: DatabaseService.students
                  .map(
                    (student) =>
                        DropdownMenuItem(
                      value: student,
                      child:
                          Text(student.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStudent = value;
                });
              },
            ),

            DropdownButton<Course>(
              hint:
                  const Text("Select Course"),
              value: selectedCourse,
              items: DatabaseService.courses
                  .map(
                    (course) =>
                        DropdownMenuItem(
                      value: course,
                      child:
                          Text(course.title),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),

            ElevatedButton(
              onPressed: enroll,
              child: const Text("Enroll"),
            ),

            const Divider(),

            Expanded(
              child: ListView(
                children: DatabaseService.students
                    .map(
                  (student) {
                    final ids =
                        DatabaseService
                                .enrollments[
                            student.id] ??
                            [];

                    return Card(
                      child: ListTile(
                        title:
                            Text(student.name),
                        subtitle: Text(
                          ids.length
                              .toString(),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}