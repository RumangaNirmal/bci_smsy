import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({
    super.key,
    required this.students,
    this.onTap,
    this.onDelete,
  });

  final List<StudentModel> students;
  final ValueChanged<StudentModel>? onTap;
  final ValueChanged<StudentModel>? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (BuildContext context, int index) {
        final StudentModel student = students[index];
        return ListTile(
          title: Text(student.name),
          subtitle: Text(student.email),
          onTap: () => onTap?.call(student),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => onDelete?.call(student),
          ),
        );
      },
    );
  }
}
