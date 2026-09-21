class AttendanceModel {
  const AttendanceModel({
    required this.id,
    required this.studentId,
    required this.date,
    required this.status,
    required this.notes,
  });

  final String id;
  final String studentId;
  final String date;
  final String status;
  final String notes;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? 'Present',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'studentId': studentId,
        'date': date,
        'status': status,
        'notes': notes,
      };

  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? date,
    String? status,
    String? notes,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
