import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/app_button.dart';

class CollectFeeScreen extends StatefulWidget {
  const CollectFeeScreen({super.key});

  @override
  State<CollectFeeScreen> createState() => _CollectFeeScreenState();
}

class _CollectFeeScreenState extends State<CollectFeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedStudent;
  String _paymentMethod = 'Cash';
  bool _loading = false;

  final List<Map<String, String>> _students = [
    {'id': '1', 'name': 'Priya Sharma', 'class': '10A'},
    {'id': '2', 'name': 'Rahul Verma', 'class': '10A'},
    {'id': '3', 'name': 'Ananya Patel', 'class': '10B'},
    {'id': '4', 'name': 'Arjun Singh', 'class': '10B'},
    {'id': '5', 'name': 'Sneha Reddy', 'class': '9A'},
    {'id': '6', 'name': 'Vikram Joshi', 'class': '9A'},
  ];

  final List<String> _paymentMethods = ['Cash', 'Card', 'UPI', 'Cheque', 'Bank Transfer'];

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Collect Fee', style: AppTextStyles.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    size: 40,
                    color: AppColors.success,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
              const SizedBox(height: 32),

              // Student
              Text('Student', style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600))
                  .animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedStudent,
                decoration: const InputDecoration(
                  labelText: 'Select Student',
                  filled: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_rounded),
                ),
                items: _students.map((s) => DropdownMenuItem(
                  value: s['id'],
                  child: Text('${s['name']} (${s['class']})'),
                )).toList(),
                onChanged: (v) => setState(() => _selectedStudent = v),
                validator: (v) => v == null ? 'Please select a student' : null,
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
              const SizedBox(height: 20),

              // Amount
              Text('Amount', style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600))
                  .animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: 12),
              AppTextField(
                hint: 'Enter amount',
                label: 'Amount (₹)',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 20),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(v) == null) return 'Please enter a valid amount';
                  return null;
                },
              ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
              const SizedBox(height: 20),

              // Payment method
              Text('Payment Method', style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600))
                  .animate().fadeIn(duration: 400.ms, delay: 300.ms),
              const SizedBox(height: 12),
              ..._paymentMethods.map((method) {
                final selected = _paymentMethod == method;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _paymentMethod = method),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.success.withValues(alpha: 0.08) : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? AppColors.success : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                            color: selected ? AppColors.success : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(method, style: AppTextStyles.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              const SizedBox(height: 20),

              // Notes
              Text('Notes (Optional)', style: AppTextStyles.titleMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600))
                  .animate().fadeIn(duration: 400.ms, delay: 400.ms),
              const SizedBox(height: 12),
              AppTextField(
                hint: 'Add any notes...',
                label: 'Notes',
                controller: _notesController,
                maxLines: 3,
              ).animate().fadeIn(duration: 400.ms, delay: 450.ms),
              const SizedBox(height: 32),

              // Submit
              AppButton(
                title: 'Collect Payment',
                loading: _loading,
                icon: Icons.payments_rounded,
                onTap: _handleCollect,
              ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCollect() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text('Fee collected successfully — ₹${_amountController.text}'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.pop(context);
  }
}
