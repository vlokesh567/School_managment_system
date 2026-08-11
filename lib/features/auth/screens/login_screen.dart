import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../app/routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '9876543210');
  final _passwordController = TextEditingController(text: 'password123');
  bool _rememberMe = false;
  bool _loading = false;

  /// Demo login credentials by role:
  /// Admin:  9876543210 / password123
  /// Teacher: 9876543211 / password123
  /// Parent:  9876543212 / password123
  /// Student: 9876543213 / password123
  /// Driver:  9876543214 / password123
  /// Super:   9999999999 / password123

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                const SizedBox(height: 24),
                Text(
                  'Welcome back',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue to your school dashboard',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: 40),
                // Form fields
                AppTextField(
                  hint: 'Enter mobile number',
                  label: 'Mobile Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                  prefixIcon: const Icon(Icons.phone_rounded, size: 20),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: 20),
                AppTextField(
                  hint: 'Enter password',
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                  prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.1),
                const SizedBox(height: 12),
                // Remember & Forgot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (v) {
                              setState(() => _rememberMe = v ?? false);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remember me',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                const SizedBox(height: 24),
                // Login button
                AppButton(
                  title: 'Sign In',
                  loading: _loading,
                  onTap: _handleLogin,
                ).animate().fadeIn(duration: 400.ms, delay: 600.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 700.ms),
                const SizedBox(height: 16),
                // OTP Login
                AppButton(
                  title: 'Login with OTP',
                  outlined: true,
                  icon: Icons.smartphone_rounded,
                  onTap: () => context.push(AppRoutes.otp),
                ).animate().fadeIn(duration: 400.ms, delay: 800.ms),
                const SizedBox(height: 16),
                // Biometric
                if (true)
                  Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.fingerprint_rounded,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 900.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _loading = true);

      // Auth via provider — determines role based on phone number
      await ref.read(authProvider.notifier).login(
        _phoneController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        setState(() => _loading = false);
        final user = ref.read(authProvider).user;
        if (user != null) {
          context.go(AppRoutes.dashboard);
        }
      }
    }
  }
}
