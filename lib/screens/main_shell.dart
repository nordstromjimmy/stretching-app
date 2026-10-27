import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/exercise_repository.dart';
import '../history/history_controller.dart';
import '../l10n/app_localizations.dart';
import '../routines/routine_controller.dart';
import '../settings/settings_controller.dart';
import 'exercise_list_screen.dart';
import 'home_screen.dart';
import 'routines_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatelessWidget {
  final ExerciseRepository repository;
  final SettingsController settings;
  final RoutineController routines;
  final HistoryController history;

  const MainShell({
    super.key,
    required this.repository,
    required this.settings,
    required this.routines,
    required this.history,
  });

  static const double _iconSize = 26;
  static const double _barHeight = 64;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final selectedColor = Theme.of(context).colorScheme.primary;
    final currentTab = AppScope.of(context).currentTab;

    return ValueListenableBuilder<int>(
      valueListenable: currentTab,
      builder: (context, index, _) => Scaffold(
        body: IndexedStack(
          index: index,
          children: [
            const HomeScreen(),
            RoutinesScreen(
              routines: routines,
              repository: repository,
              settings: settings,
            ),
            ExerciseListScreen(repository: repository, settings: settings),
            SettingsScreen(settings: settings),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          height: _barHeight,
          indicatorColor: Colors.transparent,
          // Labels are hidden but still used by screen readers and tooltips.
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: index,
          onDestinationSelected: (newIndex) => currentTab.value = newIndex,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined, size: _iconSize),
              selectedIcon: Icon(
                Icons.home,
                size: _iconSize,
                color: selectedColor,
              ),
              label: t.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.list_alt_outlined, size: _iconSize),
              selectedIcon: Icon(
                Icons.list_alt,
                size: _iconSize,
                color: selectedColor,
              ),
              label: t.navRoutines,
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.self_improvement_outlined,
                size: _iconSize,
              ),
              selectedIcon: Icon(
                Icons.self_improvement,
                size: _iconSize,
                color: selectedColor,
              ),
              label: t.navExercises,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined, size: _iconSize),
              selectedIcon: Icon(
                Icons.settings,
                size: _iconSize,
                color: selectedColor,
              ),
              label: t.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
