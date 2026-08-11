import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';

class FeeReportsScreen extends StatelessWidget {
  const FeeReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final monthlyData = [
      _MonthlyData('Apr', 182000, 180000),
      _MonthlyData('May', 175000, 165000),
      _MonthlyData('Jun', 190000, 188000),
      _MonthlyData('Jul', 168000, 160000),
      _MonthlyData('Aug', 195000, 192000),
      _MonthlyData('Sep', 172000, 170000),
    ];

    final classData = [
      _ClassData('10A', 45, 15, 2, 95),
      _ClassData('10B', 42, 18, 3, 88),
      _ClassData('9A', 48, 10, 1, 98),
      _ClassData('9B', 44, 12, 0, 100),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Fee Reports', style: AppTextStyles.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Total Collected (MTD)',
                    value: '₹10.82L',
                    icon: Icons.trending_up_rounded,
                    color: AppColors.success,
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: 'Outstanding',
                    value: '₹3.20L',
                    icon: Icons.warning_rounded,
                    color: AppColors.warning,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Collection Rate',
                    value: '78%',
                    icon: Icons.pie_chart_rounded,
                    color: AppColors.primary,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: 'Defaulters',
                    value: '6',
                    icon: Icons.person_off_rounded,
                    color: AppColors.danger,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
              ],
            ),
            const SizedBox(height: 24),

            // Monthly Collection Chart
            Text('Monthly Collection Trend', style: AppTextStyles.titleLarge.copyWith(
              color: theme.colorScheme.onSurface,
            )).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            const SizedBox(height: 16),
            AnimatedCard(
              child: SizedBox(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 250000,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final label = rodIndex == 0 ? 'Expected' : 'Collected';
                            return BarTooltipItem(
                              '$label: ₹${rod.toY.round()}',
                              TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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
                              if (value.toInt() < monthlyData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(monthlyData[value.toInt()].month, style: AppTextStyles.labelSmall),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox();
                              return Text('₹${(value / 1000).toInt()}k', style: AppTextStyles.labelSmall);
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: monthlyData.asMap().entries.map((entry) {
                        final i = entry.key;
                        final data = entry.value;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(toY: data.expected.toDouble(), color: AppColors.primary.withValues(alpha: 0.3), width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                            BarChartRodData(toY: data.collected.toDouble(), color: AppColors.success, width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
            const SizedBox(height: 24),

            // Class-wise collection
            Text('Class-wise Collection', style: AppTextStyles.titleLarge.copyWith(
              color: theme.colorScheme.onSurface,
            )).animate().fadeIn(duration: 400.ms, delay: 500.ms),
            const SizedBox(height: 12),
            ...classData.asMap().entries.map((entry) {
              final data = entry.value;
              return AnimatedCard(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                animationDelay: 600 + entry.key * 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Class ${data.className}', style: AppTextStyles.titleMedium.copyWith(
                          color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600,
                        )),
                        const Spacer(),
                        Text('${data.collectionPercent}%', style: AppTextStyles.titleMedium.copyWith(
                          color: data.collectionPercent >= 90 ? AppColors.success : data.collectionPercent >= 75 ? AppColors.warning : AppColors.danger,
                          fontWeight: FontWeight.w600,
                        )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: data.collectionPercent / 100,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        color: data.collectionPercent >= 90 ? AppColors.success : data.collectionPercent >= 75 ? AppColors.warning : AppColors.danger,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatDot(color: AppColors.success, label: '${data.paid} Paid'),
                        const SizedBox(width: 12),
                        _StatDot(color: AppColors.warning, label: '${data.pending} Pending'),
                        const SizedBox(width: 12),
                        _StatDot(color: AppColors.danger, label: '${data.overdue} Overdue'),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface)),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _StatDot extends StatelessWidget {
  final Color color;
  final String label;
  const _StatDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

class _MonthlyData {
  final String month;
  final double expected;
  final double collected;
  const _MonthlyData(this.month, this.expected, this.collected);
}

class _ClassData {
  final String className;
  final int paid;
  final int pending;
  final int overdue;
  final int collectionPercent;
  const _ClassData(this.className, this.paid, this.pending, this.overdue, this.collectionPercent);
}
