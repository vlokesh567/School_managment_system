import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../providers/exam_provider.dart';

class ExamListScreen extends ConsumerWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final examsAsync = ref.watch(examListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Examinations', style: AppTextStyles.headingSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: examsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 4,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: List.generate(3, (_) => const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: SkeletonLoader(height: 64, borderRadius: 16),
                    ),
                  )),
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: SkeletonCard(),
            );
          },
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (exams) {
          final upcoming = exams.where((e) => e.status == 'Upcoming').length;
          final ongoing = exams.where((e) => e.status == 'Ongoing').length;
          final completed = exams.where((e) => e.status == 'Completed').length;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: exams.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ExamStatCard(
                          label: 'Upcoming',
                          value: '$upcoming',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ExamStatCard(
                          label: 'Ongoing',
                          value: '$ongoing',
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ExamStatCard(
                          label: 'Completed',
                          value: '$completed',
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                );
              }
              final exam = exams[index - 1];
              return AnimatedCard(
                margin: const EdgeInsets.only(bottom: 12),
                animationDelay: index,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (exam.status == 'Upcoming'
                                    ? AppColors.primary
                                    : AppColors.warning)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            exam.status,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: exam.status == 'Upcoming'
                                  ? AppColors.primary
                                  : AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          exam.classes,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      exam.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range_rounded,
                          size: 14,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${exam.startDate} - ${exam.endDate}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _ExamStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ExamStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
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
    );
  }
}
