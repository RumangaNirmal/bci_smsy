import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import 'add_course_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() =>
      _CourseListScreenState();
}

class _CourseListScreenState
    extends State<CourseListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Courses")),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddCourseScreen(),
            ),
          );

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount:
            DatabaseService.courses.length,
        itemBuilder: (context, index) {
          final course =
              DatabaseService.courses[index];

          return ListTile(
            title: Text(course.title),
            subtitle: Text(course.code),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  DatabaseService.courses
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