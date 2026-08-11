import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_button.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Student',
          style: AppTextStyles.headingSmall,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add Photo',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 32),
              Text(
                'Personal Details',
                style: AppTextStyles.titleMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hint: 'First name',
                      label: 'First Name',
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      hint: 'Last name',
                      label: 'Last Name',
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Select date of birth',
                label: 'Date of Birth',
                prefixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
              ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              ))
                          .toList(),
                      onChanged: (_) {},
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      hint: 'Blood group',
                      label: 'Blood Group',
                    ).animate().fadeIn(duration: 400.ms, delay: 350.ms),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Academic Details',
                style: AppTextStyles.titleMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Class',
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      items: ['9A', '9B', '10A', '10B']
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (_) {},
                    ).animate().fadeIn(duration: 400.ms, delay: 450.ms),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      hint: 'Roll number',
                      label: 'Roll Number',
                    ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Enter address',
                label: 'Address',
                maxLines: 3,
              ).animate().fadeIn(duration: 400.ms, delay: 550.ms),
              const SizedBox(height: 24),
              Text(
                'Contact Details',
                style: AppTextStyles.titleMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Enter phone number',
                label: 'Phone',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_rounded, size: 20),
              ).animate().fadeIn(duration: 400.ms, delay: 650.ms),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Enter email address',
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_rounded, size: 20),
              ).animate().fadeIn(duration: 400.ms, delay: 700.ms),
              const SizedBox(height: 32),
              AppButton(
                title: 'Save Student',
                onTap: () {},
              ).animate().fadeIn(duration: 400.ms, delay: 800.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
