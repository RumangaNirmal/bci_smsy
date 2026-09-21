import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/widgets/app_buttons.dart';
import '../core/widgets/app_text_field.dart';
import '../models/course.dart';
import '../models/student.dart';
import '../services/enrollment_service.dart';
import '../state/bci_store.dart';

class EnrolmentsScreen extends StatefulWidget {
  const EnrolmentsScreen({super.key, required this.store});

  final BciStore store;

  @override
  State<EnrolmentsScreen> createState() => _EnrolmentsScreenState();
}

class _EnrolmentsScreenState extends State<EnrolmentsScreen> {
  String _query = '';
  late final EnrollmentServiceContract _enrollmentService;

  @override
  void initState() {
    super.initState();
    _enrollmentService = EnrollmentService(store: widget.store);
  }

  @override
  Widget build(BuildContext context) {
    // For student and course enrollment data to the main function.
    final List<Student> students = _enrollmentService.getStudents().where((Student student) {
      final String search = _query.toLowerCase();
      return student.id.toLowerCase().contains(search) ||
          student.name.toLowerCase().contains(search) ||
          student.program.toLowerCase().contains(search);
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
                  AppStrings.enrolmentManagement,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                SearchTextField(
                  label: AppStrings.searchStudent,
                  hintText: AppStrings.searchHintStudent,
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
                      final List<Course> enrolledCourses = _enrollmentService.getCoursesForStudent(student.id);
                      return Card(
                        child: ListTile(
                          title: Text(
                            student.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${student.id} • ${student.program}'),
                              const SizedBox(height: 6),
                              Text(
                                enrolledCourses.isEmpty
                                    ? 'No courses assigned.'
                                    : 'Courses: ${enrolledCourses.map((Course item) => item.name).join(', ')}',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.assignment_add),
                            onPressed: () => _showEnrolDialog(student),
                            tooltip: 'Assign courses',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEnrolDialog(Student student) async {
    final List<Course> availableCourses = widget.store.courses;
    final Set<String> selectedCourseIds = _enrollmentService.getCoursesForStudent(student.id).map((Course course) => course.id).toSet();

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            title: Text('Assign courses to ${student.name}'),
            content: SizedBox(
              width: 480,
              child: ListView(
                shrinkWrap: true,
                children: availableCourses.map((Course course) {
                  final bool selected = selectedCourseIds.contains(course.id);
                  return CheckboxListTile(
                    value: selected,
                    title: Text(course.name),
                    subtitle: Text('${course.code} • ${course.credits} credits'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedCourseIds.add(course.id);
                        } else {
                          selectedCourseIds.remove(course.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              AppButton(label: AppStrings.cancel, onPressed: () => Navigator.pop(dialogContext), fill: false),
              AppButton(
                label: AppStrings.save,
                onPressed: () {
                  _enrollmentService.assignCourses(student.id, selectedCourseIds.toList());
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
