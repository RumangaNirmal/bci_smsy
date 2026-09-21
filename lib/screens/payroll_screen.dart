import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/services/formatting_service.dart';
import '../core/validators/validators.dart';
import '../core/widgets/app_buttons.dart';
import '../core/widgets/app_text_field.dart';
import '../models/employee.dart';
import '../state/bci_store.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key, required this.store});

  final BciStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: <Widget>[
          Text(
            AppStrings.payrollManagement,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.payrollSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.payments_outlined, size: 38),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Total Net Payroll'),
                        Text(
                          FormattingService.formatMoney(store.monthlyPayrollTotal),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...store.employees.map(
            (Employee employee) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ExpansionTile(
                  leading: const CircleAvatar(child: Icon(Icons.badge_outlined)),
                  title: Text(
                    employee.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${employee.id} • ${employee.designation}\n${employee.department}',
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  children: <Widget>[
                    _SalaryRow(label: 'Basic Salary', value: employee.basicSalary),
                    _SalaryRow(label: 'Allowances', value: employee.allowances),
                    _SalaryRow(label: 'Overtime', value: employee.overtime),
                    const Divider(),
                    _SalaryRow(
                      label: 'Gross Salary',
                      value: employee.grossSalary,
                      bold: true,
                    ),
                    _SalaryRow(label: 'Other Deductions', value: employee.deductions),
                    _SalaryRow(label: 'Tax', value: employee.tax),
                    const Divider(),
                    _SalaryRow(
                      label: 'Net Salary',
                      value: employee.netSalary,
                      bold: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        label: 'Remove Employee',
                        icon: Icons.delete_outline,
                        onPressed: () => _confirmDelete(context, employee),
                        fill: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: PrimaryButton(
        onPressed: () => _showAddEmployeeDialog(context),
        icon: Icons.person_add_alt_1,
        label: AppStrings.addEmployee,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Employee employee) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove employee'),
        content: Text('Remove ${employee.name} and the payroll record?'),
        actions: <Widget>[
          AppButton(label: AppStrings.cancel, onPressed: () => Navigator.pop(context, false), fill: false),
          AppButton(label: AppStrings.remove, onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    if (confirmed == true) {
      store.removeEmployee(employee.id);
    }
  }

  Future<void> _showAddEmployeeDialog(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController id = TextEditingController();
    final TextEditingController name = TextEditingController();
    final TextEditingController department = TextEditingController();
    final TextEditingController designation = TextEditingController();
    final TextEditingController basic = TextEditingController();
    final TextEditingController allowances = TextEditingController(text: '0');
    final TextEditingController overtime = TextEditingController(text: '0');
    final TextEditingController deductions = TextEditingController(text: '0');
    final TextEditingController tax = TextEditingController(text: '0');

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Add Employee and Payroll'),
        content: SizedBox(
          width: 520,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _TextEntry(controller: id, label: 'Employee ID'),
                  _TextEntry(controller: name, label: 'Full Name'),
                  _TextEntry(controller: department, label: 'Department'),
                  _TextEntry(controller: designation, label: 'Designation'),
                  _TextEntry(
                    controller: basic,
                    label: 'Basic Salary (LKR)',
                    numeric: true,
                  ),
                  _TextEntry(
                    controller: allowances,
                    label: 'Allowances (LKR)',
                    numeric: true,
                  ),
                  _TextEntry(
                    controller: overtime,
                    label: 'Overtime (LKR)',
                    numeric: true,
                  ),
                  _TextEntry(
                    controller: deductions,
                    label: 'Other Deductions (LKR)',
                    numeric: true,
                  ),
                  _TextEntry(
                    controller: tax,
                    label: 'Tax (LKR)',
                    numeric: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          AppButton(label: AppStrings.cancel, onPressed: () => Navigator.pop(dialogContext), fill: false),
          AppButton(
            label: 'Calculate and Save',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                store.addEmployee(
                  Employee(
                    id: id.text.trim(),
                    name: name.text.trim(),
                    department: department.text.trim(),
                    designation: designation.text.trim(),
                    basicSalary: double.parse(basic.text.trim()),
                    allowances: double.parse(allowances.text.trim()),
                    overtime: double.parse(overtime.text.trim()),
                    deductions: double.parse(deductions.text.trim()),
                    tax: double.parse(tax.text.trim()),
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
          ),
        ],
      ),
    );

    for (final TextEditingController controller in <TextEditingController>[
      id,
      name,
      department,
      designation,
      basic,
      allowances,
      overtime,
      deductions,
      tax,
    ]) {
      controller.dispose();
    }
  }

}

class _SalaryRow extends StatelessWidget {
  const _SalaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = bold
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            )
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: style)),
          Text(FormattingService.formatMoney(value), style: style),
        ],
      ),
    );
  }
}

class _TextEntry extends StatelessWidget {
  const _TextEntry({
    required this.controller,
    required this.label,
    this.numeric = false,
  });

  final TextEditingController controller;
  final String label;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField(
        controller: controller,
        label: label,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: (String? value) {
          final String? requiredMessage = requiredValidator(value, fieldName: label);
          if (requiredMessage != null) {
            return requiredMessage;
          }
          if (numeric && double.tryParse(value!.trim()) == null) {
            return 'Enter a valid numerical amount.';
          }
          return null;
        },
      ),
    );
  }
}
