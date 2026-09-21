import '../models/employee.dart';

class PayrollRepository {
  const PayrollRepository();

  double calculateNetPayroll(List<Employee> employees) {
    return employees.fold<double>(0, (double total, Employee employee) => total + employee.netSalary);
  }
}
