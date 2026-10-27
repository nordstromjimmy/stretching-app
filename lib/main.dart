import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_scope.dart';
import 'data/exercise_repository.dart';
import 'history/history_controller.dart';
import 'l10n/app_localizations.dart';
import 'routines/routine_controller.dart';
import 'screens/choose_figure_screen.dart';
import 'screens/main_shell.dart';
import 'settings/settings_controller.dart';
import 'theme/app_theme.dart';

// TEMPORARY: show the figure selection on every launch while developing.
// Set to false to remember the user's choice again.
const askForFigureEveryLaunch = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsController();
  if (!askForFigureEveryLaunch) {
    await settings.load();
  }

  final repository = ExerciseRepository();
  await repository.getAll(); // Load exercises once at startup

  final routines = RoutineController();
  await routines.load();

  final history = HistoryController();
  await history.load();

  runApp(
    StretchApp(
      settings: settings,
      repository: repository,
      routines: routines,
      history: history,
      currentTab: ValueNotifier<int>(AppTab.home),
    ),
  );
}

class StretchApp extends StatelessWidget {
  final SettingsController settings;
  final ExerciseRepository repository;
  final RoutineController routines;
  final HistoryController history;
  final ValueNotifier<int> currentTab;

  const StretchApp({
    super.key,
    required this.settings,
    required this.repository,
    required this.routines,
    required this.history,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    return AppScope(
      settings: settings,
      repository: repository,
      routines: routines,
      history: history,
      currentTab: currentTab,
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        // Swedish if the phone's language is Swedish, otherwise English.
        // Flutter falls back to the FIRST locale in this list, so English goes first.
        supportedLocales: const [Locale('en'), Locale('sv')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // Rebuilds whenever a setting changes, e.g. after choosing a figure.
        home: ListenableBuilder(
          listenable: settings,
          builder: (context, _) => settings.gender == null
              ? ChooseFigureScreen(settings: settings)
              : MainShell(
                  repository: repository,
                  settings: settings,
                  routines: routines,
                  history: history,
                ),
        ),
      ),
    );
  }
}
