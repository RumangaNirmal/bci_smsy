class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.department,
    required this.designation,
    required this.basicSalary,
    required this.allowances,
    required this.overtime,
    required this.deductions,
    required this.tax,
  });

  final String id;
  final String name;
  final String department;
  final String designation;
  final double basicSalary;
  final double allowances;
  final double overtime;
  final double deductions;
  final double tax;

  double get grossSalary => basicSalary + allowances + overtime;
  double get totalDeductions => deductions + tax;
  double get netSalary => grossSalary - totalDeductions;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      department: json['department'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      basicSalary: (json['basicSalary'] as num?)?.toDouble() ?? 0,
      allowances: (json['allowances'] as num?)?.toDouble() ?? 0,
      overtime: (json['overtime'] as num?)?.toDouble() ?? 0,
      deductions: (json['deductions'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'department': department,
        'designation': designation,
        'basicSalary': basicSalary,
        'allowances': allowances,
        'overtime': overtime,
        'deductions': deductions,
        'tax': tax,
      };

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? department,
    String? designation,
    double? basicSalary,
    double? allowances,
    double? overtime,
    double? deductions,
    double? tax,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      basicSalary: basicSalary ?? this.basicSalary,
      allowances: allowances ?? this.allowances,
      overtime: overtime ?? this.overtime,
      deductions: deductions ?? this.deductions,
      tax: tax ?? this.tax,
    );
  }
}
