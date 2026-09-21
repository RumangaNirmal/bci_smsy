import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/validators/validators.dart';
import '../core/widgets/app_buttons.dart';
import '../core/widgets/app_text_field.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../state/bci_store.dart';
import '../widgets/solid_form_field.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key, required this.store});

  final BciStore store;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _query = '';
  late final CourseServiceContract _courseService;

  @override
  void initState() {
    super.initState();
    _courseService = CourseService(store: widget.store);
  }

  @override
  Widget build(BuildContext context) {
    // For course filtering to the main function.
    final List<Course> courses = _courseService.searchCourses(_query);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.courseManagement,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                SearchTextField(
                  label: AppStrings.searchCourses,
                  hintText: AppStrings.searchHintCourses,
                  onChanged: (String value) => setState(() => _query = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: courses.isEmpty
                ? const Center(child: Text(AppStrings.noCoursesFound))
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
      floatingActionButton: PrimaryButton(
        onPressed: () => _showAddEditCourseDialog(),
        icon: Icons.library_add_outlined,
        label: AppStrings.addCourse,
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
          AppButton(label: AppStrings.cancel, onPressed: () => Navigator.pop(context, false), fill: false),
          AppButton(label: AppStrings.delete, onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    if (confirmed == true) {
      _courseService.deleteCourse(course.id);
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
                  SolidFormField(controller: idController, label: 'Course ID'),
                  SolidFormField(controller: codeController, label: 'Course Code'),
                  SolidFormField(controller: nameController, label: 'Course Name'),
                  SolidFormField(
                    controller: creditsController,
                    label: 'Credits',
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      final String? requiredMessage = requiredValidator(value, fieldName: 'Credits');
                      if (requiredMessage != null) {
                        return requiredMessage;
                      }
                      if (int.tryParse(value!.trim()) == null) {
                        return 'Enter a valid number.';
                      }
                      return null;
                    },
                  ),
                  SolidFormField(controller: descriptionController, label: 'Description'),
                  SolidFormField(controller: statusController, label: 'Status'),
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
                final Course updatedCourse = Course(
                  id: idController.text.trim(),
                  code: codeController.text.trim(),
                  name: nameController.text.trim(),
                  credits: int.tryParse(creditsController.text.trim()) ?? 3,
                  description: descriptionController.text.trim(),
                  status: statusController.text.trim().isEmpty ? 'Active' : statusController.text.trim(),
                );
                if (course == null) {
                  _courseService.addCourse(updatedCourse);
                } else {
                  _courseService.updateCourse(
                    updatedCourse,
                    originalId: course.id,
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
    codeController.dispose();
    nameController.dispose();
    creditsController.dispose();
    descriptionController.dispose();
    statusController.dispose();
  }
}

