import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/models/user_model.dart';
import '../../../core/sync/sync_provider.dart';

class DashboardShell extends ConsumerWidget {
  final UserRole role;
  final StatefulNavigationShell navigationShell;

  const DashboardShell({
    super.key,
    this.role = UserRole.schoolAdmin,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navItems = _navItemsForRole();
    final currentIndex = navigationShell.currentIndex;
    final isOnline = ref.watch(isOnlineProvider);
    final pendingCount = ref.watch(pendingQueueCountProvider);

    return Scaffold(
      body: Column(
        children: [
          // Offline banner
          if (!isOnline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: AppColors.warning,
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'You\'re offline. Changes will sync when connected.',
                      style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                    ),
                    if (pendingCount > 0) ...[                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$pendingCount',
                          style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          // Sync in progress
          ref.watch(syncStateProvider).isSyncing
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppColors.info,
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12, height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Syncing pending changes...',
                          style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(index, initialLocation: index == currentIndex);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          destinations: navItems
              .map(
                (item) => NavigationDestination(
                  icon: Icon(
                    item.icon,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  selectedIcon: Icon(
                    item.activeIcon,
                    color: theme.colorScheme.primary,
                  ),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<_NavItem> _navItemsForRole() {
    switch (role) {
      case UserRole.superAdmin:
        return [
          _NavItem(Icons.dashboard_rounded, Icons.dashboard_rounded, 'Overview'),
          _NavItem(Icons.school_rounded, Icons.school_rounded, 'Schools'),
          _NavItem(Icons.payments_rounded, Icons.payments_rounded, 'Revenue'),
          _NavItem(Icons.settings_rounded, Icons.settings_rounded, 'Settings'),
        ];
      case UserRole.schoolAdmin:
        return [
          _NavItem(Icons.home_rounded, Icons.home_rounded, 'Home'),
          _NavItem(Icons.people_rounded, Icons.people_rounded, 'Students'),
          _NavItem(Icons.assignment_rounded, Icons.assignment_rounded, 'Homework'),
          _NavItem(Icons.notifications_rounded, Icons.notifications_rounded, 'Alerts'),
          _NavItem(Icons.person_rounded, Icons.person_rounded, 'Profile'),
        ];
      case UserRole.teacher:
        return [
          _NavItem(Icons.home_rounded, Icons.home_rounded, 'Home'),
          _NavItem(Icons.check_circle_rounded, Icons.check_circle_rounded, 'Attendance'),
          _NavItem(Icons.assignment_rounded, Icons.assignment_rounded, 'Homework'),
          _NavItem(Icons.schedule_rounded, Icons.schedule_rounded, 'Timetable'),
          _NavItem(Icons.person_rounded, Icons.person_rounded, 'Profile'),
        ];
      case UserRole.parent:
        return [
          _NavItem(Icons.home_rounded, Icons.home_rounded, 'Home'),
          _NavItem(Icons.assignment_rounded, Icons.assignment_rounded, 'Homework'),
          _NavItem(Icons.payments_rounded, Icons.payments_rounded, 'Fees'),
          _NavItem(Icons.directions_bus_rounded, Icons.directions_bus_rounded, 'Bus'),
          _NavItem(Icons.person_rounded, Icons.person_rounded, 'Profile'),
        ];
      case UserRole.student:
        return [
          _NavItem(Icons.home_rounded, Icons.home_rounded, 'Home'),
          _NavItem(Icons.assignment_rounded, Icons.assignment_rounded, 'Homework'),
          _NavItem(Icons.quiz_rounded, Icons.quiz_rounded, 'Exams'),
          _NavItem(Icons.schedule_rounded, Icons.schedule_rounded, 'Timetable'),
          _NavItem(Icons.person_rounded, Icons.person_rounded, 'Profile'),
        ];
      case UserRole.driver:
        return [
          _NavItem(Icons.home_rounded, Icons.home_rounded, 'Home'),
          _NavItem(Icons.route_rounded, Icons.route_rounded, 'Route'),
          _NavItem(Icons.people_rounded, Icons.people_rounded, 'Students'),
          _NavItem(Icons.notifications_rounded, Icons.notifications_rounded, 'Alerts'),
          _NavItem(Icons.person_rounded, Icons.person_rounded, 'Profile'),
        ];
    }
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}
