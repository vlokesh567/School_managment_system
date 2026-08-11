import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/animated_card.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stats = [
      {'title': 'Total Schools', 'value': '12', 'icon': Icons.school_rounded, 'color': AppColors.accent},
      {'title': 'Total Students', 'value': '8,450', 'icon': Icons.people_rounded, 'color': AppColors.primary},
      {'title': 'Total Teachers', 'value': '520', 'icon': Icons.person_rounded, 'color': AppColors.success},
      {'title': 'Revenue (MTD)', 'value': '₹18.2L', 'icon': Icons.trending_up_rounded, 'color': AppColors.warning},
    ];

    final schools = [
      {'name': 'Springdale International', 'students': '1,250', 'revenue': '₹2.5L', 'status': 'Active'},
      {'name': 'Sunrise Public School', 'students': '890', 'revenue': '₹1.8L', 'status': 'Active'},
      {'name': 'Green Valley Academy', 'students': '720', 'revenue': '₹1.2L', 'status': 'Active'},
      {'name': 'Little Stars School', 'students': '450', 'revenue': '₹0.8L', 'status': 'Pending'},
    ];

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
                    backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning 🌟', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
                        Text('Super Admin • Platform Overview', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final s = stats[index];
                  return StatCard(title: s['title'] as String, value: s['value'] as String, icon: s['icon'] as IconData, color: s['color'] as Color);
                },
              ),
              const SizedBox(height: 24),
              Text('Managed Schools', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              ...schools.asMap().entries.map((entry) {
                final s = entry.value;
                final status = s['status'] as String;
                final isActive = status == 'Active';
                return AnimatedCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  animationDelay: entry.key,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.school_rounded, color: AppColors.accent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['name'] as String, style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                            Text('${s['students']} students • ${s['revenue']} revenue', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: (isActive ? AppColors.success : AppColors.warning).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: isActive ? AppColors.success : AppColors.warning, fontWeight: FontWeight.w600)),
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
