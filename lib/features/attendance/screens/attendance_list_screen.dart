import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/attendance_model.dart';
import '../providers/attendance_provider.dart';

class AttendanceListScreen extends ConsumerStatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  ConsumerState<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends ConsumerState<AttendanceListScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final recordsAsync = ref.watch(attendanceListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance', style: AppTextStyles.headingSmall),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_rounded, size: 18),
            label: const Text('Today'),
          ),
        ],
      ),
      body: recordsAsync.when(
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(children: [
                const Expanded(child: SkeletonLoader(height: 96, borderRadius: 16)),
                const SizedBox(width: 12),
                const Expanded(child: SkeletonLoader(height: 96, borderRadius: 16)),
                const SizedBox(width: 12),
                const Expanded(child: SkeletonLoader(height: 96, borderRadius: 16)),
              ]),
              const SizedBox(height: 20),
              const SkeletonLoader(height: 40, borderRadius: 8),
              const SizedBox(height: 16),
              const SkeletonLoader(height: 48, borderRadius: 12),
              const SizedBox(height: 20),
              ...List.generate(6, (_) => const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: SkeletonListTile(),
              )),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (records) {
          final filtered = records.where((r) {
            if (_selectedFilter == 'All') return true;
            return r.status.label == _selectedFilter;
          }).toList();
          final presentCount = records.where((r) => r.status == AttendanceStatus.present).length;
          final absentCount = records.where((r) => r.status == AttendanceStatus.absent).length;
          final lateCount = records.where((r) => r.status == AttendanceStatus.late).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    _SummaryCard(
                      label: 'Present',
                      value: '$presentCount',
                      color: AppColors.success,
                      icon: Icons.check_circle_rounded,
                    ).animate().fadeIn(duration: 300.ms, delay: 0.ms),
                    const SizedBox(width: 12),
                    _SummaryCard(
                      label: 'Absent',
                      value: '$absentCount',
                      color: AppColors.danger,
                      icon: Icons.cancel_rounded,
                    ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                    const SizedBox(width: 12),
                    _SummaryCard(
                      label: 'Late',
                      value: '$lateCount',
                      color: AppColors.warning,
                      icon: Icons.access_time_rounded,
                    ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                  ],
                ),
                const SizedBox(height: 20),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Present', 'Absent', 'Late'].map((filter) {
                      final selected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: selected,
                          onSelected: (v) {
                            setState(() => _selectedFilter = filter);
                          },
                          selectedColor:
                              theme.colorScheme.primary.withValues(alpha: 0.15),
                          checkmarkColor: theme.colorScheme.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 250.ms),
                const SizedBox(height: 16),
                // Mark Attendance Button
            AppButton(
              title: 'Mark Today\'s Attendance',
              icon: Icons.edit_rounded,
              onTap: () => context.push(AppRoutes.markAttendance),
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                const SizedBox(height: 20),
                // Attendance List
                ...filtered.asMap().entries.map((entry) {
                  final record = entry.value;
                  final statusLabel = record.status.label;
                  final statusColor = record.status == AttendanceStatus.present
                      ? AppColors.success
                      : record.status == AttendanceStatus.absent
                          ? AppColors.danger
                          : AppColors.warning;
                  return AnimatedCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    animationDelay: entry.key + 4,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            record.status == AttendanceStatus.present
                                ? Icons.check_circle_rounded
                                : record.status == AttendanceStatus.absent
                                    ? Icons.cancel_rounded
                                    : Icons.access_time_rounded,
                            color: statusColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.studentName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Class ${record.studentClass}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$statusLabel · ${record.time}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.headingMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
