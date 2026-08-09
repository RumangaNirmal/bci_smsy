import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../services/database_service.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  void saveStudent() {
    DatabaseService.students.add(
      Student(
        id: DateTime.now().millisecondsSinceEpoch,
        name: nameController.text,
        email: emailController.text,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveStudent,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}