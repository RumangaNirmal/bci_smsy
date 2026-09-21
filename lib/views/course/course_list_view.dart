import 'package:flutter/material.dart';

import '../../models/course_model.dart';

class CourseListView extends StatelessWidget {
  const CourseListView({
    super.key,
    required this.courses,
    this.onTap,
    this.onDelete,
  });

  final List<CourseModel> courses;
  final ValueChanged<CourseModel>? onTap;
  final ValueChanged<CourseModel>? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (BuildContext context, int index) {
        final CourseModel course = courses[index];
        return ListTile(
          title: Text(course.name),
          subtitle: Text('${course.code} • ${course.credits} credits'),
          onTap: () => onTap?.call(course),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => onDelete?.call(course),
          ),
        );
      },
    );
  }
}
