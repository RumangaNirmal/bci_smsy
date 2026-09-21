import 'package:flutter/material.dart';

import '../../models/payroll_model.dart';

class PayrollSummaryView extends StatelessWidget {
  const PayrollSummaryView({
    super.key,
    required this.payroll,
  });

  final PayrollModel payroll;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Payroll Summary'),
            const SizedBox(height: 8),
            Text('Gross Salary: LKR ${payroll.grossSalary.toStringAsFixed(2)}'),
            Text('Net Salary: LKR ${payroll.netSalary.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
