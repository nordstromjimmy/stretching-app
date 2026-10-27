import 'package:flutter/material.dart';

import '../history/history_controller.dart';
import '../l10n/app_localizations.dart';

/// Shows one month at a time and marks completed days.
class MonthCalendar extends StatefulWidget {
  final Set<DateTime> completedDays;

  const MonthCalendar({super.key, required this.completedDays});

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late DateTime _month = _firstOfMonth(DateTime.now());

  static DateTime _firstOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  bool get _isCurrentMonth => _month == _firstOfMonth(DateTime.now());

  void _changeMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    // 0 = Sunday (English), 1 = Monday (Swedish).
    final firstDayOfWeek = material.firstDayOfWeekIndex;
    final weekdays = [
      for (var i = 0; i < 7; i++)
        material.narrowWeekdays[(firstDayOfWeek + i) % 7],
    ];

    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    // DateTime.weekday: Monday = 1 ... Sunday = 7. "% 7" makes Sunday 0.
    final leadingBlanks = (_month.weekday % 7 - firstDayOfWeek + 7) % 7;

    final today = dateOnly(DateTime.now());
    final activeDays = widget.completedDays
        .where((d) => d.year == _month.year && d.month == _month.month)
        .length;

    final title = material.formatMonthYear(_month);
    final capitalizedTitle = title[0].toUpperCase() + title.substring(1);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        child: Column(
          children: [
            // Month header
            Row(
              children: [
                IconButton(
                  tooltip: t.previousMonth,
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    capitalizedTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: t.nextMonth,
                  // No point looking at future months.
                  onPressed: _isCurrentMonth ? null : () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Weekday letters
            Row(
              children: [
                for (final day in weekdays)
                  Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Days
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < leadingBlanks; i++) const SizedBox(),
                for (var day = 1; day <= daysInMonth; day++)
                  _DayCell(
                    day: day,
                    completed: widget.completedDays.contains(
                      DateTime(_month.year, _month.month, day),
                    ),
                    isToday: DateTime(_month.year, _month.month, day) == today,
                    isFuture: DateTime(
                      _month.year,
                      _month.month,
                      day,
                    ).isAfter(today),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              t.activeDaysThisMonth(activeDays),
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool completed;
  final bool isToday;
  final bool isFuture;

  const _DayCell({
    required this.day,
    required this.completed,
    required this.isToday,
    required this.isFuture,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Color textColor;
    if (completed) {
      textColor = colors.onPrimary;
    } else if (isFuture) {
      textColor = colors.onSurface.withValues(alpha: 0.35);
    } else {
      textColor = colors.onSurface;
    }

    return Center(
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: completed ? colors.primary : null,
          border: isToday && !completed
              ? Border.all(color: colors.primary, width: 2)
              : null,
        ),
        child: Text(
          '$day',
          style: textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: isToday ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
