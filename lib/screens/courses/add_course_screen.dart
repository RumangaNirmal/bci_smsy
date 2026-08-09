import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/database_service.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() =>
      _AddCourseScreenState();
}

class _AddCourseScreenState
    extends State<AddCourseScreen> {

  final titleController =
      TextEditingController();

  final codeController =
      TextEditingController();

  void saveCourse() {
    DatabaseService.courses.add(
      Course(
        id: DateTime.now()
            .millisecondsSinceEpoch,
        title: titleController.text,
        code: codeController.text,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Add Course")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(
                labelText: "Course Name",
              ),
            ),
            TextField(
              controller: codeController,
              decoration:
                  const InputDecoration(
                labelText: "Course Code",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveCourse,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}