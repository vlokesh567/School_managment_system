import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/constants.dart';
import '../../../app/routes/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = [
    _OnboardingItem(
      icon: Icons.school_rounded,
      title: 'Welcome to School ERP',
      subtitle: 'The most beautiful and intuitive school management platform for modern education.',
      color: AppColors.primary,
    ),
    _OnboardingItem(
      icon: Icons.people_rounded,
      title: 'Connect Everyone',
      subtitle: 'Bring together students, teachers, parents, and staff on one seamless platform.',
      color: AppColors.accent,
    ),
    _OnboardingItem(
      icon: Icons.insights_rounded,
      title: 'Smart Analytics',
      subtitle: 'Make data-driven decisions with beautiful dashboards and real-time insights.',
      color: AppColors.success,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            item.icon,
                            size: 56,
                            color: item.color,
                          ),
                        ).animate().fadeIn(
                              duration: 600.ms,
                              delay: 200.ms,
                            ).scale(
                              begin: const Offset(0.8, 0.8),
                              curve: Curves.easeOutBack,
                            ),
                        const SizedBox(height: 40),
                        Text(
                          item.title,
                          style: AppTextStyles.headingLarge.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(
                              duration: 600.ms,
                              delay: 400.ms,
                            ).slideY(begin: 0.2),
                        const SizedBox(height: 16),
                        Text(
                          item.subtitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(
                              duration: 600.ms,
                              delay: 600.ms,
                            ).slideY(begin: 0.2),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  AppButton(
                    title: _currentPage == _items.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onTap: () {
                      if (_currentPage == _items.length - 1) {
                        _navigateToLogin();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  if (_currentPage > 0)
                    AppButton(
                      title: 'Back',
                      outlined: true,
                      onTap: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin() {
    LocalStorage.setBool(AppConstants.onboardingKey, true);
    context.go(AppRoutes.login);
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
