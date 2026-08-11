import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({super.key});

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
                    backgroundColor: AppColors.info.withValues(alpha: 0.1),
                    child: const Icon(Icons.directions_bus_rounded, color: AppColors.info),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning 🚌', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
                        Text('Rajesh Kumar • Bus D (Route #4)', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 16),
              // Status card
              AnimatedCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.play_circle_rounded, color: AppColors.success, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Route #4 - West', style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                          Text('25 students • All stops active', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text('Active', style: AppTextStyles.labelMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        const Icon(Icons.people_rounded, color: AppColors.primary, size: 24),
                        const SizedBox(height: 8),
                        Text('22', style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface)),
                        Text('Picked Up', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        const Icon(Icons.schedule_rounded, color: AppColors.warning, size: 24),
                        const SizedBox(height: 8),
                        Text('3', style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface)),
                        Text('Pending', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        const Icon(Icons.flag_rounded, color: AppColors.success, size: 24),
                        const SizedBox(height: 8),
                        Text('08:45', style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface)),
                        Text('ETA School', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ]),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: 24),
              Text('Upcoming Stops', style: AppTextStyles.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              ...List.generate(4, (i) {
                final stops = [
                  {'name': 'Green Valley', 'students': 5, 'eta': '2 min'},
                  {'name': 'Lake View', 'students': 8, 'eta': '8 min'},
                  {'name': 'Park Avenue', 'students': 6, 'eta': '15 min'},
                  {'name': 'Springdale School', 'students': 0, 'eta': '20 min'},
                ][i];
                final isNext = i == 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isNext ? AppColors.primary.withValues(alpha: 0.05) : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isNext ? AppColors.primary.withValues(alpha: 0.3) : theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(color: isNext ? AppColors.primary : AppColors.textTertiary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(stops['name'] as String, style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: isNext ? FontWeight.w600 : FontWeight.w400))),
                      if (((stops['students'] as int?) ?? 0) > 0) Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text('${stops['students'] as int} students', style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: isNext ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent, borderRadius: BorderRadius.circular(6)),
                        child: Text(stops['eta'] as String, style: AppTextStyles.labelSmall.copyWith(color: isNext ? AppColors.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: isNext ? FontWeight.w600 : FontWeight.w400)),
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
