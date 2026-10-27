import 'package:flutter/material.dart';

/// All app colors in one place. Change a value here to update the whole app.
class AppColors {
  /// The dark green the rest of the theme is generated from.
  static const Color seed = Color(0xFF2A9D8F);

  /// Warm yellow page background.
  static const Color background = Color(0xFFFAF1D9);

  /// Slightly lighter cream for cards, so they stand out from the background.
  static const Color card = Color(0xFFFFF8E8);

  /// Warm yellow for tags, tiles and other accents.
  static const Color yellow = Color(0xFFF6DE8D);

  /// Deeper yellow, used for the streak flame on dark green.
  static const Color sun = Color(0xFFF4C542);

  /// Background for dialogs and popup menus.
  static const Color dialog = Color(0xFFFCF2D8);
}

ThemeData buildAppTheme() {
  final base = ColorScheme.fromSeed(seedColor: AppColors.seed);

  final scheme = base.copyWith(
    // Backgrounds, from lightest to darkest.
    surface: AppColors.background,
    surfaceContainerLowest: const Color(0xFFFFFDF6),
    surfaceContainerLow: AppColors.card,
    surfaceContainer: const Color(0xFFF5EACB), // bottom bar
    surfaceContainerHigh: const Color(0xFFF0E3BF),
    surfaceContainerHighest: const Color(0xFFEADBB3),

    // Accents: warm yellow instead of the generated light cyan.
    primaryContainer: AppColors.yellow,

    // Warm borders instead of grey.
    outlineVariant: const Color(0xFFDCCDA6),
  );

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    cardTheme: const CardThemeData(color: AppColors.card),

    // Whiter dialogs (create/rename routine, delete, quit session).
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.dialog,
      surfaceTintColor: Colors.transparent,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.dialog,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
