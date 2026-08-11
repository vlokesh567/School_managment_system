import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/teacher_model.dart';
import '../providers/teacher_provider.dart';

class TeacherDetailScreen extends ConsumerWidget {
  final String teacherId;

  const TeacherDetailScreen({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final teacherAsync = ref.watch(teacherDetailProvider(teacherId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.push(AppRoutes.addTeacher),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {}, // more options not yet wired
          ),
        ],
      ),
      body: teacherAsync.when(
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Skeleton: Profile Header
              Center(
                child: Column(
                  children: [
                    const SkeletonLoader(width: 100, height: 100, borderRadius: 28),
                    const SizedBox(height: 16),
                    const SkeletonLoader(width: 180, height: 20),
                    const SizedBox(height: 8),
                    const SkeletonLoader(width: 120, height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Skeleton: Info Section 1
              _SkeletonSection(),
              const SizedBox(height: 16),
              // Skeleton: Info Section 2
              _SkeletonSection(),
              const SizedBox(height: 16),
              // Skeleton: Info Section 3
              _SkeletonSection(),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (teacher) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.2),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          teacher.initials,
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ).animate().scale(
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: 16),
                    Text(
                      teacher.fullName,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        teacher.subjects,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Personal Information
              _InfoSection(
                title: 'Personal Information',
                items: [
                  _InfoItem('Full Name', teacher.fullName),
                  _InfoItem('Qualification', teacher.qualification ?? 'N/A'),
                  _InfoItem('Employee ID', 'EMP-${teacher.id.padLeft(4, '0')}'),
                ],
                delay: 300,
              ),
              const SizedBox(height: 16),
              // Professional Details
              _InfoSection(
                title: 'Professional Details',
                items: [
                  _InfoItem('Subjects', teacher.subjects),
                  _InfoItem('Assigned Classes', teacher.assignedClasses),
                  _InfoItem('Total Students', '${teacher.studentCount}'),
                ],
                delay: 400,
              ),
              const SizedBox(height: 16),
              // Contact Information
              _InfoSection(
                title: 'Contact Information',
                items: [
                  _InfoItem('Phone', teacher.phone ?? 'N/A'),
                  _InfoItem('Email', teacher.email ?? 'N/A'),
                  _InfoItem('Address', teacher.address ?? 'N/A'),
                ],
                delay: 500,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;
  final int delay;

  const _InfoSection({
    required this.title,
    required this.items,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedCard(
      animationDelay: delay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);
}

class _SkeletonSection extends StatelessWidget {
  const _SkeletonSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(height: 16, width: 120),
          SizedBox(height: 16),
          _SkeletonRow(),
          _SkeletonRow(),
          _SkeletonRow(),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 2, child: SkeletonLoader(height: 14, width: 80)),
          const SizedBox(width: 12),
          const Expanded(flex: 3, child: SkeletonLoader(height: 14)),
        ],
      ),
    );
  }
}
