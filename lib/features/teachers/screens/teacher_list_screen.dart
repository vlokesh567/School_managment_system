import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/teacher_model.dart';
import '../providers/teacher_provider.dart';

class TeacherListScreen extends ConsumerStatefulWidget {
  const TeacherListScreen({super.key});

  @override
  ConsumerState<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends ConsumerState<TeacherListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teachers',
          style: AppTextStyles.headingSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push(AppRoutes.addTeacher),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: AppTextField(
              hint: 'Search teachers...',
              controller: _searchController,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
            ),
          ),
          Expanded(
            child: ref.watch(teacherListProvider).when(
                  loading: () => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 4,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const SkeletonLoader(width: 52, height: 52, borderRadius: 16),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SkeletonLoader(height: 14, width: 180),
                                const SizedBox(height: 8),
                                const SkeletonLoader(height: 12, width: 120),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (teachers) => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = teachers[index];
                      return AnimatedCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        animationDelay: index,
                        onTap: () => context.push(
                              AppRoutes.teacherDetail.replaceAll(':id', teacher.id),
                            ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  teacher.initials,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacher.fullName,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    teacher.subjects,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${teacher.studentCount} students',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addTeacher),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
