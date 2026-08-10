class Course {
  const Course({
    required this.id,
    required this.code,
    required this.name,
    required this.credits,
    required this.description,
    required this.status,
  });

  final String id;
  final String code;
  final String name;
  final int credits;
  final String description;
  final String status;

  Course copyWith({
    String? id,
    String? code,
    String? name,
    int? credits,
    String? description,
    String? status,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
