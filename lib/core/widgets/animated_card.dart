import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/theme/app_colors.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool animateOnMount;
  final int animationDelay;

  const AnimatedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 20,
    this.color,
    this.shadows,
    this.onTap,
    this.animateOnMount = true,
    this.animationDelay = 0,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = widget.color ??
        (isDark ? AppColors.cardDark : AppColors.cardLight);
    final cardShadows = widget.shadows ??
        (isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : AppColors.softShadow);

    final card = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: cardShadows,
        ),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap!();
        },
        onTapCancel: () => _controller.reverse(),
        child: widget.animateOnMount
            ? card.animate().fadeIn(
                  duration: 400.ms,
                  delay: (widget.animationDelay * 100).ms,
                )
            : card,
      );
    }

    return widget.animateOnMount
        ? card.animate().fadeIn(
              duration: 400.ms,
              delay: (widget.animationDelay * 100).ms,
            )
        : card;
  }
}
