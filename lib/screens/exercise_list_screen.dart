import 'package:flutter/material.dart';

import '../data/exercise_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../settings/settings_controller.dart';
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
  late final Future<List<Exercise>> _exercises = widget.repository.getAll();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final gender = widget.settings.gender ?? FigureGender.male;

    return Scaffold(
      appBar: AppBar(title: Text(t.exercisesTitle), centerTitle: true),
      body: FutureBuilder<List<Exercise>>(
        future: _exercises,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final exercises = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _ExerciseCard(
              exercise: exercises[index],
              gender: gender,
              lang: lang,
            ),
          );
        },
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
                    /* Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: muted),
                        const SizedBox(width: 4),
                        Text(
                          formatDuration(t, exercise.dose.totalSeconds),
                          style: textTheme.bodySmall?.copyWith(color: muted),
                        ),
                      ],
                    ), */
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
