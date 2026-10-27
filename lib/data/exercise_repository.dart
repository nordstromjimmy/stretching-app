import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/exercise.dart';
import '../models/routine.dart';

/// Loads exercises.json once and keeps the exercises in memory.
/// Call getAll() once at startup; after that the sync methods can be used.
class ExerciseRepository {
  List<Exercise>? _cache;

  Future<List<Exercise>> getAll() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('assets/data/exercises.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _cache = (json['exercises'] as List)
        .map((item) => Exercise.fromJson(item as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  /// All exercises (empty until getAll() has completed).
  List<Exercise> get all => _cache ?? const [];

  /// Finds an exercise by id, or null if it doesn't exist.
  Exercise? find(String id) {
    for (final exercise in all) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  /// Total time for a routine, including custom hold times.
  int routineSeconds(Routine routine) {
    var total = 0;
    for (final item in routine.items) {
      final exercise = find(item.exerciseId);
      if (exercise != null) total += item.totalFor(exercise);
    }
    return total;
  }

  Future<List<Exercise>> getByBodyArea(BodyArea area) async {
    final all = await getAll();
    return all.where((exercise) => exercise.bodyAreas.contains(area)).toList();
  }
}
