import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/animated_card.dart';
import '../data/dashboard_mock_data.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

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
                    backgroundColor: AppColors.success.withValues(alpha: 0.1),
                    child: const Icon(Icons.person_rounded, color: AppColors.success),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning ☕', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
                        Text('Mrs. Ananya Sharma • Mathematics', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teacherDashboardStats.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final stat = teacherDashboardStats[index];
                  return StatCard(title: stat.title, value: stat.value, icon: stat.icon, color: stat.color);
                },
              ),
              const SizedBox(height: 24),
              Text('Today\'s Schedule', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              ...List.generate(3, (i) {
                final periods = [
                  {'subject': 'Mathematics', 'class': '10A', 'time': '08:00 - 08:45'},
                  {'subject': 'Mathematics', 'class': '10B', 'time': '09:45 - 10:30'},
                  {'subject': 'Science (Combined)', 'class': '10A & 10B', 'time': '11:15 - 12:00'},
                ][i];
                return AnimatedCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  animationDelay: i,
                  child: Row(
                    children: [
                      Container(
                        width: 4, height: 40,
                        decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(2)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(periods['subject'] as String, style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                            Text('Class ${periods['class'] as String}', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                          ],
                        ),
                      ),
                      Text(periods['time'] as String, style: AppTextStyles.labelMedium),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              Text('Recent Activity', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              ...recentActivities.take(3).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: a.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(a.icon, size: 18, color: a.color)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(a.title, style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface))),
                  ],
                ),
              )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
