import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class EventModel {
  final String id;
  final String title;
  final String date;
  final String type; // Event, Meeting, Holiday, Celebration
  final String description;
  final Color color;

  EventModel({
    required this.id,
    required this.title,
    this.date = '',
    this.type = 'Event',
    this.description = '',
    this.color = AppColors.primary,
  });

  String get day => date.split(' ').isNotEmpty ? date.split(' ')[0] : date;
  String get month => date.split(' ').length > 1 ? date.split(' ')[1] : '';

  static Color colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'event':
        return AppColors.primary;
      case 'meeting':
        return AppColors.accent;
      case 'holiday':
        return AppColors.success;
      case 'celebration':
        return AppColors.danger;
      default:
        return AppColors.primary;
    }
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'Event';
    final color = json['color'] != null
        ? Color(json['color'] as int)
        : colorForType(type);
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      type: type,
      description: json['description'] as String? ?? '',
      color: color,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'type': type,
        'description': description,
        'color': color.value,
      };
}
