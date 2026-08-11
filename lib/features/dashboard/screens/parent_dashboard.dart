import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/animated_card.dart';
import '../data/dashboard_mock_data.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

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
                    backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                    child: const Icon(Icons.family_restroom_rounded, color: AppColors.warning),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning 🏠', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
                        Text('Rajesh Sharma • Parent of Priya (10A)', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              // Child info card
              AnimatedCard(
                child: Row(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                      child: const Center(child: Text('PS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primary))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Priya Sharma', style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                          Text('Class 10A • Roll No. 101', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('96% Att.', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: parentDashboardStats.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final stat = parentDashboardStats[index];
                  return StatCard(title: stat.title, value: stat.value, icon: stat.icon, color: stat.color);
                },
              ),
              const SizedBox(height: 24),
              Text('Recent Updates', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              ...List.generate(3, (i) {
                final updates = [
                  {'msg': 'Math homework submitted', 'time': 'Today, 4:30 PM'},
                  {'msg': 'Science test score: 85/100', 'time': 'Yesterday'},
                  {'msg': 'Fee payment of ₹25,000 due Dec 10', 'time': '3 days ago'},
                ][i];
                return AnimatedCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  animationDelay: i,
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.notifications_rounded, size: 18, color: AppColors.info)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(updates['msg'] as String, style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface)),
                            Text(updates['time'] as String, style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
