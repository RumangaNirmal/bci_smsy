import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/validators/validators.dart';
import '../core/widgets/app_buttons.dart';
import '../core/widgets/app_text_field.dart';
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
    // For search and list handling to the main function.
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
                  AppStrings.studentManagement,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                SearchTextField(
                  label: AppStrings.searchStudents,
                  hintText: AppStrings.searchHintStudents,
                  onChanged: (String value) => setState(() => _query = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? const Center(child: Text(AppStrings.noStudentsFound))
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
      floatingActionButton: PrimaryButton(
        onPressed: _showAddStudentDialog,
        icon: Icons.person_add_alt_1,
        label: AppStrings.addStudent,
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
          AppButton(label: AppStrings.cancel, onPressed: () => Navigator.pop(context, false), fill: false),
          AppButton(label: AppStrings.delete, onPressed: () => Navigator.pop(context, true)),
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
                    validator: emailValidator,
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
          AppButton(label: AppStrings.cancel, onPressed: () => Navigator.pop(dialogContext), fill: false),
          AppButton(
            label: AppStrings.save,
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

