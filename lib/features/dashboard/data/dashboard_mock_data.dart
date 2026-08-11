import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../models/dashboard_stat.dart';

final dashboardStats = [
  DashboardStat(
    title: 'Total Students',
    value: '1,250',
    icon: Icons.people_rounded,
    color: AppColors.primary,
    change: '+12%',
    isIncrease: true,
  ),
  DashboardStat(
    title: 'Teachers',
    value: '65',
    icon: Icons.person_rounded,
    color: AppColors.accent,
    change: '+5%',
    isIncrease: true,
  ),
  DashboardStat(
    title: 'Attendance',
    value: '92.5%',
    icon: Icons.check_circle_rounded,
    color: AppColors.success,
    change: '+3%',
    isIncrease: true,
  ),
  DashboardStat(
    title: 'Fee Collection',
    value: '₹2.5L',
    icon: Icons.payments_rounded,
    color: AppColors.warning,
    change: '-2%',
    isIncrease: false,
  ),
];

final teacherDashboardStats = [
  DashboardStat(
    title: 'My Classes',
    value: '5',
    icon: Icons.school_rounded,
    color: AppColors.primary,
  ),
  DashboardStat(
    title: 'Students',
    value: '185',
    icon: Icons.people_rounded,
    color: AppColors.accent,
  ),
  DashboardStat(
    title: 'Attendance',
    value: '88%',
    icon: Icons.check_circle_rounded,
    color: AppColors.warning,
  ),
  DashboardStat(
    title: 'Pending Work',
    value: '12',
    icon: Icons.pending_rounded,
    color: AppColors.danger,
  ),
];

final parentDashboardStats = [
  DashboardStat(
    title: 'Attendance',
    value: '95%',
    icon: Icons.check_circle_rounded,
    color: AppColors.success,
  ),
  DashboardStat(
    title: 'Homework',
    value: '4 Pending',
    icon: Icons.assignment_rounded,
    color: AppColors.warning,
  ),
  DashboardStat(
    title: 'Fees Due',
    value: '₹12,500',
    icon: Icons.payments_rounded,
    color: AppColors.danger,
  ),
  DashboardStat(
    title: 'Bus Status',
    value: 'On Time',
    icon: Icons.directions_bus_rounded,
    color: AppColors.primary,
  ),
];

final studentDashboardStats = [
  DashboardStat(
    title: 'Attendance',
    value: '96%',
    icon: Icons.check_circle_rounded,
    color: AppColors.success,
  ),
  DashboardStat(
    title: 'Homework',
    value: '3 Due',
    icon: Icons.assignment_rounded,
    color: AppColors.warning,
  ),
  DashboardStat(
    title: 'Upcoming Exams',
    value: '2',
    icon: Icons.quiz_rounded,
    color: AppColors.danger,
  ),
  DashboardStat(
    title: 'Rank',
    value: '#5',
    icon: Icons.emoji_events_rounded,
    color: AppColors.primary,
  ),
];

class DashboardActivity {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  const DashboardActivity({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}

final recentActivities = [
  DashboardActivity(
    title: 'New student enrolled: Priya Sharma (Class 10A)',
    time: '5 minutes ago',
    icon: Icons.person_add_rounded,
    color: AppColors.success,
  ),
  DashboardActivity(
    title: 'Fee payment received: ₹25,000 from Ravi Kumar',
    time: '15 minutes ago',
    icon: Icons.payments_rounded,
    color: AppColors.primary,
  ),
  DashboardActivity(
    title: 'Attendance marked for Class 8B - 42/45 present',
    time: '1 hour ago',
    icon: Icons.check_circle_rounded,
    color: AppColors.info,
  ),
  DashboardActivity(
    title: 'Homework assignment created by Mrs. Sharma',
    time: '2 hours ago',
    icon: Icons.assignment_rounded,
    color: AppColors.accent,
  ),
  DashboardActivity(
    title: 'Transport route #4 delay reported - ETA 10 mins',
    time: '3 hours ago',
    icon: Icons.directions_bus_rounded,
    color: AppColors.warning,
  ),
];
