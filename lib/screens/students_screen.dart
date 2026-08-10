import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/student_service.dart';
import '../state/bci_store.dart';
import '../widgets/solid_form_field.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key, required this.store});

  final BciStore store;

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _query = '';
  late final StudentServiceContract _studentService;

  @override
  void initState() {
    super.initState();
    _studentService = StudentService(store: widget.store);
  }

  @override
  Widget build(BuildContext context) {
    // The screen delegates search and list handling to a service rather than keeping this logic inline.
    final List<Student> students = _studentService.searchStudents(_query);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Student Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search students',
                    hintText: 'Search by ID, name or programme',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) => setState(() => _query = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? const Center(child: Text('No students found.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: students.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final Student student = students[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              student.name.isEmpty
                                  ? '?'
                                  : student.name[0].toUpperCase(),
                            ),
                          ),
                          title: Text(
                            student.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${student.id}\n${student.program}\n${student.email}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (String value) {
                              if (value == 'edit') {
                                _showAddStudentDialog(student: student);
                              } else if (value == 'delete') {
                                _confirmDelete(student);
                              }
                            },
                            itemBuilder: (_) => const <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStudentDialog,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Student'),
      ),
    );
  }

  Future<void> _confirmDelete(Student student) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete student'),
        content: Text('Delete ${student.name} from the system?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _studentService.deleteStudent(student.id);
    }
  }

  Future<void> _showAddStudentDialog({Student? student}) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController idController = TextEditingController(text: student?.id ?? '');
    final TextEditingController nameController = TextEditingController(text: student?.name ?? '');
    final TextEditingController emailController = TextEditingController(text: student?.email ?? '');
    final TextEditingController programmeController = TextEditingController(text: student?.program ?? '');
    final TextEditingController intakeController = TextEditingController(text: student?.intake ?? '');

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(student == null ? 'Register Student' : 'Edit Student'),
        content: SizedBox(
          width: 480,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SolidFormField(controller: idController, label: 'Student ID'),
                  SolidFormField(controller: nameController, label: 'Full Name'),
                  SolidFormField(
                    controller: emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required.';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  SolidFormField(
                    controller: programmeController,
                    label: 'Programme',
                  ),
                  SolidFormField(controller: intakeController, label: 'Intake'),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final Student studentData = Student(
                  id: idController.text.trim(),
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  program: programmeController.text.trim(),
                  intake: intakeController.text.trim(),
                  status: 'Active',
                );
                // The screen collects the form input and forwards the action to the service layer.
                if (student == null) {
                  _studentService.addStudent(studentData);
                } else {
                  _studentService.updateStudent(
                    studentData,
                    originalId: student.id,
                  );
                }
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    programmeController.dispose();
    intakeController.dispose();
  }
}

