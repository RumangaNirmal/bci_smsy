class StudentModel {
  const StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.program,
    required this.intake,
    required this.status,
  });

  final String id;
  final String name;
  final String email;
  final String program;
  final String intake;
  final String status;

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      program: json['program'] as String? ?? '',
      intake: json['intake'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'program': program,
        'intake': intake,
        'status': status,
      };

  StudentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? program,
    String? intake,
    String? status,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      program: program ?? this.program,
      intake: intake ?? this.intake,
      status: status ?? this.status,
    );
  }
}
