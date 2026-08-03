import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../services/database_service.dart';
import '../home_screen.dart';

class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({super.key});

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  final _db = DatabaseService.instance;
  String _studentQuery = '';
  Student? _selectedStudent;
  final Set<String> _selectedCourseIds = {};

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

  List<Student> get _filteredStudents {
    if (_studentQuery.isEmpty) return _db.students;
    final q = _studentQuery.toLowerCase();
    return _db.students
        .where((s) => s.name.toLowerCase().contains(q) || s.regNo.toLowerCase().contains(q))
        .toList();
  }

  void _selectStudent(Student s) {
    setState(() {
      _selectedStudent = s;
      _selectedCourseIds
        ..clear()
        ..addAll(s.enrolledCourseIds);
    });
  }

  void _confirmEnrollment() {
    if (_selectedStudent == null) return;
    _selectedStudent!.enrolledCourseIds = _selectedCourseIds.toList();
    _db.updateStudent(_selectedStudent!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_selectedStudent!.name} enrollment updated.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Student Enrollment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Student', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or student ID...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _studentQuery = v),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.builder(
                itemCount: _filteredStudents.length,
                itemBuilder: (context, i) {
                  final s = _filteredStudents[i];
                  final isSelected = _selectedStudent?.id == s.id;
                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                    leading: CircleAvatar(child: Text(s.name.isNotEmpty ? s.name[0] : '?')),
                    title: Text(s.name),
                    subtitle: Text('${s.regNo} • ${s.major}'),
                    onTap: () => _selectStudent(s),
                  );
                },
              ),
            ),
            const Divider(height: 32),
            Text('Select Courses', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_selectedStudent == null)
              const Text('Choose a student above to manage their courses.',
                  style: TextStyle(color: Colors.grey))
            else
              Column(
                children: _db.courses.map((c) {
                  final checked = _selectedCourseIds.contains(c.id);
                  return CheckboxListTile(
                    value: checked,
                    title: Text(c.title),
                    subtitle: Text('${c.code} • ${c.credits} Credits'),
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          _selectedCourseIds.add(c.id);
                        } else {
                          _selectedCourseIds.remove(c.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            if (_selectedStudent != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmEnrollment,
                  child: Text('Confirm Enrollment (${_selectedCourseIds.length} Courses)'),
                ),
              ),
            const Divider(height: 40),
            Text('Active Enrollments', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final s in _db.students)
              if (s.enrolledCourseIds.isNotEmpty)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(s.name),
                    subtitle: Text(_db.coursesForStudent(s.id).map((c) => c.code).join(', ')),
                  ),
                ),
          ],
        ),
      ),
      bottomNavigationBar: BciBottomNav(currentIndex: 3, onTap: (i) => handleBciNavTap(context, i)),
    );
  }
}
