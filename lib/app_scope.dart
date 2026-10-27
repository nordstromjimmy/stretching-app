import 'package:flutter/widgets.dart';

import 'data/exercise_repository.dart';
import 'history/history_controller.dart';
import 'routines/routine_controller.dart';
import 'settings/settings_controller.dart';

/// The tabs in the bottom bar, in order.
class AppTab {
  static const int home = 0;
  static const int routines = 1;
  static const int exercises = 2;
  static const int settings = 3;
}

/// Makes the app's controllers available to every screen:
///   final history = AppScope.of(context).history;
class AppScope extends InheritedWidget {
  final SettingsController settings;
  final ExerciseRepository repository;
  final RoutineController routines;
  final HistoryController history;

  /// The selected bottom bar tab. Set it to switch tab, e.g.
  ///   AppScope.read(context).currentTab.value = AppTab.home;
  final ValueNotifier<int> currentTab;

  const AppScope({
    super.key,
    required this.settings,
    required this.repository,
    required this.routines,
    required this.history,
    required this.currentTab,
    required super.child,
  });

  /// Use in build methods.
  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found above this widget');
    return scope!;
  }

  /// Use outside build methods, e.g. in callbacks and timers.
  static AppScope read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found above this widget');
    return scope!;
  }

  // The controllers notify their own listeners, so this widget never needs to.
  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
