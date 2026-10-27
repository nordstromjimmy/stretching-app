import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../settings/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settings;

  const SettingsScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.settingsFigure, style: textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<FigureGender>(
            segments: [
              ButtonSegment(
                value: FigureGender.male,
                label: Text(t.figureMale),
                icon: const Icon(Icons.man),
              ),
              ButtonSegment(
                value: FigureGender.female,
                label: Text(t.figureFemale),
                icon: const Icon(Icons.woman),
              ),
            ],
            selected: {settings.gender ?? FigureGender.male},
            onSelectionChanged: (selection) =>
                settings.setGender(selection.first),
          ),
        ],
      ),
    );
  }
}
