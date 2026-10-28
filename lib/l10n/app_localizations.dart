import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Posture & Stretching'**
  String get appTitle;

  /// No description provided for @exercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @noExercisesForFilter.
  ///
  /// In en, this message translates to:
  /// **'No exercises for this area yet.'**
  String get noExercisesForFilter;

  /// No description provided for @chooseFigureTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your figure'**
  String get chooseFigureTitle;

  /// No description provided for @chooseFigureBody.
  ///
  /// In en, this message translates to:
  /// **'Which figure do you want to see in the exercise images? You can change this later.'**
  String get chooseFigureBody;

  /// No description provided for @figureMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get figureMale;

  /// No description provided for @figureFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get figureFemale;

  /// No description provided for @changeFigure.
  ///
  /// In en, this message translates to:
  /// **'Change figure'**
  String get changeFigure;

  /// No description provided for @bodyAreaNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get bodyAreaNeck;

  /// No description provided for @bodyAreaShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get bodyAreaShoulders;

  /// No description provided for @bodyAreaUpperBack.
  ///
  /// In en, this message translates to:
  /// **'Upper back'**
  String get bodyAreaUpperBack;

  /// No description provided for @bodyAreaLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get bodyAreaLowerBack;

  /// No description provided for @bodyAreaChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get bodyAreaChest;

  /// No description provided for @bodyAreaHips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get bodyAreaHips;

  /// No description provided for @bodyAreaLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get bodyAreaLegs;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navRoutines.
  ///
  /// In en, this message translates to:
  /// **'My routines'**
  String get navRoutines;

  /// No description provided for @navExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get navExercises;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @streakCurrent.
  ///
  /// In en, this message translates to:
  /// **'Days in a row'**
  String get streakCurrent;

  /// No description provided for @streakLongest.
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get streakLongest;

  /// No description provided for @sessionsTotal.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTotal;

  /// No description provided for @todayDone.
  ///
  /// In en, this message translates to:
  /// **'You\'ve done a session today. Nice work!'**
  String get todayDone;

  /// No description provided for @todayKeepStreak.
  ///
  /// In en, this message translates to:
  /// **'Do a session today to keep your streak going.'**
  String get todayKeepStreak;

  /// No description provided for @todayStart.
  ///
  /// In en, this message translates to:
  /// **'Do a session today to start a streak.'**
  String get todayStart;

  /// No description provided for @activeDaysThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No active days this month} =1{1 active day this month} other{{count} active days this month}}'**
  String activeDaysThisMonth(int count);

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsFigure.
  ///
  /// In en, this message translates to:
  /// **'Figure in exercise images'**
  String get settingsFigure;

  /// No description provided for @stepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get stepsTitle;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tipsTitle;

  /// No description provided for @cautionTitle.
  ///
  /// In en, this message translates to:
  /// **'Be careful'**
  String get cautionTitle;

  /// No description provided for @workFriendly.
  ///
  /// In en, this message translates to:
  /// **'Can be done at work'**
  String get workFriendly;

  /// No description provided for @typeStretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch'**
  String get typeStretch;

  /// No description provided for @typeMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get typeMobility;

  /// No description provided for @typeStrengthening.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get typeStrengthening;

  /// No description provided for @positionStanding.
  ///
  /// In en, this message translates to:
  /// **'Standing'**
  String get positionStanding;

  /// No description provided for @positionSitting.
  ///
  /// In en, this message translates to:
  /// **'Seated'**
  String get positionSitting;

  /// No description provided for @positionFloor.
  ///
  /// In en, this message translates to:
  /// **'On the floor'**
  String get positionFloor;

  /// No description provided for @equipmentNone.
  ///
  /// In en, this message translates to:
  /// **'No equipment'**
  String get equipmentNone;

  /// No description provided for @equipmentMat.
  ///
  /// In en, this message translates to:
  /// **'Yoga mat'**
  String get equipmentMat;

  /// No description provided for @equipmentChair.
  ///
  /// In en, this message translates to:
  /// **'Chair'**
  String get equipmentChair;

  /// No description provided for @equipmentWall.
  ///
  /// In en, this message translates to:
  /// **'Wall'**
  String get equipmentWall;

  /// No description provided for @equipmentDoorway.
  ///
  /// In en, this message translates to:
  /// **'Doorway'**
  String get equipmentDoorway;

  /// No description provided for @doseHold.
  ///
  /// In en, this message translates to:
  /// **'Hold {seconds} s'**
  String doseHold(int seconds);

  /// No description provided for @dosePerSide.
  ///
  /// In en, this message translates to:
  /// **'per side'**
  String get dosePerSide;

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String durationSeconds(int seconds);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationMinutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min {seconds} s'**
  String durationMinutesSeconds(int minutes, int seconds);

  /// No description provided for @routinesTitle.
  ///
  /// In en, this message translates to:
  /// **'My routines'**
  String get routinesTitle;

  /// No description provided for @routinesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any routines yet. Create one and add the exercises you want to do.'**
  String get routinesEmpty;

  /// No description provided for @newRoutine.
  ///
  /// In en, this message translates to:
  /// **'New routine'**
  String get newRoutine;

  /// No description provided for @routineNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get routineNameLabel;

  /// No description provided for @routineNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Evening stretch'**
  String get routineNameHint;

  /// No description provided for @routineEmptyExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises yet. Add the exercises you want to do in this routine.'**
  String get routineEmptyExercises;

  /// No description provided for @addExercises.
  ///
  /// In en, this message translates to:
  /// **'Add exercises'**
  String get addExercises;

  /// No description provided for @chooseExercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose exercises'**
  String get chooseExercisesTitle;

  /// No description provided for @routineExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No exercises} =1{1 exercise} other{{count} exercises}}'**
  String routineExerciseCount(int count);

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total {duration}'**
  String totalTime(String duration);

  /// No description provided for @deleteRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete routine?'**
  String get deleteRoutineTitle;

  /// No description provided for @deleteRoutineBody.
  ///
  /// In en, this message translates to:
  /// **'“{name}” will be deleted. This can\'t be undone.'**
  String deleteRoutineBody(String name);

  /// No description provided for @startRoutine.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startRoutine;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get setupTitle;

  /// No description provided for @setupHint.
  ///
  /// In en, this message translates to:
  /// **'Set how long to hold each exercise. Your times are saved for next time.'**
  String get setupHint;

  /// No description provided for @shorter.
  ///
  /// In en, this message translates to:
  /// **'Shorter'**
  String get shorter;

  /// No description provided for @longer.
  ///
  /// In en, this message translates to:
  /// **'Longer'**
  String get longer;

  /// No description provided for @playerExerciseOf.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current} of {total}'**
  String playerExerciseOf(int current, int total);

  /// No description provided for @sideOf.
  ///
  /// In en, this message translates to:
  /// **'Side {side} of 2'**
  String sideOf(int side);

  /// No description provided for @getReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready'**
  String get getReady;

  /// No description provided for @switchSide.
  ///
  /// In en, this message translates to:
  /// **'Switch sides'**
  String get switchSide;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get upNext;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get finishedTitle;

  /// No description provided for @finishedBody.
  ///
  /// In en, this message translates to:
  /// **'You finished your routine.'**
  String get finishedBody;

  /// No description provided for @quitTitle.
  ///
  /// In en, this message translates to:
  /// **'End session?'**
  String get quitTitle;

  /// No description provided for @quitBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the middle of a routine.'**
  String get quitBody;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get quit;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
