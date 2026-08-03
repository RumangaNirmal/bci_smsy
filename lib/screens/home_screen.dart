import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'students/student_list_screen.dart';
import 'courses/course_list_screen.dart';
import 'enrollments/enrollment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _db = DatabaseService.instance;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('BCI Campus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dashboard Overview',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your campus ecosystem with precision. Monitor student growth, '
                    'course availability, and academic excellence at a glance.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCBA72F),
                      foregroundColor: const Color(0xFF4E3D00),
                    ),
                    onPressed: () => _goToEnrollment(context),
                    icon: const Icon(Icons.add),
                    label: const Text('New Enrollment'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                      label: 'Total Students',
                      value: '${_db.students.length}',
                      icon: Icons.group_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                      label: 'Total Courses',
                      value: '${_db.courses.length}',
                      icon: Icons.school_outlined),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StatCard(
              label: 'Active Enrollments',
              value: '${_db.totalActiveEnrollments}',
              icon: Icons.assignment_turned_in_outlined,
              wide: true,
            ),
            const SizedBox(height: 24),
            Text('Quick Actions',
                style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            const SizedBox(height: 12),
            _QuickAction(
              icon: Icons.person_add_outlined,
              label: 'Add Student',
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const StudentListScreen())),
            ),
            _QuickAction(
              icon: Icons.library_add_outlined,
              label: 'Add Course',
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseListScreen())),
            ),
            _QuickAction(
              icon: Icons.post_add_outlined,
              label: 'New Enrollment',
              onTap: () => _goToEnrollment(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BciBottomNav(
        currentIndex: 0,
        onTap: (index) => handleBciNavTap(context, index),
      ),
    );
  }

  void _goToEnrollment(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const EnrollmentScreen()));
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, this.wide = false});

  final String label;
  final String value;
  final IconData icon;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: wide ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E2E2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600], letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            ],
          ),
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// Shared bottom navigation bar used by every top-level screen so behaviour
/// stays consistent (Home / Students / Courses / Enroll).
class BciBottomNav extends StatelessWidget {
  const BciBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Students'),
        BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in_outlined), label: 'Enroll'),
      ],
    );
  }
}

/// Handles bottom-nav taps from any top-level screen by replacing the current route.
void handleBciNavTap(BuildContext context, int index) {
  Widget page;
  switch (index) {
    case 0:
      page = const HomeScreen();
      break;
    case 1:
      page = const StudentListScreen();
      break;
    case 2:
      page = const CourseListScreen();
      break;
    case 3:
      page = const EnrollmentScreen();
      break;
    default:
      return;
  }
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
}
