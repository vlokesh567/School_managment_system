import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../app/routes/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.headingSmall),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Card
          AnimatedCard(
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'AD',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin User',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'School Administrator',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () => context.push(AppRoutes.profile),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          // Preferences
          _SectionTitle(title: 'Preferences', delay: 200),
          const SizedBox(height: 12),
          AnimatedCard(
            animationDelay: 200,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  trailing: Switch.adaptive(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (v) {
                      ref.read(themeModeProvider.notifier).toggle();
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  trailing: Switch.adaptive(value: true, onChanged: (_) {}),
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.font_download_rounded,
                  title: 'Font Size',
                  subtitle: 'Medium',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 24),
          // School Info
          _SectionTitle(title: 'School Information', delay: 300),
          const SizedBox(height: 12),
          AnimatedCard(
            animationDelay: 300,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.school_rounded,
                  title: 'School Name',
                  subtitle: 'Springdale International School',
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.location_on_rounded,
                  title: 'Address',
                  subtitle: '123, Education District, Mumbai',
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.phone_rounded,
                  title: 'Contact',
                  subtitle: '+91 98765 43210',
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
          const SizedBox(height: 24),
          // Account
          _SectionTitle(title: 'Account', delay: 400),
          const SizedBox(height: 12),
          AnimatedCard(
            animationDelay: 400,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.lock_rounded,
                  title: 'Change Password',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric Login',
                  trailing: Switch.adaptive(value: false, onChanged: (_) {}),
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  titleColor: AppColors.danger,
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go(AppRoutes.login);
                  },
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
          const SizedBox(height: 24),
          // About
          _SectionTitle(title: 'About', delay: 500),
          const SizedBox(height: 12),
          AnimatedCard(
            animationDelay: 500,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_rounded,
                  title: 'Version',
                  subtitle: '1.0.0',
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.description_rounded,
                  title: 'Terms of Service',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int delay;

  const _SectionTitle({required this.title, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: delay.ms);
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: titleColor ?? theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
