import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise.dart';

/// Holds the user's settings and saves them on the phone.
/// Screens listen to it and rebuild when something changes.
class SettingsController extends ChangeNotifier {
  static const _genderKey = 'figure_gender';

  FigureGender? _gender;

  /// null means the user hasn't chosen yet (first launch).
  FigureGender? get gender => _gender;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_genderKey);
    _gender = value == null ? null : FigureGender.values.asNameMap()[value];
  }

  Future<void> setGender(FigureGender gender) async {
    _gender = gender;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, gender.name);
  }
}
