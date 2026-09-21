import '../models/employee.dart';

class PayrollController {
  const PayrollController();

  double calculateSalary(Employee employee) => employee.grossSalary;

  double calculateAllowance(Employee employee) => employee.allowances;

  double calculateDeductions(Employee employee) => employee.totalDeductions;

  double calculateNetSalary(Employee employee) => employee.netSalary;

  double processPayroll(List<Employee> employees) {
    return employees.fold<double>(0, (double total, Employee employee) => total + employee.netSalary);
  }
}
