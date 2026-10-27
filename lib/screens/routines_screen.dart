import 'package:flutter/material.dart';

import '../data/exercise_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/routine.dart';
import '../routines/routine_controller.dart';
import '../settings/settings_controller.dart';
import '../utils/labels.dart';
import '../widgets/routine_name_dialog.dart';
import 'routine_detail_screen.dart';

class RoutinesScreen extends StatelessWidget {
  final RoutineController routines;
  final ExerciseRepository repository;
  final SettingsController settings;

  const RoutinesScreen({
    super.key,
    required this.routines,
    required this.repository,
    required this.settings,
  });

  Future<void> _createRoutine(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final name = await showRoutineNameDialog(
      context,
      title: t.newRoutine,
      confirmLabel: t.create,
    );
    if (name == null || !context.mounted) return;

    final routine = await routines.create(name);
    if (!context.mounted) return;
    _openRoutine(context, routine);
  }

  void _openRoutine(BuildContext context, Routine routine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoutineDetailScreen(
          routineId: routine.id,
          routines: routines,
          repository: repository,
          settings: settings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.routinesTitle), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createRoutine(context),
        icon: const Icon(Icons.add),
        label: Text(t.newRoutine),
      ),
      body: ListenableBuilder(
        listenable: routines,
        builder: (context, _) {
          final list = routines.routines;

          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  t.routinesEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return ListView.separated(
            // Extra bottom padding so the button doesn't cover the last card.
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final routine = list[index];
              final count = routine.items.length;
              final seconds = repository.routineSeconds(routine);

              return Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.list_alt,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    routine.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    count == 0
                        ? t.routineExerciseCount(0)
                        : '${t.routineExerciseCount(count)}'
                              ' · ${formatDuration(t, seconds)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openRoutine(context, routine),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
