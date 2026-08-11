import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/constants.dart';
import '../../shared/providers/auth_provider.dart';
import '../../app/routes/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final onboardingComplete =
        LocalStorage.getBool(AppConstants.onboardingKey);

    if (onboardingComplete) {
      // Restore session from stored role
      await ref.read(authProvider.notifier).restoreSession();
      if (!mounted) return;

      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && authState.user != null) {
        context.go(AppRoutes.dashboard);
      } else {
        context.go(AppRoutes.login);
      }
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 48,
                color: Colors.white,
              ),
            ).animate().scale(
                  duration: 800.ms,
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 24),
            Text(
              'School ERP',
              style: AppTextStyles.displaySmall.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(
                  duration: 600.ms,
                  delay: 400.ms,
                ).slideY(begin: 0.2),
            const SizedBox(height: 8),
            Text(
              'Smart School Management',
              style: AppTextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(
                  duration: 600.ms,
                  delay: 600.ms,
                ).slideY(begin: 0.2),
            const SizedBox(height: 48),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: theme.colorScheme.primary,
              ),
            ).animate().fadeIn(
                  duration: 400.ms,
                  delay: 800.ms,
                ),
          ],
        ),
      ),
    );
  }
}
