import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventsAsync = ref.watch(eventListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Events & Calendar', style: AppTextStyles.headingSmall),
        actions: [
          IconButton(
            icon: Icon(_showCalendar ? Icons.list_rounded : Icons.calendar_month_rounded),
            onPressed: () => setState(() => _showCalendar = !_showCalendar),
            tooltip: _showCalendar ? 'List view' : 'Calendar view',
          ),
        ],
      ),
      body: _showCalendar ? _buildCalendarView(theme, eventsAsync) : eventsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 5,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonListTile(),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return AnimatedCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              animationDelay: index,
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 64,
                    decoration: BoxDecoration(
                      color: event.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event.day,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: event.color,
                          ),
                        ),
                        Text(
                          event.month,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: event.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: event.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                event.type,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: event.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCalendarView(ThemeData theme, AsyncValue<List<EventModel>> eventsAsync) {
    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (events) {
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0);
        final firstWeekday = firstDay.weekday % 7;
        final daysInMonth = lastDay.day;

        final Map<int, List<EventModel>> eventsByDay = {};
        for (final event in events) {
          for (int d = 1; d <= daysInMonth; d++) {
            if (DateTime(now.year, now.month, d).day.toString() == event.day &&
                _monthAbbr(now.month) == event.month) {
              eventsByDay.putIfAbsent(d, () => []).add(event);
            }
          }
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    _monthName(now.month),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${now.year}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) => Expanded(
                  child: Center(
                    child: Text(d, style: AppTextStyles.labelSmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    )),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: firstWeekday + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < firstWeekday) return const SizedBox();
                  final day = index - firstWeekday + 1;
                  final hasEvent = eventsByDay.containsKey(day);
                  final isToday = day == now.day;
                  return GestureDetector(
                    onTap: () => setState(() => _showCalendar = false),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primary.withValues(alpha: 0.1) : null,
                        borderRadius: BorderRadius.circular(8),
                        border: isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$day',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isToday ? AppColors.primary : theme.colorScheme.onSurface,
                              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          if (hasEvent)
                            Container(
                              width: 5,
                              height: 5,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (events.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.event_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${events.length} event${events.length == 1 ? '' : 's'} this month',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => setState(() => _showCalendar = false),
                      icon: const Icon(Icons.list_rounded, size: 16),
                      label: const Text('List'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => setState(() => _showCalendar = false),
              child: const Text('Show event list'),
            ),
          ],
        );
      },
    );
  }

  String _monthName(int month) {
    const names = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return names[month - 1];
  }

  String _monthAbbr(int month) {
    const abbr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return abbr[month - 1];
  }
}
