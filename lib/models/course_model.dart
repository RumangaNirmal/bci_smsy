class CourseModel {
  const CourseModel({
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

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'code': code,
        'name': name,
        'credits': credits,
        'description': description,
        'status': status,
      };

  CourseModel copyWith({
    String? id,
    String? code,
    String? name,
    int? credits,
    String? description,
    String? status,
  }) {
    return CourseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
