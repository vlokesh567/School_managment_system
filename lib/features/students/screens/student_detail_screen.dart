import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/widgets/animated_card.dart';

class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.push(AppRoutes.addStudent),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {}, // more options not yet wired
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'PS',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ).animate().scale(
                        duration: 500.ms,
                        curve: Curves.easeOutBack,
                      ),
                  const SizedBox(height: 16),
                  Text(
                    'Priya Sharma',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Class 10A • Roll No. 101',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Info Cards
            _InfoSection(
              title: 'Personal Information',
              items: [
                _InfoItem('Date of Birth', '15 Jan 2010'),
                _InfoItem('Gender', 'Female'),
                _InfoItem('Blood Group', 'B+'),
                _InfoItem('Address', '123, Green Valley, Mumbai'),
              ],
              delay: 300,
            ),
            const SizedBox(height: 16),
            _InfoSection(
              title: 'Academic Information',
              items: [
                _InfoItem('Admission No.', 'ADM2023/101'),
                _InfoItem('Admission Date', '01 Apr 2023'),
                _InfoItem('Previous School', 'ABC Public School'),
                _InfoItem('Transport Route', 'Route #4 - Bus A'),
              ],
              delay: 400,
            ),
            const SizedBox(height: 16),
            _InfoSection(
              title: 'Parent / Guardian',
              items: [
                _InfoItem('Father\'s Name', 'Mr. Rajesh Sharma'),
                _InfoItem('Mother\'s Name', 'Mrs. Sunita Sharma'),
                _InfoItem('Contact', '+91 98765 43210'),
                _InfoItem('Email', 'rajesh@email.com'),
              ],
              delay: 500,
            ),
            const SizedBox(height: 16),
            _InfoSection(
              title: 'Medical Information',
              items: [
                _InfoItem('Allergies', 'None'),
                _InfoItem('Medical Conditions', 'Asthma (Mild)'),
                _InfoItem('Emergency Contact', '+91 98765 43210'),
              ],
              delay: 600,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;
  final int delay;

  const _InfoSection({
    required this.title,
    required this.items,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedCard(
      animationDelay: delay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);
}
