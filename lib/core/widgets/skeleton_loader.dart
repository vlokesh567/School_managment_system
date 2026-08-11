import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Use the app's custom slate/grey palette instead of Material Colors.grey
    const lightBase = Color(0xFFE2E8F0);    // AppColors.borderLight
    const lightHighlight = Color(0xFFF1F5F9); // AppColors.dividerLight
    const darkBase = Color(0xFF334155);      // AppColors.borderDark
    const darkHighlight = Color(0xFF475569);  // Slightly lighter than borderDark
    final baseColor = isDark ? darkBase : lightBase;
    final highlightColor = isDark ? darkHighlight : lightHighlight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(height: 16, width: 100),
          SizedBox(height: 12),
          SkeletonLoader(height: 12),
          SizedBox(height: 8),
          SkeletonLoader(height: 12, width: 150),
        ],
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SkeletonLoader(width: 48, height: 48, borderRadius: 16),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(height: 14, width: 200),
                SizedBox(height: 8),
                SkeletonLoader(height: 12, width: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const SkeletonGrid({
    super.key,
    this.itemCount = 4,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}
