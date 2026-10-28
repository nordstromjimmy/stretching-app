import '../l10n/app_localizations.dart';
import '../models/exercise.dart';

String bodyAreaLabel(AppLocalizations t, BodyArea area) => switch (area) {
  BodyArea.neck => t.bodyAreaNeck,
  BodyArea.shoulders => t.bodyAreaShoulders,
  BodyArea.upperBack => t.bodyAreaUpperBack,
  BodyArea.lowerBack => t.bodyAreaLowerBack,
  BodyArea.chest => t.bodyAreaChest,
  BodyArea.hips => t.bodyAreaHips,
  BodyArea.legs => t.bodyAreaLegs,
};

String typeLabel(AppLocalizations t, ExerciseType type) => switch (type) {
  ExerciseType.stretch => t.typeStretch,
  ExerciseType.mobility => t.typeMobility,
  ExerciseType.strengthening => t.typeStrengthening,
};

String positionLabel(AppLocalizations t, ExercisePosition position) =>
    switch (position) {
      ExercisePosition.standing => t.positionStanding,
      ExercisePosition.sitting => t.positionSitting,
      ExercisePosition.floor => t.positionFloor,
    };

String equipmentLabel(AppLocalizations t, List<String> equipment) {
  if (equipment.isEmpty) return t.equipmentNone;
  return equipment
      .map(
        (item) => switch (item) {
          'mat' => t.equipmentMat,
          'chair' => t.equipmentChair,
          'wall' => t.equipmentWall,
          'doorway' => t.equipmentDoorway,
          _ => item,
        },
      )
      .join(', ');
}

/// E.g. "Håll 30 s per sida" or "Håll 45 s".
String holdLabel(AppLocalizations t, int holdSeconds, bool perSide) => perSide
    ? '${t.doseHold(holdSeconds)} ${t.dosePerSide}'
    : t.doseHold(holdSeconds);

String doseLabel(AppLocalizations t, Dose dose) =>
    holdLabel(t, dose.holdSeconds, dose.perSide);

/// E.g. "45 s", "1 min", "1 min 30 s".
String formatDuration(AppLocalizations t, int seconds) {
  if (seconds < 60) return t.durationSeconds(seconds);
  final minutes = seconds ~/ 60;
  final rest = seconds % 60;
  return rest == 0
      ? t.durationMinutes(minutes)
      : t.durationMinutesSeconds(minutes, rest);
}

/// Clock format for the timer, e.g. "1:05".
String formatClock(int seconds) {
  final minutes = seconds ~/ 60;
  final rest = seconds % 60;
  return '$minutes:${rest.toString().padLeft(2, '0')}';
}

/// Alphabetical comparison of exercise names.
/// In Swedish, å, ä and ö come after z, in that order.
int compareNames(String a, String b, String languageCode) {
  String key(String name) {
    final lower = name.toLowerCase();
    if (languageCode != 'sv') return lower;
    // '{', '|' and '}' are the three characters right after 'z'.
    return lower.replaceAll('å', '{').replaceAll('ä', '|').replaceAll('ö', '}');
  }

  return key(a).compareTo(key(b));
}
