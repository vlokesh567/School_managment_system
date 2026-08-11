import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/fee_model.dart';
import '../providers/fee_provider.dart';

class FeeDashboardScreen extends ConsumerWidget {
  const FeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dashboardAsync = ref.watch(feeDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fee Management', style: AppTextStyles.headingSmall),
      ),
      body: dashboardAsync.when(
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(children: [
                const Expanded(child: SkeletonLoader(height: 96, borderRadius: 16)),
                const SizedBox(width: 12),
                const Expanded(child: SkeletonLoader(height: 96, borderRadius: 16)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                const Expanded(child: SkeletonLoader(height: 96, borderRadius: 16)),
                const SizedBox(width: 12),
                const Expanded(child: SkeletonLoader(height: 96, borderRadius: 16)),
              ]),
              const SizedBox(height: 24),
              const SkeletonLoader(height: 280, borderRadius: 16),
              const SizedBox(height: 24),
              const SkeletonLoader(height: 48, borderRadius: 12),
              const SizedBox(height: 24),
              const SkeletonLoader(height: 20, width: 200),
              const SizedBox(height: 12),
              ...List.generate(4, (_) => const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: SkeletonLoader(height: 64, borderRadius: 14),
              )),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final summary = data.summary;
          final transactions = data.transactions;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _FeeStatCard(
                        label: 'Total Collected',
                        value: summary.totalCollectedLabel,
                        color: AppColors.success,
                        icon: Icons.trending_up_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeeStatCard(
                        label: 'Pending',
                        value: summary.pendingLabel,
                        color: AppColors.warning,
                        icon: Icons.pending_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FeeStatCard(
                        label: 'Overdue',
                        value: summary.overdueLabel,
                        color: AppColors.danger,
                        icon: Icons.warning_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeeStatCard(
                        label: 'Collections',
                        value: summary.collectionLabel,
                        color: AppColors.primary,
                        icon: Icons.pie_chart_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                  ],
                ),
                const SizedBox(height: 24),
                AnimatedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Collection',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: summary.collectionPercent,
                                color: AppColors.success,
                                title: '${summary.collectionPercent.toStringAsFixed(0)}%',
                                radius: 40,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                value: 100 - summary.collectionPercent,
                                color: AppColors.warning,
                                title: '${(100 - summary.collectionPercent).toStringAsFixed(0)}%',
                                radius: 35,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LegendItem(color: AppColors.success, label: 'Collected'),
                          const SizedBox(width: 16),
                          _LegendItem(color: AppColors.warning, label: 'Outstanding'),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        title: 'Collect Fee',
                        icon: Icons.payments_rounded,
                        onTap: () => context.push(AppRoutes.collectFee),
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        title: 'View Reports',
                        icon: Icons.description_rounded,
                        outlined: true,
                        onTap: () => context.push(AppRoutes.feeReports),
                        height: 48,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                const SizedBox(height: 24),
                Text(
                  'Recent Transactions',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                const SizedBox(height: 12),
                ...transactions.map((tx) {
                  final statusColor = tx.status == TransactionStatus.paid
                      ? AppColors.success
                      : tx.status == TransactionStatus.pending
                          ? AppColors.warning
                          : AppColors.danger;
                  return AnimatedCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.payments_rounded,
                            color: statusColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.studentName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                tx.date,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              tx.amountLabel,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tx.status.label,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeeStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _FeeStatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headingSmall.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelMedium),
      ],
    );
  }
}
