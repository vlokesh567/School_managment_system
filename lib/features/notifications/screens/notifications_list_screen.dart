import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsListScreen extends ConsumerWidget {
  const NotificationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(notificationListProvider);
    final notifier = ref.read(notificationListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.headingSmall),
        actions: [
          TextButton(
            onPressed: () => notifier.markAllRead(),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 6,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SkeletonListTile(),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notifications) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return AnimatedCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              animationDelay: index,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: notif.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(notif.icon, color: notif.color, size: 22),
                      ),
                      if (notif.isUnread)
                        Positioned(
                          top: 0,
                          right: 0,
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: notif.isUnread
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif.message,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif.time,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
