class PayrollModel {
  const PayrollModel({
    required this.employeeId,
    required this.basicSalary,
    required this.allowances,
    required this.overtime,
    required this.deductions,
    required this.tax,
    required this.grossSalary,
    required this.netSalary,
  });

  final String employeeId;
  final double basicSalary;
  final double allowances;
  final double overtime;
  final double deductions;
  final double tax;
  final double grossSalary;
  final double netSalary;

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      employeeId: json['employeeId'] as String? ?? '',
      basicSalary: (json['basicSalary'] as num?)?.toDouble() ?? 0,
      allowances: (json['allowances'] as num?)?.toDouble() ?? 0,
      overtime: (json['overtime'] as num?)?.toDouble() ?? 0,
      deductions: (json['deductions'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      grossSalary: (json['grossSalary'] as num?)?.toDouble() ?? 0,
      netSalary: (json['netSalary'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'employeeId': employeeId,
        'basicSalary': basicSalary,
        'allowances': allowances,
        'overtime': overtime,
        'deductions': deductions,
        'tax': tax,
        'grossSalary': grossSalary,
        'netSalary': netSalary,
      };

  PayrollModel copyWith({
    String? employeeId,
    double? basicSalary,
    double? allowances,
    double? overtime,
    double? deductions,
    double? tax,
    double? grossSalary,
    double? netSalary,
  }) {
    return PayrollModel(
      employeeId: employeeId ?? this.employeeId,
      basicSalary: basicSalary ?? this.basicSalary,
      allowances: allowances ?? this.allowances,
      overtime: overtime ?? this.overtime,
      deductions: deductions ?? this.deductions,
      tax: tax ?? this.tax,
      grossSalary: grossSalary ?? this.grossSalary,
      netSalary: netSalary ?? this.netSalary,
    );
  }
}
