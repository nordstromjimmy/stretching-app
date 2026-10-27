import 'package:flutter/material.dart';

import '../data/exercise_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../models/routine.dart';
import '../routines/routine_controller.dart';
import '../settings/settings_controller.dart';
import '../utils/labels.dart';
import 'routine_player_screen.dart';

class RoutineSetupScreen extends StatelessWidget {
  final String routineId;
  final RoutineController routines;
  final ExerciseRepository repository;
  final SettingsController settings;

  const RoutineSetupScreen({
    super.key,
    required this.routineId,
    required this.routines,
    required this.repository,
    required this.settings,
  });

  static const int _step = 5; // seconds per tap
  static const int _min = 5;
  static const int _max = 300;

  void _startSession(
    BuildContext context,
    Routine routine,
    List<(RoutineItem, Exercise)> entries,
  ) {
    final session = [
      for (final (item, exercise) in entries)
        SessionExercise(
          exercise: exercise,
          holdSeconds: item.holdFor(exercise),
        ),
    ];

    // Replace this screen, so "Done" in the player goes back to the routine.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RoutinePlayerScreen(
          routineName: routine.name,
          exercises: session,
          gender: settings.gender ?? FigureGender.male,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final gender = settings.gender ?? FigureGender.male;

    return ListenableBuilder(
      listenable: routines,
      builder: (context, _) {
        final routine = routines.byId(routineId);
        if (routine == null) return const Scaffold();

        final entries = <(RoutineItem, Exercise)>[];
        for (final item in routine.items) {
          final exercise = repository.find(item.exerciseId);
          if (exercise != null) entries.add((item, exercise));
        }
        final totalSeconds = repository.routineSeconds(routine);

        return Scaffold(
          appBar: AppBar(title: Text(t.setupTitle)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              Text(
                t.setupHint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              for (final (item, exercise) in entries)
                _SetupRow(
                  exercise: exercise,
                  item: item,
                  gender: gender,
                  onChanged: (seconds) => routines.setHoldSeconds(
                    routine.id,
                    exercise.id,
                    seconds.clamp(_min, _max),
                  ),
                  step: _step,
                  min: _min,
                  max: _max,
                ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                onPressed: entries.isEmpty
                    ? null
                    : () => _startSession(context, routine, entries),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  '${t.startRoutine} · ${formatDuration(t, totalSeconds)}',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SetupRow extends StatelessWidget {
  final Exercise exercise;
  final RoutineItem item;
  final FigureGender gender;
  final ValueChanged<int> onChanged;
  final int step;
  final int min;
  final int max;

  const _SetupRow({
    required this.exercise,
    required this.item,
    required this.gender,
    required this.onChanged,
    required this.step,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final hold = item.holdFor(exercise);
    final perSide = exercise.dose.perSide;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(3),
              child: Image.asset(
                exercise.imagePath(gender),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name.of(lang),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    perSide
                        ? '${t.dosePerSide} · ${t.totalTime(formatDuration(t, item.totalFor(exercise)))}'
                        : t.totalTime(
                            formatDuration(t, item.totalFor(exercise)),
                          ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: t.shorter,
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: hold <= min ? null : () => onChanged(hold - step),
            ),
            SizedBox(
              width: 48,
              child: Text(
                t.durationSeconds(hold),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            IconButton(
              tooltip: t.longer,
              icon: const Icon(Icons.add_circle_outline),
              onPressed: hold >= max ? null : () => onChanged(hold + step),
            ),
          ],
        ),
      ),
    );
  }
}
