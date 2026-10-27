import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/month_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final history = AppScope.of(context).history;

    return Scaffold(
      appBar: AppBar(title: Text(t.homeTitle), centerTitle: true),
      body: ListenableBuilder(
        listenable: history,
        builder: (context, _) {
          final String status;
          if (history.completedToday) {
            status = t.todayDone;
          } else if (history.currentStreak > 0) {
            status = t.todayKeepStreak;
          } else {
            status = t.todayStart;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Streaks
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.local_fire_department,
                      value: history.currentStreak,
                      label: t.streakCurrent,
                      highlighted: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.emoji_events_outlined,
                      value: history.longestStreak,
                      label: t.streakLongest,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.check_circle_outline,
                      value: history.totalSessions,
                      label: t.sessionsTotal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _StatusBanner(text: status, done: history.completedToday),
              const SizedBox(height: 16),

              // Calendar
              MonthCalendar(completedDays: history.completedDays),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final bool highlighted;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Highlighted: dark green tile. Others: warm yellow tile.
    final background = highlighted ? colors.primary : AppColors.yellow;
    final foreground = highlighted
        ? colors.onPrimary
        : colors.onPrimaryContainer;
    final iconColor = highlighted ? AppColors.sun : colors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: textTheme.headlineMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String text;
  final bool done;

  const _StatusBanner({required this.text, required this.done});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.today_outlined,
            color: done ? colors.primary : colors.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
