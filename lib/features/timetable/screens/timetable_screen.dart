import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/timetable_model.dart';
import '../providers/timetable_provider.dart';

class TimetableScreen extends ConsumerStatefulWidget {
  const TimetableScreen({super.key});

  @override
  ConsumerState<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends ConsumerState<TimetableScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // Monday = 0

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timetableAsync = ref.watch(timetableProvider('10A'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable', style: AppTextStyles.headingSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_view_week_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Day selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _days.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  final selected = _selectedDay == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 52,
                      height: 64,
                      decoration: BoxDecoration(
                        color: selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: selected
                            ? null
                            : Border.all(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                      ),
                      child: Center(
                        child: Text(
                          day,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: selected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Timetable
          Expanded(
            child: timetableAsync.when(
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 6,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SkeletonLoader(height: 72, borderRadius: 16),
                ),
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (tt) {
                final currentDay = tt[_selectedDay] ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: currentDay.length,
                  itemBuilder: (context, index) {
                    final item = currentDay[index];
                    return AnimatedCard(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      animationDelay: index,
                      child: item.isBreak
                          ? Center(
                              child: Text(
                                '☕ ${item.time} - Break',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: item.color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.subject,
                                        style: AppTextStyles.titleMedium.copyWith(
                                          color: theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.teacher}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item.time,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    if (item.room.isNotEmpty)
                                      Text(
                                        'Room ${item.room}',
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
