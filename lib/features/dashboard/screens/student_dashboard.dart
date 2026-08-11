import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/animated_card.dart';
import '../data/dashboard_mock_data.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.danger.withValues(alpha: 0.1),
                    child: const Icon(Icons.school_rounded, color: AppColors.danger),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning 📚', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
                        Text('Priya Sharma • Class 10A', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: studentDashboardStats.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final stat = studentDashboardStats[index];
                  return StatCard(title: stat.title, value: stat.value, icon: stat.icon, color: stat.color);
                },
              ),
              const SizedBox(height: 24),
              Text('Today\'s Homework', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              ...List.generate(3, (i) {
                final hw = [
                  {'subject': 'Mathematics', 'title': 'Algebra Practice - Ex 5.2', 'due': 'Tomorrow'},
                  {'subject': 'Science', 'title': 'Draw plant cell diagram', 'due': 'Friday'},
                  {'subject': 'English', 'title': 'Essay: Climate Change', 'due': 'Next Monday'},
                ][i];
                final colors = [AppColors.danger, AppColors.success, AppColors.info];
                return AnimatedCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  animationDelay: i,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: colors[i].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(hw['subject'] as String, style: AppTextStyles.labelSmall.copyWith(color: colors[i], fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hw['title'] as String, style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface)),
                            Text('Due: ${hw['due'] as String}', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              // Upcoming exams
              Text('Upcoming Exams', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              AnimatedCard(
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.quiz_rounded, color: AppColors.danger, size: 24)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mid-Term Examinations', style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                          Text('15 Dec - 25 Dec', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text('12 days left', style: AppTextStyles.labelSmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
