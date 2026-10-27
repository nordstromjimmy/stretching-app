import 'package:flutter/material.dart';

import '../data/exercise_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../utils/labels.dart';

class ChooseExercisesScreen extends StatefulWidget {
  final ExerciseRepository repository;
  final FigureGender gender;
  final List<String> initialSelected;

  const ChooseExercisesScreen({
    super.key,
    required this.repository,
    required this.gender,
    required this.initialSelected,
  });

  @override
  State<ChooseExercisesScreen> createState() => _ChooseExercisesScreenState();
}

class _ChooseExercisesScreenState extends State<ChooseExercisesScreen> {
  late final Set<String> _selected = widget.initialSelected.toSet();
  final List<String> _addedOrder = [];

  void _toggle(String id) {
    setState(() {
      if (_selected.remove(id)) {
        _addedOrder.remove(id);
      } else {
        _selected.add(id);
        if (!widget.initialSelected.contains(id)) _addedOrder.add(id);
      }
    });
  }

  void _done() {
    // Keep the existing order, then append newly added exercises.
    final result = [
      ...widget.initialSelected.where(_selected.contains),
      ..._addedOrder,
    ];
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final exercises = widget.repository.all;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.chooseExercisesTitle),
        actions: [TextButton(onPressed: _done, child: Text(t.done))],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final selected = _selected.contains(exercise.id);

          return ListTile(
            onTap: () => _toggle(exercise.id),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                exercise.imagePath(widget.gender),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            title: Text(exercise.name.of(lang)),
            subtitle: Text(
              '${exercise.bodyAreas.map((a) => bodyAreaLabel(t, a)).join(' · ')}'
              '\n${formatDuration(t, exercise.dose.totalSeconds)}',
              style: TextStyle(color: muted),
            ),
            isThreeLine: true,
            trailing: Checkbox(
              value: selected,
              onChanged: (_) => _toggle(exercise.id),
            ),
          );
        },
      ),
    );
  }
}
