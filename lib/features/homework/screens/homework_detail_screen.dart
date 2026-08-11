import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../app/routes/app_router.dart';
import '../models/homework_model.dart';
import '../providers/homework_provider.dart';

class HomeworkDetailScreen extends ConsumerWidget {
  final String homeworkId;

  const HomeworkDetailScreen({super.key, required this.homeworkId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final homeworkAsync = ref.watch(homeworkDetailProvider(homeworkId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.push(AppRoutes.createHomework),
          ),
        ],
      ),
      body: homeworkAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (hw) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Card
              AnimatedCard(
                animationDelay: 0,
                child: Column(
                  children: [
                    // Subject badge & status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: hw.subjectColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hw.subject,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: hw.subjectColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _StatusBadge(status: hw.status, color: hw.subjectColor),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      hw.title,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Info row: teacher, class, due date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoChip(
                          icon: Icons.person_outline_rounded,
                          label: hw.teacher,
                          theme: theme,
                        ),
                        _InfoChip(
                          icon: Icons.class_rounded,
                          label: hw.studentClass,
                          theme: theme,
                        ),
                        _InfoChip(
                          icon: Icons.calendar_today_rounded,
                          label: hw.dueDate,
                          theme: theme,
                          isUrgent: hw.dueDate == 'Today',
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut),

              const SizedBox(height: 16),

              // Description
              if (hw.description != null && hw.description!.isNotEmpty)
                AnimatedCard(
                  animationDelay: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        hw.description!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, curve: Curves.easeOut),

              if (hw.description != null && hw.description!.isNotEmpty)
                const SizedBox(height: 16),

              // Submission Progress
              AnimatedCard(
                animationDelay: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Submission Progress',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hw.submissionsLabel,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: hw.subjectColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: hw.submissionProgress,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        color: hw.subjectColor,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(hw.submissionProgress * 100).toInt()}% complete',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          '${hw.totalCount - hw.submittedCount} remaining',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: hw.dueDate == 'Today'
                                ? AppColors.danger
                                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Status breakdown
                    Row(
                      children: [
                        _ProgressStat(
                          label: 'Submitted',
                          value: hw.submittedCount,
                          color: AppColors.success,
                          theme: theme,
                        ),
                        const SizedBox(width: 16),
                        _ProgressStat(
                          label: 'Pending',
                          value: hw.totalCount - hw.submittedCount,
                          color: AppColors.warning,
                          theme: theme,
                        ),
                        const SizedBox(width: 16),
                        _ProgressStat(
                          label: 'Total',
                          value: hw.totalCount,
                          color: theme.colorScheme.primary,
                          theme: theme,
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, curve: Curves.easeOut),

              const SizedBox(height: 16),

              // Assignment Details
              AnimatedCard(
                animationDelay: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assignment Details',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(label: 'Subject', value: hw.subject, theme: theme),
                    _DetailRow(label: 'Teacher', value: hw.teacher, theme: theme),
                    _DetailRow(label: 'Class', value: hw.studentClass, theme: theme),
                    _DetailRow(label: 'Due Date', value: hw.dueDate, theme: theme),
                    _DetailRow(label: 'Status', value: hw.status, theme: theme),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1, curve: Curves.easeOut),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = switch (status) {
      'Active' => (AppColors.info.withValues(alpha: 0.1), AppColors.info),
      'Pending' => (AppColors.warning.withValues(alpha: 0.1), AppColors.warning),
      'Submitted' => (AppColors.success.withValues(alpha: 0.1), AppColors.success),
      _ => (color.withValues(alpha: 0.1), color),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final bool isUrgent;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.theme,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: isUrgent
              ? AppColors.danger
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isUrgent
                ? AppColors.danger
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isUrgent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final ThemeData theme;

  const _ProgressStat({
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: AppTextStyles.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
