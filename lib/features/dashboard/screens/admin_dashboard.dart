import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../app/routes/app_router.dart';
import '../data/dashboard_mock_data.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning 👋',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Springdale International School',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: () => context.push(AppRoutes.notificationsScreen),
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.notifications_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.danger,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              // Stats Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dashboardStats.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final stat = dashboardStats[index];
                  return StatCard(
                    title: stat.title,
                    value: stat.value,
                    icon: stat.icon,
                    color: stat.color,
                    change: stat.change,
                    isIncrease: stat.isIncrease,

                  );
                },
              ),
              const SizedBox(height: 24),
              // Chart Section
              Text(
                'Attendance Overview',
                style: AppTextStyles.titleLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: 16),
              AnimatedCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.toY.round()}%',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final days = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                  ];
                                  if (value.toInt() < days.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        days[value.toInt()],
                                        style: AppTextStyles.labelSmall,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}%',
                                    style: AppTextStyles.labelSmall,
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _barGroup(0, 92, AppColors.primary),
                            _barGroup(1, 88, AppColors.primary),
                            _barGroup(2, 95, AppColors.success),
                            _barGroup(3, 85, AppColors.warning),
                            _barGroup(4, 97, AppColors.success),
                            _barGroup(5, 78, AppColors.danger),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
              const SizedBox(height: 24),
              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTextStyles.titleLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.person_add_rounded,
                      label: 'Add Student',
                      color: AppColors.primary,
                      onTap: () => context.push(AppRoutes.addStudent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.check_circle_rounded,
                      label: 'Attendance',
                      color: AppColors.success,
                      onTap: () => context.push(AppRoutes.attendance),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.payments_rounded,
                      label: 'Fees',
                      color: AppColors.warning,
                      onTap: () => context.push(AppRoutes.fees),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
              const SizedBox(height: 24),
              // Recent Activity
              Text(
                'Recent Activity',
                style: AppTextStyles.titleLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
              const SizedBox(height: 16),
              ...List.generate(
                recentActivities.length,
                (index) => _ActivityTile(
                  activity: recentActivities[index],
                  isLast: index == recentActivities.length - 1,
                ).animate().fadeIn(
                      duration: 400.ms,
                      delay: (700 + index * 100).ms,
                    ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final DashboardActivity activity;
  final bool isLast;

  const _ActivityTile({
    required this.activity,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: activity.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                activity.icon,
                size: 18,
                color: activity.color,
              ),
            ),
            if (!isLast)
              Expanded(
                child: Container(
                  width: 2,
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
