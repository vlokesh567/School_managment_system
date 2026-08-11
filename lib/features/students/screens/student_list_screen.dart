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
import '../../../core/widgets/empty_state.dart';
import '../models/student_model.dart';
import '../providers/student_provider.dart';

class StudentListScreen extends ConsumerStatefulWidget {
  const StudentListScreen({super.key});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  final _searchController = TextEditingController();
  String? _selectedClass;
  String? _selectedSection;

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
          'Students',
          style: AppTextStyles.headingSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push(AppRoutes.addStudent),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: AppTextField(
              hint: 'Search students...',
              controller: _searchController,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
          // Loading, Empty, Data — reactive via provider
          ref.watch(studentListProvider).when(
                loading: () => Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 6,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const SkeletonLoader(
                            width: 52,
                            height: 52,
                            borderRadius: 16,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLoader(
                                  height: 14,
                                  width: 150 + (index * 10).toDouble(),
                                ),
                                const SizedBox(height: 8),
                                const SkeletonLoader(
                                  height: 12,
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const SkeletonLoader(
                            width: 50,
                            height: 28,
                            borderRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                error: (e, _) => Expanded(
                  child: Center(child: Text('Error: $e')),
                ),
                data: (students) => students.isEmpty
                    ? const Expanded(
                        child: EmptyState(
                          icon: Icons.people_rounded,
                          title: 'No students found',
                          subtitle: 'Try adjusting your search or filters',
                          actionLabel: 'Add Student',
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return _StudentTile(
                              student: student,
                              index: index,
                              onTap: () => context.push(
                                AppRoutes.studentDetail.replaceAll(':id', student.id),
                              ),
                            );
                          },
                        ),
                      ),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addStudent),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Students',
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: const InputDecoration(
                labelText: 'Class',
                filled: true,
                border: OutlineInputBorder(),
              ),
              items: ['9A', '9B', '10A', '10B']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                setState(() => _selectedClass = v);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSection,
              decoration: const InputDecoration(
                labelText: 'Section',
                filled: true,
                border: OutlineInputBorder(),
              ),
              items: ['A', 'B']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) {
                setState(() => _selectedSection = v);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedClass = null;
                  _selectedSection = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final StudentModel student;
  final int index;
  final VoidCallback onTap;

  const _StudentTile({
    required this.student,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceNum = student.attendancePercent;
    final color = attendanceNum >= 90
        ? AppColors.success
        : attendanceNum >= 75
            ? AppColors.warning
            : AppColors.danger;

    return AnimatedCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      animationDelay: index,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                student.initials,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
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
                Text(                    student.fullName,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                ),
                const SizedBox(height: 4),
                Text(                    'Class ${student.studentClass} • Roll No. ${student.rollNumber}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${student.attendancePercent.toStringAsFixed(0)}%',
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
