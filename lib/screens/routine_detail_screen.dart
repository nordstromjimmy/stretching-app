import 'package:flutter/material.dart';

import '../data/exercise_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../models/routine.dart';
import '../routines/routine_controller.dart';
import '../settings/settings_controller.dart';
import '../utils/labels.dart';
import '../widgets/routine_name_dialog.dart';
import 'choose_exercises_screen.dart';
import 'exercise_detail_screen.dart';
import 'routine_setup_screen.dart';

class RoutineDetailScreen extends StatelessWidget {
  final String routineId;
  final RoutineController routines;
  final ExerciseRepository repository;
  final SettingsController settings;

  const RoutineDetailScreen({
    super.key,
    required this.routineId,
    required this.routines,
    required this.repository,
    required this.settings,
  });

  Future<void> _chooseExercises(BuildContext context, Routine routine) async {
    final result = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
        builder: (_) => ChooseExercisesScreen(
          repository: repository,
          gender: settings.gender ?? FigureGender.male,
          initialSelected: routine.exerciseIds,
        ),
      ),
    );
    if (result != null) {
      await routines.setExercises(routine.id, result);
    }
  }

  void _start(BuildContext context, Routine routine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoutineSetupScreen(
          routineId: routine.id,
          routines: routines,
          repository: repository,
          settings: settings,
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, Routine routine) async {
    final t = AppLocalizations.of(context);
    final name = await showRoutineNameDialog(
      context,
      title: t.rename,
      confirmLabel: t.save,
      initialName: routine.name,
    );
    if (name != null) await routines.rename(routine.id, name);
  }

  Future<void> _delete(BuildContext context, Routine routine) async {
    final t = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.deleteRoutineTitle),
        content: Text(t.deleteRoutineBody(routine.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pop(); // Back to the routine list first
      await routines.delete(routine.id);
    }
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

        // Pair each routine item with its exercise, skipping ids that
        // no longer exist in exercises.json.
        final entries = <(RoutineItem, Exercise)>[];
        for (final item in routine.items) {
          final exercise = repository.find(item.exerciseId);
          if (exercise != null) entries.add((item, exercise));
        }
        final totalSeconds = repository.routineSeconds(routine);

        return Scaffold(
          appBar: AppBar(
            title: Text(routine.name),
            actions: [
              IconButton(
                tooltip: t.addExercises,
                icon: const Icon(Icons.add),
                onPressed: () => _chooseExercises(context, routine),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => value == 'rename'
                    ? _rename(context, routine)
                    : _delete(context, routine),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'rename', child: Text(t.rename)),
                  PopupMenuItem(value: 'delete', child: Text(t.delete)),
                ],
              ),
            ],
          ),
          floatingActionButton: entries.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _start(context, routine),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(t.startRoutine),
                ),
          body: entries.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t.routineEmptyExercises,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _chooseExercises(context, routine),
                          icon: const Icon(Icons.add),
                          label: Text(t.addExercises),
                        ),
                      ],
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  buildDefaultDragHandles: false,
                  header: Padding(
                    padding: const EdgeInsets.only(bottom: 12, top: 4),
                    child: Text(
                      '${t.routineExerciseCount(entries.length)}'
                      ' · ${t.totalTime(formatDuration(t, totalSeconds))}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  itemCount: entries.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final ids = entries.map((entry) => entry.$2.id).toList();
                    final moved = ids.removeAt(oldIndex);
                    ids.insert(newIndex, moved);
                    routines.setExercises(routine.id, ids);
                  },
                  itemBuilder: (context, index) {
                    final (item, exercise) = entries[index];
                    return _RoutineExerciseCard(
                      key: ValueKey(exercise.id),
                      index: index,
                      exercise: exercise,
                      item: item,
                      gender: gender,
                      onRemove: () =>
                          routines.removeExercise(routine.id, exercise.id),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ExerciseDetailScreen(
                            exercise: exercise,
                            gender: gender,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _RoutineExerciseCard extends StatelessWidget {
  final int index;
  final Exercise exercise;
  final RoutineItem item;
  final FigureGender gender;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _RoutineExerciseCard({
    super.key,
    required this.index,
    required this.exercise,
    required this.item,
    required this.gender,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              // Drag handle: press and drag to reorder.
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Icon(Icons.drag_indicator, color: muted),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(4),
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
                      '${holdLabel(t, item.holdFor(exercise), exercise.dose.perSide)}'
                      ' · ${formatDuration(t, item.totalFor(exercise))}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: t.remove,
                icon: const Icon(Icons.close),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
