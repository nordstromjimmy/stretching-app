// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Hållning & Stretch';

  @override
  String get exercisesTitle => 'Övningar';

  @override
  String get chooseFigureTitle => 'Välj figur';

  @override
  String get chooseFigureBody =>
      'Vilken figur vill du se på övningsbilderna? Du kan ändra det senare.';

  @override
  String get figureMale => 'Man';

  @override
  String get figureFemale => 'Kvinna';

  @override
  String get changeFigure => 'Byt figur';

  @override
  String get bodyAreaNeck => 'Nacke';

  @override
  String get bodyAreaShoulders => 'Axlar';

  @override
  String get bodyAreaUpperBack => 'Övre rygg';

  @override
  String get bodyAreaLowerBack => 'Ländrygg';

  @override
  String get bodyAreaChest => 'Bröst';

  @override
  String get bodyAreaHips => 'Höfter';

  @override
  String get bodyAreaLegs => 'Ben';

  @override
  String get navHome => 'Hem';

  @override
  String get navRoutines => 'Mina rutiner';

  @override
  String get navExercises => 'Övningar';

  @override
  String get navSettings => 'Inställningar';

  @override
  String get homeTitle => 'Hem';

  @override
  String get streakCurrent => 'Dagar i rad';

  @override
  String get streakLongest => 'Längsta svit';

  @override
  String get sessionsTotal => 'Pass totalt';

  @override
  String get todayDone => 'Du har gjort ett pass idag. Bra jobbat!';

  @override
  String get todayKeepStreak =>
      'Gör ett pass idag för att hålla igång din svit.';

  @override
  String get todayStart => 'Gör ett pass idag för att starta en svit.';

  @override
  String activeDaysThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktiva dagar den här månaden',
      one: '1 aktiv dag den här månaden',
      zero: 'Inga aktiva dagar den här månaden',
    );
    return '$_temp0';
  }

  @override
  String get previousMonth => 'Föregående månad';

  @override
  String get nextMonth => 'Nästa månad';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsFigure => 'Figur på övningsbilderna';

  @override
  String get stepsTitle => 'Så gör du';

  @override
  String get tipsTitle => 'Tips';

  @override
  String get cautionTitle => 'Var försiktig';

  @override
  String get workFriendly => 'Går att göra på jobbet';

  @override
  String get typeStretch => 'Stretch';

  @override
  String get typeMobility => 'Rörlighet';

  @override
  String get typeStrengthening => 'Styrka';

  @override
  String get positionStanding => 'Stående';

  @override
  String get positionSitting => 'Sittande';

  @override
  String get positionFloor => 'På golvet';

  @override
  String get equipmentNone => 'Ingen utrustning';

  @override
  String get equipmentMat => 'Yogamatta';

  @override
  String get equipmentChair => 'Stol';

  @override
  String get equipmentWall => 'Vägg';

  @override
  String get equipmentDoorway => 'Dörröppning';

  @override
  String doseHold(int seconds) {
    return 'Håll $seconds s';
  }

  @override
  String get dosePerSide => 'per sida';

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
  String get routinesTitle => 'Mina rutiner';

  @override
  String get routinesEmpty =>
      'Du har inga rutiner än. Skapa en och lägg till de övningar du vill göra.';

  @override
  String get newRoutine => 'Ny rutin';

  @override
  String get routineNameLabel => 'Namn';

  @override
  String get routineNameHint => 'T.ex. Kvällsstretch';

  @override
  String get routineEmptyExercises =>
      'Inga övningar än. Lägg till de övningar du vill göra i den här rutinen.';

  @override
  String get addExercises => 'Lägg till övningar';

  @override
  String get chooseExercisesTitle => 'Välj övningar';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count övningar',
      one: '1 övning',
      zero: 'Inga övningar',
    );
    return '$_temp0';
  }

  @override
  String totalTime(String duration) {
    return 'Totalt $duration';
  }

  @override
  String get deleteRoutineTitle => 'Ta bort rutinen?';

  @override
  String deleteRoutineBody(String name) {
    return '”$name” tas bort. Det går inte att ångra.';
  }

  @override
  String get startRoutine => 'Starta';

  @override
  String get setupTitle => 'Innan du börjar';

  @override
  String get setupHint =>
      'Ställ in hur länge du vill hålla varje övning. Dina tider sparas till nästa gång.';

  @override
  String get shorter => 'Kortare';

  @override
  String get longer => 'Längre';

  @override
  String playerExerciseOf(int current, int total) {
    return 'Övning $current av $total';
  }

  @override
  String sideOf(int side) {
    return 'Sida $side av 2';
  }

  @override
  String get getReady => 'Gör dig redo';

  @override
  String get switchSide => 'Byt sida';

  @override
  String get upNext => 'Nästa';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Fortsätt';

  @override
  String get previous => 'Föregående';

  @override
  String get skip => 'Hoppa över';

  @override
  String get finishedTitle => 'Bra jobbat!';

  @override
  String get finishedBody => 'Du har gjort klart din rutin.';

  @override
  String get quitTitle => 'Avsluta passet?';

  @override
  String get quitBody => 'Du är mitt i en rutin.';

  @override
  String get quit => 'Avsluta';

  @override
  String get keepGoing => 'Fortsätt';

  @override
  String get cancel => 'Avbryt';

  @override
  String get create => 'Skapa';

  @override
  String get save => 'Spara';

  @override
  String get done => 'Klar';

  @override
  String get rename => 'Byt namn';

  @override
  String get delete => 'Ta bort';

  @override
  String get remove => 'Ta bort';
}
