import '../models/student.dart';
import '../models/course.dart';

List<Student> seedStudents() => [
      Student(id: 's1', regNo: '2024-0012', name: 'Adrian Fernando', major: 'Computer Science'),
      Student(id: 's2', regNo: '2024-0158', name: 'Shani Perera', major: 'Business Management'),
      Student(id: 's3', regNo: '2023-0842', name: 'Kasun Wijesinghe', major: 'Biological Sciences'),
      Student(id: 's4', regNo: '2024-0045', name: 'Minoli Silva', major: 'Liberal Arts'),
    ];

List<Course> seedCourses() => [
      Course(
        id: 'c1',
        code: 'CS101',
        title: 'Introduction to Computer Science',
        description: 'Fundamental concepts of programming, algorithms, and computational thinking.',
        credits: 4.0,
      ),
      Course(
        id: 'c2',
        code: 'MATH204',
        title: 'Discrete Mathematics II',
        description: 'Advanced logic, graph theory, and combinatorics for theoretical computing.',
        credits: 3.0,
      ),
      Course(
        id: 'c3',
        code: 'PHY112',
        title: 'General Physics: Mechanics',
        description: 'Statics, dynamics, energy, and momentum with weekly lab sessions.',
        credits: 4.0,
      ),
      Course(
        id: 'c4',
        code: 'HIST305',
        title: 'Modern World History',
        description: 'Political, economic, and social trends since the industrial revolution.',
        credits: 3.0,
      ),
    ];
