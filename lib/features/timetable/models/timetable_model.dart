import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class TimetableEntry {
  final String subject;
  final String teacher;
  final String time;
  final String room;
  final bool isBreak;
  final Color color;

  TimetableEntry({
    required this.subject,
    this.teacher = '',
    this.time = '',
    this.room = '',
    this.isBreak = false,
    this.color = AppColors.primary,
  });

  static Color _colorForSubject(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
        return AppColors.danger;
      case 'science':
      case 'science (lab)':
        return AppColors.success;
      case 'english':
        return AppColors.info;
      case 'hindi':
        return AppColors.warning;
      case 'geography':
      case 'moral science':
        return AppColors.accent;
      case 'history':
        return AppColors.primary;
      case 'art & craft':
      case 'library':
        return AppColors.accentLight;
      case 'computer science':
        return AppColors.infoLight;
      case 'physical education':
      case 'sports':
        return AppColors.accent;
      default:
        return AppColors.primary;
    }
  }

  factory TimetableEntry.fromJson(Map<String, dynamic> json) {
    final subject = json['subject'] as String? ?? '';
    final color =
        json['color'] != null
            ? Color(json['color'] as int)
            : _colorForSubject(subject);
    return TimetableEntry(
      subject: subject,
      teacher: json['teacher'] as String? ?? '',
      time: json['time'] as String? ?? '',
      room: json['room'] as String? ?? '',
      isBreak: json['is_break'] as bool? ?? false,
      color: color,
    );
  }

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'teacher': teacher,
        'time': time,
        'room': room,
        'is_break': isBreak,
        'color': color.value,
      };
}

class TimetableDay {
  final String day; // Mon, Tue, etc.
  final List<TimetableEntry> entries;

  TimetableDay({required this.day, this.entries = const []});
}
