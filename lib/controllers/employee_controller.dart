import '../models/employee.dart';
import '../state/bci_store.dart';

class EmployeeController {
  EmployeeController({required BciStore store}) : _store = store;

  final BciStore _store;

  List<Employee> loadEmployees() => _store.employees;

  void addEmployee(Employee employee) => _store.addEmployee(employee);

  void updateEmployee(Employee employee, {required String originalId}) {
    final int index = _store.employees.indexWhere((Employee item) => item.id == originalId);
    if (index >= 0) {
      final List<Employee> updated = List<Employee>.from(_store.employees);
      updated[index] = employee;
      _store.removeEmployee(originalId);
      _store.addEmployee(employee);
    }
  }

  void deleteEmployee(String employeeId) => _store.removeEmployee(employeeId);
}
