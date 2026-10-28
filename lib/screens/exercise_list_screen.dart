import 'package:flutter/material.dart';

import '../data/exercise_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../settings/settings_controller.dart';
import '../theme/app_theme.dart';
import '../utils/labels.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  final ExerciseRepository repository;
  final SettingsController settings;

  const ExerciseListScreen({
    super.key,
    required this.repository,
    required this.settings,
  });

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  /// The selected body area. null = show all.
  BodyArea? _filter;

  void _select(BodyArea? area) => setState(() {
    // Tapping the selected area again goes back to showing all.
    _filter = (_filter == area) ? null : area;
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final gender = widget.settings.gender ?? FigureGender.male;

    final exercises =
        widget.repository.all
            .where((e) => _filter == null || e.bodyAreas.contains(_filter))
            .toList()
          ..sort(
            (a, b) => compareNames(a.name.of(lang), b.name.of(lang), lang),
          );

    return Scaffold(
      appBar: AppBar(title: Text(t.exercisesTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips, scrolling sideways
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: [
                _FilterChip(
                  label: t.filterAll,
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                for (final area in BodyArea.values)
                  _FilterChip(
                    label: bodyAreaLabel(t, area),
                    selected: _filter == area,
                    onTap: () => _select(area),
                  ),
              ],
            ),
          ),

          // Number of exercises shown
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              t.routineExerciseCount(exercises.length),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // List
          Expanded(
            child: exercises.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        t.noExercisesForFilter,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: exercises.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _ExerciseCard(
                      exercise: exercises[index],
                      gender: gender,
                      lang: lang,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: colors.primary,
        backgroundColor: AppColors.card,
        labelStyle: TextStyle(
          color: selected ? colors.onPrimary : colors.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final FigureGender gender;
  final String lang;

  const _ExerciseCard({
    required this.exercise,
    required this.gender,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  ExerciseDetailScreen(exercise: exercise, gender: gender),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 110,
              height: 110,
              color: Colors.white,
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                exercise.imagePath(gender),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercise.name.of(lang), style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      exercise.bodyAreas
                          .map((area) => bodyAreaLabel(t, area))
                          .join(' · '),
                      style: textTheme.bodySmall?.copyWith(color: muted),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: muted),
                        const SizedBox(width: 4),
                        Text(
                          formatDuration(t, exercise.dose.totalSeconds),
                          style: textTheme.bodySmall?.copyWith(color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
