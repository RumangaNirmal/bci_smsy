import 'package:flutter/material.dart';

import '../models/course.dart';
import '../state/bci_store.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key, required this.store});

  final BciStore store;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final List<Course> courses = widget.store.courses.where((Course course) {
      final String search = _query.toLowerCase();
      return course.code.toLowerCase().contains(search) ||
          course.name.toLowerCase().contains(search) ||
          course.description.toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Course Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search courses',
                    hintText: 'Search by code, name or description',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) => setState(() => _query = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: courses.isEmpty
                ? const Center(child: Text('No courses found.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: courses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final Course course = courses[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(course.code.substring(0, 2).toUpperCase()),
                          ),
                          title: Text(
                            course.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${course.code} • ${course.credits} credits\n${course.description}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (String value) {
                              if (value == 'edit') {
                                _showAddEditCourseDialog(course: course);
                              } else if (value == 'delete') {
                                _confirmDelete(course);
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
        onPressed: () => _showAddEditCourseDialog(),
        icon: const Icon(Icons.library_add_outlined),
        label: const Text('Add Course'),
      ),
    );
  }

  Future<void> _confirmDelete(Course course) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete course'),
        content: Text('Delete ${course.name} from the system?'),
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
      widget.store.removeCourse(course.id);
    }
  }

  Future<void> _showAddEditCourseDialog({Course? course}) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController idController = TextEditingController(text: course?.id ?? '');
    final TextEditingController codeController = TextEditingController(text: course?.code ?? '');
    final TextEditingController nameController = TextEditingController(text: course?.name ?? '');
    final TextEditingController creditsController = TextEditingController(
      text: course?.credits.toString() ?? '3',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: course?.description ?? '',
    );
    final TextEditingController statusController = TextEditingController(text: course?.status ?? 'Active');

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(course == null ? 'Add Course' : 'Edit Course'),
        content: SizedBox(
          width: 480,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _RequiredField(controller: idController, label: 'Course ID'),
                  _RequiredField(controller: codeController, label: 'Course Code'),
                  _RequiredField(controller: nameController, label: 'Course Name'),
                  _RequiredField(
                    controller: creditsController,
                    label: 'Credits',
                    keyboardType: TextInputType.number,
                  ),
                  _RequiredField(controller: descriptionController, label: 'Description'),
                  _RequiredField(controller: statusController, label: 'Status'),
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
                final Course updatedCourse = Course(
                  id: idController.text.trim(),
                  code: codeController.text.trim(),
                  name: nameController.text.trim(),
                  credits: int.tryParse(creditsController.text.trim()) ?? 3,
                  description: descriptionController.text.trim(),
                  status: statusController.text.trim().isEmpty ? 'Active' : statusController.text.trim(),
                );
                if (course == null) {
                  widget.store.addCourse(updatedCourse);
                } else {
                  widget.store.updateCourse(
                    updatedCourse,
                    originalId: course.id,
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
    codeController.dispose();
    nameController.dispose();
    creditsController.dispose();
    descriptionController.dispose();
    statusController.dispose();
  }
}

class _RequiredField extends StatelessWidget {
  const _RequiredField({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required.';
          }
          if (label == 'Credits' && int.tryParse(value.trim()) == null) {
            return 'Enter a valid number.';
          }
          return null;
        },
      ),
    );
  }
}
