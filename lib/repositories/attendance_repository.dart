class AttendanceRepository {
  const AttendanceRepository();

  List<String> fetchStatuses() => const <String>['Present', 'Absent', 'Late', 'Excused'];
}
