import 'package:flutter/material.dart';

class DashboardStat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? change;
  final bool isIncrease;

  DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.blue,
    this.change,
    this.isIncrease = true,
  });
}
