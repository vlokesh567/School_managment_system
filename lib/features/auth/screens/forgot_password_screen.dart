import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.lock_reset_rounded,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
              const SizedBox(height: 24),
              Text(
                'Reset Password',
                style: AppTextStyles.displaySmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 8),
              Text(
                'Enter your registered mobile number to receive a password reset link',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: 40),
              if (!_sent) ...[
                AppTextField(
                  hint: 'Enter mobile number',
                  label: 'Mobile Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                  prefixIcon: const Icon(Icons.phone_rounded, size: 20),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                const SizedBox(height: 24),
                AppButton(
                  title: 'Send Reset Link',
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() => _sent = true);
                    }
                  },
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Reset link sent!',
                        style: AppTextStyles.headingSmall.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your phone for the password reset link',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().scale(
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
