import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/transport_model.dart';
import '../providers/transport_provider.dart';

class TransportDashboardScreen extends ConsumerWidget {
  const TransportDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transportAsync = ref.watch(transportDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transport', style: AppTextStyles.headingSmall),
      ),
      body: transportAsync.when(
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(children: [
                const Expanded(child: SkeletonLoader(height: 72, borderRadius: 16)),
                const SizedBox(width: 12),
                const Expanded(child: SkeletonLoader(height: 72, borderRadius: 16)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                const Expanded(child: SkeletonLoader(height: 72, borderRadius: 16)),
                const SizedBox(width: 12),
                const Expanded(child: SkeletonLoader(height: 72, borderRadius: 16)),
              ]),
              const SizedBox(height: 24),
              const SkeletonLoader(height: 52, borderRadius: 12),
              const SizedBox(height: 24),
              const SkeletonLoader(height: 20, width: 160),
              const SizedBox(height: 12),
              ...List.generate(3, (_) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SkeletonLoader(height: 88, borderRadius: 16),
              )),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final routes = data.routes;
          final activeCount = routes.where((r) => r.status == 'On Time').length;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _TransportStatCard(
                        label: 'Vehicles',
                        value: '8',
                        color: AppColors.primary,
                        icon: Icons.directions_bus_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TransportStatCard(
                        label: 'Drivers',
                        value: '10',
                        color: AppColors.accent,
                        icon: Icons.person_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _TransportStatCard(
                        label: 'Routes',
                        value: '${routes.length}',
                        color: AppColors.success,
                        icon: Icons.route_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TransportStatCard(
                        label: 'Active',
                        value: '$activeCount',
                        color: AppColors.warning,
                        icon: Icons.play_circle_rounded,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                  ],
                ),
                const SizedBox(height: 24),
                AppButton(
                  title: 'Live GPS Tracking',
                  icon: Icons.my_location_rounded,
                  onTap: () => context.push(AppRoutes.liveTracking),
                  height: 52,
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                const SizedBox(height: 24),
                Text(
                  'Active Routes',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                const SizedBox(height: 12),
                ...routes.map((route) {
                  return AnimatedCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.directions_bus_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    route.name,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    route.driverName,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (route.isDelayed
                                        ? AppColors.danger
                                        : AppColors.success)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                route.status,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: route.isDelayed
                                      ? AppColors.danger
                                      : AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${route.studentCount} students',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.directions_car_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                route.vehicleNumber,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TransportStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _TransportStatCard({
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
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        ],
      ),
    );
  }
}
