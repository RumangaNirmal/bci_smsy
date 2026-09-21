import 'package:flutter/material.dart';

import '../../models/employee_model.dart';

class EmployeeListView extends StatelessWidget {
  const EmployeeListView({
    super.key,
    required this.employees,
    this.onTap,
  });

  final List<EmployeeModel> employees;
  final ValueChanged<EmployeeModel>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (BuildContext context, int index) {
        final EmployeeModel employee = employees[index];
        return ListTile(
          title: Text(employee.name),
          subtitle: Text(employee.designation),
          onTap: () => onTap?.call(employee),
        );
      },
    );
  }
}
