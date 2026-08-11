import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_button.dart';

class CreateHomeworkScreen extends StatefulWidget {
  const CreateHomeworkScreen({super.key});

  @override
  State<CreateHomeworkScreen> createState() => _CreateHomeworkScreenState();
}

class _CreateHomeworkScreenState extends State<CreateHomeworkScreen> {
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
          'Create Homework',
          style: AppTextStyles.headingSmall,
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Post')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Class',
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    items: ['10A', '10B', '9A', '9B']
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    items: ['Mathematics', 'Science', 'English', 'Hindi']
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Enter homework title',
              label: 'Title',
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Describe the homework in detail...',
              label: 'Description',
              maxLines: 5,
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Select due date',
              label: 'Due Date',
              prefixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            const SizedBox(height: 24),
            // Attachments
            Text(
              'Attachments',
              style: AppTextStyles.titleMedium.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _AttachmentButton(
                    icon: Icons.description_rounded,
                    label: 'PDF',
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  _AttachmentButton(
                    icon: Icons.mic_rounded,
                    label: 'Voice',
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  _AttachmentButton(
                    icon: Icons.image_rounded,
                    label: 'Image',
                    color: AppColors.success,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
            const SizedBox(height: 32),
            AppButton(
              title: 'Post Homework',
              onTap: () {},
            ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _AttachmentButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
