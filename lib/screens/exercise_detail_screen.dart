import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../utils/labels.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;
  final FigureGender gender;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    //final colors = Theme.of(context).colorScheme;

    final tips = exercise.tips.of(lang);
    //final caution = exercise.caution;

    return Scaffold(
      appBar: AppBar(
        // White so the app bar blends into the white image background.
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Image
            Container(
              color: Colors.white,
              height: 280,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Image.asset(
                exercise.imagePath(gender),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined, size: 48),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and body areas
                  Text(exercise.name.of(lang), style: textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final area in exercise.bodyAreas)
                        _Tag(label: bodyAreaLabel(t, area)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Summary
                  Text(exercise.summary.of(lang), style: textTheme.bodyLarge),
                  const SizedBox(height: 20),

                  // Quick facts
                  /* _InfoCard(
                    rows: [
                      _InfoRow(
                        icon: Icons.timer_outlined,
                        text: formatDuration(t, exercise.dose.totalSeconds),
                      ),
                      _InfoRow(
                        icon: Icons.repeat,
                        text: doseLabel(t, exercise.dose),
                      ),
                      _InfoRow(
                        icon: Icons.accessibility_new,
                        text: positionLabel(t, exercise.position),
                      ),
                      _InfoRow(
                        icon: Icons.category_outlined,
                        text: typeLabel(t, exercise.type),
                      ),
                      _InfoRow(
                        icon: Icons.fitness_center,
                        text: equipmentLabel(t, exercise.equipment),
                      ),
                      if (exercise.workFriendly)
                        _InfoRow(icon: Icons.work_outline, text: t.workFriendly),
                    ],
                  ), */
                  //const SizedBox(height: 28),

                  // Steps
                  Text(t.stepsTitle, style: textTheme.titleLarge),
                  const SizedBox(height: 12),
                  for (final (index, step) in exercise.steps.of(lang).indexed)
                    _StepRow(number: index + 1, text: step),

                  // Tips
                  if (tips.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(t.tipsTitle, style: textTheme.titleLarge),
                    const SizedBox(height: 12),
                    for (final tip in tips) _TipRow(text: tip),
                  ],

                  // Caution
                  /* if (caution != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: colors.onErrorContainer,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.cautionTitle,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: colors.onErrorContainer,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  caution.of(lang),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colors.onErrorContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ], */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: colors.onPrimaryContainer),
      ),
    );
  }
}

/* class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;

  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: rows),
    );
  }
} */

/* class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
} */

class _StepRow extends StatelessWidget {
  final int number;
  final String text;

  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: colors.primary,
            child: Text(
              '$number',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: colors.onPrimary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String text;

  const _TipRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
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
