import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final String type; // fee, attendance, homework, announcement, exam, transport
  final bool isUnread;

  NotificationModel({
    required this.id,
    required this.title,
    this.message = '',
    this.time = '',
    this.type = 'announcement',
    this.isUnread = false,
  });

  IconData get icon {
    switch (type) {
      case 'fee':
        return Icons.payments_rounded;
      case 'attendance':
        return Icons.check_circle_rounded;
      case 'homework':
        return Icons.assignment_rounded;
      case 'announcement':
        return Icons.campaign_rounded;
      case 'exam':
        return Icons.quiz_rounded;
      case 'transport':
        return Icons.directions_bus_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (type) {
      case 'fee':
        return AppColors.warning;
      case 'attendance':
        return AppColors.primary;
      case 'homework':
        return AppColors.accent;
      case 'announcement':
        return AppColors.danger;
      case 'exam':
        return AppColors.success;
      case 'transport':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      time: json['time'] as String? ?? '',
      type: json['type'] as String? ?? 'announcement',
      isUnread: json['is_unread'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'time': time,
        'type': type,
        'is_unread': isUnread,
      };
}
