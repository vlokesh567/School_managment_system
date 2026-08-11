import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final Map<int, String> _attendance = {};

  final List<Map<String, dynamic>> _students = List.generate(
    15,
    (i) => {
      'name': 'Student ${i + 1}',
      'roll': '${i + 101}',
      'class': '10A',
    },
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mark Attendance',
          style: AppTextStyles.headingSmall,
        ),
        actions: [
          TextButton(
            onPressed: _saveAttendance,
            child: const Text('Save All'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class 10A',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${_students.length} students • ${DateTime.now().toString().split(' ')[0]}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _QuickAction(
                      label: 'All Present',
                      color: AppColors.success,
                      onTap: () {
                        setState(() {
                          for (var i = 0; i < _students.length; i++) {
                            _attendance[i] = 'Present';
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _QuickAction(
                      label: 'All Absent',
                      color: AppColors.danger,
                      onTap: () {
                        setState(() {
                          for (var i = 0; i < _students.length; i++) {
                            _attendance[i] = 'Absent';
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                final status = _attendance[index] ?? 'Present';
                final isPresent = status == 'Present';
                final isAbsent = status == 'Absent';
                final isLate = status == 'Late';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isPresent
                        ? AppColors.success.withValues(alpha: 0.05)
                        : isAbsent
                            ? AppColors.danger.withValues(alpha: 0.05)
                            : AppColors.warning.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: (isPresent
                              ? AppColors.success
                              : isAbsent
                                  ? AppColors.danger
                                  : AppColors.warning)
                          .withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        student['roll'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          student['name'],
                          style: AppTextStyles.titleMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      _StatusButton(
                        label: 'P',
                        selected: isPresent,
                        color: AppColors.success,
                        onTap: () => _updateStatus(index, 'Present'),
                      ),
                      const SizedBox(width: 4),
                      _StatusButton(
                        label: 'L',
                        selected: isLate,
                        color: AppColors.warning,
                        onTap: () => _updateStatus(index, 'Late'),
                      ),
                      const SizedBox(width: 4),
                      _StatusButton(
                        label: 'A',
                        selected: isAbsent,
                        color: AppColors.danger,
                        onTap: () => _updateStatus(index, 'Absent'),
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                      duration: 200.ms,
                      delay: (index * 30).ms,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(int index, String status) {
    setState(() {
      _attendance[index] = _attendance[index] == status ? 'Present' : status;
    });
  }

  Future<void> _saveAttendance() async {
    final present = _attendance.values.where((s) => s == 'Present').length;
    final absent = _attendance.values.where((s) => s == 'Absent').length;
    final late = _attendance.values.where((s) => s == 'Late').length;
    final total = _students.length;
    final marked = _attendance.length;

    if (marked < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please mark all $total students before saving'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Simulate saving
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text('Saved: $present Present, $absent Absent, $late Late'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) context.pop();
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: selected ? Colors.white : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
