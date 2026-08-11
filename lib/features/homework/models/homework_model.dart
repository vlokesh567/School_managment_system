import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class HomeworkModel {
  final String id;
  final String title;
  final String subject;
  final String teacher;
  final String studentClass;
  final String dueDate;
  final String status; // Active, Pending, Submitted
  final int submittedCount;
  final int totalCount;
  final String? description;
  final Color subjectColor;

  HomeworkModel({
    required this.id,
    required this.title,
    required this.subject,
    this.teacher = '',
    this.studentClass = '',
    this.dueDate = '',
    this.status = 'Active',
    this.submittedCount = 0,
    this.totalCount = 1,
    this.description,
    this.subjectColor = AppColors.primary,
  });

  double get submissionProgress =>
      totalCount > 0 ? submittedCount / totalCount : 0;

  String get submissionsLabel => '$submittedCount/$totalCount';

  static Color colorForSubject(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
        return AppColors.danger;
      case 'science':
        return AppColors.success;
      case 'english':
        return AppColors.info;
      case 'geography':
        return AppColors.accent;
      case 'hindi':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    final subject = json['subject'] as String? ?? '';
    final color =
        json['subject_color'] != null
            ? Color(json['subject_color'] as int)
            : colorForSubject(subject);
    return HomeworkModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      subject: subject,
      teacher: json['teacher'] as String? ?? '',
      studentClass: json['class'] as String? ?? '',
      dueDate: json['due_date'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
      submittedCount: (json['submitted_count'] as num?)?.toInt() ?? 0,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 1,
      description: json['description'] as String?,
      subjectColor: color,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'teacher': teacher,
        'class': studentClass,
        'due_date': dueDate,
        'status': status,
        'submitted_count': submittedCount,
        'total_count': totalCount,
        'description': description,
        'subject_color': subjectColor.value,
      };
}
