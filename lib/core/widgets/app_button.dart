import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool loading;
  final bool outlined;
  final IconData? icon;
  final Color? backgroundColor;
  final double height;

  const AppButton({
    super.key,
    required this.title,
    this.onTap,
    this.loading = false,
    this.outlined = false,
    this.icon,
    this.backgroundColor,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: height,
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: loading ? null : onTap,
              child: _buildContent(),
            )
          : ElevatedButton(
              onPressed: loading ? null : onTap,
              style: backgroundColor != null
                  ? ElevatedButton.styleFrom(backgroundColor: backgroundColor)
                  : null,
              child: _buildContent(),
            ),
    );

    if (loading) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return button;
  }

  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(title),
        ],
      );
    }
    return Text(title);
  }
}
