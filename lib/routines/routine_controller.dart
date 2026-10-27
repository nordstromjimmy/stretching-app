import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/routine.dart';

/// Keeps the user's routines in memory and saves them on the phone.
/// Screens listen to it and rebuild when something changes.
class RoutineController extends ChangeNotifier {
  static const _storageKey = 'routines';

  final List<Routine> _routines = [];

  List<Routine> get routines => List.unmodifiable(_routines);

  Routine? byId(String id) {
    for (final routine in _routines) {
      if (routine.id == id) return routine;
    }
    return null;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;

    final list = jsonDecode(raw) as List;
    _routines
      ..clear()
      ..addAll(
        list.map((item) => Routine.fromJson(item as Map<String, dynamic>)),
      );
    notifyListeners();
  }

  Future<Routine> create(String name) async {
    final routine = Routine(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      items: const [],
      createdAt: DateTime.now(),
    );
    _routines.add(routine);
    notifyListeners();
    await _save();
    return routine;
  }

  Future<void> rename(String id, String name) =>
      _update(id, (routine) => routine.copyWith(name: name.trim()));

  /// Sets which exercises are in the routine and in what order.
  /// Custom hold times are kept for exercises that stay in the routine.
  Future<void> setExercises(String id, List<String> exerciseIds) =>
      _update(id, (routine) {
        final existing = {
          for (final item in routine.items) item.exerciseId: item,
        };
        return routine.copyWith(
          items: [
            for (final exerciseId in exerciseIds)
              existing[exerciseId] ?? RoutineItem(exerciseId: exerciseId),
          ],
        );
      });

  Future<void> removeExercise(String id, String exerciseId) => _update(
    id,
    (routine) => routine.copyWith(
      items: routine.items
          .where((item) => item.exerciseId != exerciseId)
          .toList(),
    ),
  );

  /// Saves a custom hold time (per side) for one exercise in the routine.
  Future<void> setHoldSeconds(String id, String exerciseId, int seconds) =>
      _update(
        id,
        (routine) => routine.copyWith(
          items: [
            for (final item in routine.items)
              item.exerciseId == exerciseId
                  ? item.withHoldSeconds(seconds)
                  : item,
          ],
        ),
      );

  Future<void> delete(String id) async {
    _routines.removeWhere((routine) => routine.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> _update(String id, Routine Function(Routine) change) async {
    final index = _routines.indexWhere((routine) => routine.id == id);
    if (index == -1) return;
    _routines[index] = change(_routines[index]);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(
      _routines.map((routine) => routine.toJson()).toList(),
    );
    await prefs.setString(_storageKey, raw);
  }
}
