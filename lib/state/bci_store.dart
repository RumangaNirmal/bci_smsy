import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../models/employee.dart';
import '../models/student.dart';

class BciStore extends ChangeNotifier {
  final List<Student> _students = <Student>[
    const Student(
      id: 'BCI-2026-001',
      name: 'Ayesha Perera',
      email: 'ayesha@students.bci.lk',
      program: 'BSc Software Engineering',
      intake: 'February 2026',
      status: 'Active',
    ),
    const Student(
      id: 'BCI-2026-002',
      name: 'Nimal Fernando',
      email: 'nimal@students.bci.lk',
      program: 'BSc Information Technology',
      intake: 'February 2026',
      status: 'Active',
    ),
    const Student(
      id: 'BCI-2025-118',
      name: 'Tharushi Silva',
      email: 'tharushi@students.bci.lk',
      program: 'BSc Computer Science',
      intake: 'September 2025',
      status: 'Active',
    ),
  ];

  final List<Course> _courses = <Course>[
    const Course(
      id: 'CRS-101',
      code: 'CS101',
      name: 'Programming Fundamentals',
      credits: 3,
      description: 'Introductory programming concepts',
      status: 'Active',
    ),
    const Course(
      id: 'CRS-102',
      code: 'DB201',
      name: 'Database Design',
      credits: 3,
      description: 'Relational database concepts and SQL',
      status: 'Active',
    ),
    const Course(
      id: 'CRS-103',
      code: 'SE301',
      name: 'Software Engineering Principles',
      credits: 4,
      description: 'Modern software development practices',
      status: 'Active',
    ),
  ];

  final Map<String, List<String>> _studentCourseIds = <String, List<String>>{
    'BCI-2026-001': <String>['CRS-101', 'CRS-102'],
    'BCI-2026-002': <String>['CRS-103'],
  };

  final List<Employee> _employees = <Employee>[
    const Employee(
      id: 'EMP-001',
      name: 'Dr. Amal Jayasinghe',
      department: 'School of Computing',
      designation: 'Senior Lecturer',
      basicSalary: 185000,
      allowances: 35000,
      overtime: 12000,
      deductions: 8500,
      tax: 17500,
    ),
    const Employee(
      id: 'EMP-002',
      name: 'Rashmi Perera',
      department: 'Finance',
      designation: 'Finance Officer',
      basicSalary: 125000,
      allowances: 22000,
      overtime: 6500,
      deductions: 5000,
      tax: 9500,
    ),
    const Employee(
      id: 'EMP-003',
      name: 'Kamal Fernando',
      department: 'Administration',
      designation: 'Management Assistant',
      basicSalary: 95000,
      allowances: 18000,
      overtime: 8000,
      deductions: 3500,
      tax: 4200,
    ),
  ];

  List<Student> get students => List<Student>.unmodifiable(_students);
  List<Course> get courses => List<Course>.unmodifiable(_courses);
  List<Employee> get employees => List<Employee>.unmodifiable(_employees);

  int get activeStudentCount =>
      _students.where((Student student) => student.status == 'Active').length;

  double get monthlyPayrollTotal => _employees.fold<double>(
        0,
        (double sum, Employee employee) => sum + employee.netSalary,
      );

  void addStudent(Student student) {
    _students.add(student);
    _studentCourseIds[student.id] = <String>[];
    notifyListeners();
  }

  void updateStudent(Student student, {required String originalId}) {
    final int index = _students.indexWhere((Student item) => item.id == originalId);
    if (index >= 0) {
      _students[index] = student;
      if (originalId != student.id) {
        final List<String>? existingCourseIds = _studentCourseIds.remove(originalId);
        if (existingCourseIds != null) {
          _studentCourseIds[student.id] = existingCourseIds;
        }
      }
      notifyListeners();
    }
  }

  void removeStudent(String studentId) {
    _students.removeWhere((Student student) => student.id == studentId);
    _studentCourseIds.remove(studentId);
    notifyListeners();
  }

  void addCourse(Course course) {
    final int index = _courses.indexWhere((Course item) => item.id == course.id);
    if (index >= 0) {
      _courses[index] = course;
    } else {
      _courses.add(course);
    }
    notifyListeners();
  }

  void updateCourse(Course course, {required String originalId}) {
    final int index = _courses.indexWhere((Course item) => item.id == originalId);
    if (index >= 0) {
      _courses[index] = course;
      notifyListeners();
    }
  }

  void removeCourse(String courseId) {
    _courses.removeWhere((Course course) => course.id == courseId);
    for (final String studentId in _studentCourseIds.keys.toList()) {
      _studentCourseIds[studentId] =
          _studentCourseIds[studentId]!.where((String id) => id != courseId).toList();
    }
    notifyListeners();
  }

  List<Course> getCoursesForStudent(String studentId) {
    final List<String> courseIds = _studentCourseIds[studentId] ?? <String>[];
    return _courses.where((Course course) => courseIds.contains(course.id)).toList();
  }

  void setCoursesForStudent(String studentId, List<String> courseIds) {
    _studentCourseIds[studentId] = courseIds;
    notifyListeners();
  }

  void enrolStudentInCourse(String studentId, String courseId) {
    final List<String> existingCourseIds = _studentCourseIds[studentId] ?? <String>[];
    if (!existingCourseIds.contains(courseId)) {
      existingCourseIds.add(courseId);
      _studentCourseIds[studentId] = existingCourseIds;
      notifyListeners();
    }
  }

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void removeEmployee(String employeeId) {
    _employees.removeWhere((Employee employee) => employee.id == employeeId);
    notifyListeners();
  }
}
