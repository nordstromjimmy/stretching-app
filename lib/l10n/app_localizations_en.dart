// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Posture & Stretching';

  @override
  String get exercisesTitle => 'Exercises';

  @override
  String get chooseFigureTitle => 'Choose your figure';

  @override
  String get chooseFigureBody =>
      'Which figure do you want to see in the exercise images? You can change this later.';

  @override
  String get figureMale => 'Male';

  @override
  String get figureFemale => 'Female';

  @override
  String get changeFigure => 'Change figure';

  @override
  String get bodyAreaNeck => 'Neck';

  @override
  String get bodyAreaShoulders => 'Shoulders';

  @override
  String get bodyAreaUpperBack => 'Upper back';

  @override
  String get bodyAreaLowerBack => 'Lower back';

  @override
  String get bodyAreaChest => 'Chest';

  @override
  String get bodyAreaHips => 'Hips';

  @override
  String get bodyAreaLegs => 'Legs';

  @override
  String get navHome => 'Home';

  @override
  String get navRoutines => 'My routines';

  @override
  String get navExercises => 'Exercises';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeTitle => 'Home';

  @override
  String get streakCurrent => 'Days in a row';

  @override
  String get streakLongest => 'Longest streak';

  @override
  String get sessionsTotal => 'Sessions';

  @override
  String get todayDone => 'You\'ve done a session today. Nice work!';

  @override
  String get todayKeepStreak => 'Do a session today to keep your streak going.';

  @override
  String get todayStart => 'Do a session today to start a streak.';

  @override
  String activeDaysThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active days this month',
      one: '1 active day this month',
      zero: 'No active days this month',
    );
    return '$_temp0';
  }

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsFigure => 'Figure in exercise images';

  @override
  String get stepsTitle => 'How to do it';

  @override
  String get tipsTitle => 'Tips';

  @override
  String get cautionTitle => 'Be careful';

  @override
  String get workFriendly => 'Can be done at work';

  @override
  String get typeStretch => 'Stretch';

  @override
  String get typeMobility => 'Mobility';

  @override
  String get typeStrengthening => 'Strength';

  @override
  String get positionStanding => 'Standing';

  @override
  String get positionSitting => 'Seated';

  @override
  String get positionFloor => 'On the floor';

  @override
  String get equipmentNone => 'No equipment';

  @override
  String get equipmentMat => 'Yoga mat';

  @override
  String get equipmentChair => 'Chair';

  @override
  String get equipmentWall => 'Wall';

  @override
  String get equipmentDoorway => 'Doorway';

  @override
  String doseHold(int seconds) {
    return 'Hold $seconds s';
  }

  @override
  String get dosePerSide => 'per side';

  @override
  String durationSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationMinutesSeconds(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String get routinesTitle => 'My routines';

  @override
  String get routinesEmpty =>
      'You don\'t have any routines yet. Create one and add the exercises you want to do.';

  @override
  String get newRoutine => 'New routine';

  @override
  String get routineNameLabel => 'Name';

  @override
  String get routineNameHint => 'E.g. Evening stretch';

  @override
  String get routineEmptyExercises =>
      'No exercises yet. Add the exercises you want to do in this routine.';

  @override
  String get addExercises => 'Add exercises';

  @override
  String get chooseExercisesTitle => 'Choose exercises';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
      zero: 'No exercises',
    );
    return '$_temp0';
  }

  @override
  String totalTime(String duration) {
    return 'Total $duration';
  }

  @override
  String get deleteRoutineTitle => 'Delete routine?';

  @override
  String deleteRoutineBody(String name) {
    return '“$name” will be deleted. This can\'t be undone.';
  }

  @override
  String get startRoutine => 'Start';

  @override
  String get setupTitle => 'Before you start';

  @override
  String get setupHint =>
      'Set how long to hold each exercise. Your times are saved for next time.';

  @override
  String get shorter => 'Shorter';

  @override
  String get longer => 'Longer';

  @override
  String playerExerciseOf(int current, int total) {
    return 'Exercise $current of $total';
  }

  @override
  String sideOf(int side) {
    return 'Side $side of 2';
  }

  @override
  String get getReady => 'Get ready';

  @override
  String get switchSide => 'Switch sides';

  @override
  String get upNext => 'Up next';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get previous => 'Previous';

  @override
  String get skip => 'Skip';

  @override
  String get finishedTitle => 'Well done!';

  @override
  String get finishedBody => 'You finished your routine.';

  @override
  String get quitTitle => 'End session?';

  @override
  String get quitBody => 'You\'re in the middle of a routine.';

  @override
  String get quit => 'End';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get rename => 'Rename';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';
}
