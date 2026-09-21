import '../models/employee.dart';
import '../state/bci_store.dart';

class EmployeeRepository {
  EmployeeRepository({required BciStore store}) : _store = store;

  final BciStore _store;

  List<Employee> fetchEmployees() => _store.employees;

  void saveEmployee(Employee employee) => _store.addEmployee(employee);

  void deleteEmployee(String employeeId) => _store.removeEmployee(employeeId);
}
