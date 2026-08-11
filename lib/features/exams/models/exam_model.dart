class ExamModel {
  final String id;
  final String title;
  final String startDate;
  final String endDate;
  final String status; // Upcoming, Ongoing, Completed, Planning
  final String classes;
  final String? description;

  ExamModel({
    required this.id,
    required this.title,
    this.startDate = '',
    this.endDate = '',
    this.status = 'Upcoming',
    this.classes = '',
    this.description,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      status: json['status'] as String? ?? 'Upcoming',
      classes: json['classes'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
        'classes': classes,
        'description': description,
      };
}

class MarksEntry {
  final String studentId;
  final String studentName;
  final int marks;
  final int maxMarks;
  final String? examId;

  MarksEntry({
    required this.studentId,
    required this.studentName,
    this.marks = 0,
    this.maxMarks = 100,
    this.examId,
  });

  bool get isPassing => marks >= maxMarks * 0.35;
  double get percentage => maxMarks > 0 ? marks / maxMarks * 100 : 0;

  factory MarksEntry.fromJson(Map<String, dynamic> json) {
    return MarksEntry(
      studentId: json['student_id']?.toString() ?? '',
      studentName: json['student_name'] as String? ?? '',
      marks: (json['marks'] as num?)?.toInt() ?? 0,
      maxMarks: (json['max_marks'] as num?)?.toInt() ?? 100,
      examId: json['exam_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'student_name': studentName,
        'marks': marks,
        'max_marks': maxMarks,
        'exam_id': examId,
      };
}
