import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/database_service.dart';
import '../../widgets/course_card.dart';
import '../home_screen.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final _db = DatabaseService.instance;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _db.addListener(_refresh);
  }

  @override
  void dispose() {
    _db.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<Course> get _filtered {
    if (_query.isEmpty) return _db.courses;
    final q = _query.toLowerCase();
    return _db.courses
        .where((c) => c.title.toLowerCase().contains(q) || c.code.toLowerCase().contains(q))
        .toList();
  }

  void _confirmDelete(Course course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete course?'),
        content: Text('Remove ${course.title} and unenroll all students from it?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _db.deleteCourse(course.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('Course Catalog')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search courses or codes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: courses.isEmpty
                  ? const Center(child: Text('No courses found'))
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return CourseCard(
                          course: course,
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditCourseScreen(course: course)),
                          ),
                          onDelete: () => _confirmDelete(course),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCourseScreen())),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BciBottomNav(currentIndex: 2, onTap: (i) => handleBciNavTap(context, i)),
    );
  }
}
