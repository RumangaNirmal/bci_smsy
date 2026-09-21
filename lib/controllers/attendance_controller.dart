class AttendanceController {
  const AttendanceController();

  List<String> getAvailableStatuses() => const <String>['Present', 'Absent', 'Late', 'Excused'];
}
