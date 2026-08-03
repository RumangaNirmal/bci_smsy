import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../services/database_service.dart';
import '../../widgets/student_card.dart';
import '../home_screen.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
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

  List<Student> get _filtered {
    if (_query.isEmpty) return _db.students;
    final q = _query.toLowerCase();
    return _db.students
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            s.regNo.toLowerCase().contains(q) ||
            s.major.toLowerCase().contains(q))
        .toList();
  }

  void _confirmDelete(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete student?'),
        content: Text('Remove ${student.name} and their enrollments?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _db.deleteStudent(student.id);
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
    final students = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('Students Directory')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name, ID, or major...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: students.isEmpty
                  ? const Center(child: Text('No students found'))
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return StudentCard(
                          student: student,
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditStudentScreen(student: student)),
                          ),
                          onDelete: () => _confirmDelete(student),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddStudentScreen())),
        child: const Icon(Icons.person_add_outlined),
      ),
      bottomNavigationBar: BciBottomNav(currentIndex: 1, onTap: (i) => handleBciNavTap(context, i)),
    );
  }
}
