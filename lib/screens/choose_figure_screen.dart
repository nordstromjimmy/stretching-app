import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../settings/settings_controller.dart';

class ChooseFigureScreen extends StatelessWidget {
  final SettingsController settings;

  const ChooseFigureScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(t.chooseFigureTitle, style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(t.chooseFigureBody, style: textTheme.bodyLarge),
              const SizedBox(height: 32),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _FigureOption(
                        gender: FigureGender.male,
                        label: t.figureMale,
                        onTap: () => settings.setGender(FigureGender.male),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _FigureOption(
                        gender: FigureGender.female,
                        label: t.figureFemale,
                        onTap: () => settings.setGender(FigureGender.female),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FigureOption extends StatelessWidget {
  final FigureGender gender;
  final String label;
  final VoidCallback onTap;

  const _FigureOption({
    required this.gender,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/exercises/figure_select/${gender.name}.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
