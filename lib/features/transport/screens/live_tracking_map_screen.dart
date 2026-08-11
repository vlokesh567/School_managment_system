import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';

class LiveTrackingMapScreen extends StatelessWidget {
  const LiveTrackingMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Live Tracking',
          style: AppTextStyles.headingSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () {}, // center on current location not yet wired
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Placeholder
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.map_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Map View',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Google Maps will render here',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),
          // Bus Info Panel
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.directions_bus_rounded,
                            color: AppColors.success,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bus D - Route #4',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Driver: Amit Verma',
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
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Moving',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Estimated Arrival',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _StopCard(
                          stop: 'Green Valley',
                          eta: '2 min',
                          status: 'next',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StopCard(
                          stop: 'Lake View',
                          eta: '8 min',
                          status: 'upcoming',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StopCard(
                          stop: 'School',
                          eta: '15 min',
                          status: 'upcoming',
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                  const SizedBox(height: 24),
                  Text(
                    'Students on Board',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                  const SizedBox(height: 12),
                  ...List.generate(5, (index) {
                    final students = [
                      'Priya Sharma', 'Rahul Verma', 'Ananya Patel',
                      'Arjun Singh', 'Sneha Reddy',
                    ];
                    final statuses = ['Picked up', 'Picked up', 'Pending', 'Picked up', 'Pending'];
                    final isPicked = statuses[index] == 'Picked up';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isPicked
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isPicked
                                  ? Icons.check_circle_rounded
                                  : Icons.access_time_rounded,
                              color: isPicked ? AppColors.success : AppColors.warning,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              students[index],
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            statuses[index],
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isPicked ? AppColors.success : AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopCard extends StatelessWidget {
  final String stop;
  final String eta;
  final String status;

  const _StopCard({
    required this.stop,
    required this.eta,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNext = status == 'next';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNext
            ? AppColors.primary.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNext
              ? AppColors.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isNext ? AppColors.primary : AppColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stop,
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: isNext ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            eta,
            style: AppTextStyles.bodySmall.copyWith(
              color: isNext ? AppColors.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: isNext ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
