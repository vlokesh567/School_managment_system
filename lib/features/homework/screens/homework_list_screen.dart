import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/homework_model.dart';
import '../providers/homework_provider.dart';

class HomeworkListScreen extends ConsumerStatefulWidget {
  const HomeworkListScreen({super.key});

  @override
  ConsumerState<HomeworkListScreen> createState() => _HomeworkListScreenState();
}

class _HomeworkListScreenState extends ConsumerState<HomeworkListScreen> {
  String _selectedTab = 'Active';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Homework', style: AppTextStyles.headingSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push(AppRoutes.createHomework),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['Active', 'Pending', 'Submitted'].map((tab) {
                final selected = _selectedTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = tab),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        tab,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: selected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child: ref.watch(homeworkListProvider).when(
                  loading: () => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 4,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        height: 120,
                        child: SkeletonCard(),
                      ),
                    ),
                  ),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (homeworkList) {
                    final filtered = homeworkList.where((hw) {
                      if (_selectedTab == 'Active') return hw.status == 'Active';
                      if (_selectedTab == 'Pending') return hw.status == 'Pending';
                      return hw.status == 'Submitted';
                    }).toList();
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final hw = filtered[index];
                        return AnimatedCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          animationDelay: index,
                          onTap: () => context.push(AppRoutes.homeworkDetail.replaceAll(':id', hw.id)),
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
                                      color: hw.subjectColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      hw.subject,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: hw.subjectColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    hw.dueDate,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: hw.dueDate == 'Today'
                                          ? AppColors.danger
                                          : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                      fontWeight: hw.dueDate == 'Today'
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hw.title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 14,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    hw.teacher,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.people_outline_rounded,
                                    size: 14,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${hw.submissionsLabel} submitted',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: hw.submissionProgress,
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  color: hw.subjectColor,
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createHomework),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }


}
