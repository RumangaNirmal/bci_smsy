import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState
    extends State<StudentListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddStudentScreen(),
            ),
          );

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: DatabaseService.students.length,
        itemBuilder: (context, index) {
          final student =
              DatabaseService.students[index];

          return ListTile(
            title: Text(student.name),
            subtitle: Text(student.email),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  DatabaseService.students
                      .removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}