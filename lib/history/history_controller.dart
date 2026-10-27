import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/completed_session.dart';

/// Strips the time, so 2026-10-27 14:32 becomes 2026-10-27 00:00.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Keeps the history of completed sessions and calculates streaks.
class HistoryController extends ChangeNotifier {
  static const _storageKey = 'history';

  final List<CompletedSession> _sessions = [];

  List<CompletedSession> get sessions => List.unmodifiable(_sessions);

  int get totalSessions => _sessions.length;

  /// Every day with at least one completed session.
  Set<DateTime> get completedDays =>
      _sessions.map((session) => dateOnly(session.completedAt)).toSet();

  bool get completedToday => completedDays.contains(dateOnly(DateTime.now()));

  /// Days in a row up to today. If today isn't done yet, the streak
  /// still counts up to yesterday, so it isn't broken until a whole day passes.
  int get currentStreak {
    final days = completedDays;
    var day = dateOnly(DateTime.now());
    if (!days.contains(day)) {
      day = DateTime(day.year, day.month, day.day - 1);
    }

    var count = 0;
    while (days.contains(day)) {
      count++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return count;
  }

  int get longestStreak {
    final days = completedDays.toList()..sort();
    var longest = 0;
    var current = 0;
    DateTime? previous;

    for (final day in days) {
      final isNextDay =
          previous != null &&
          DateTime(previous.year, previous.month, previous.day + 1) == day;
      current = isNextDay ? current + 1 : 1;
      if (current > longest) longest = current;
      previous = day;
    }
    return longest;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;

    final list = jsonDecode(raw) as List;
    _sessions
      ..clear()
      ..addAll(
        list.map(
          (item) => CompletedSession.fromJson(item as Map<String, dynamic>),
        ),
      );
    notifyListeners();
  }

  Future<void> record({
    required String routineName,
    required int exerciseCount,
    required int seconds,
  }) async {
    _sessions.add(
      CompletedSession(
        completedAt: DateTime.now(),
        routineName: routineName,
        exerciseCount: exerciseCount,
        seconds: seconds,
      ),
    );
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_sessions.map((session) => session.toJson()).toList()),
    );
  }
}
