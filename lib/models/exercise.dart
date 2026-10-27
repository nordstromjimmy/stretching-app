/// Text stored in both languages, e.g. {"sv": "Barnets position", "en": "Child's pose"}.
class LocalizedText {
  final Map<String, String> _values;

  const LocalizedText(this._values);

  factory LocalizedText.fromJson(Map<String, dynamic> json) =>
      LocalizedText(json.map((key, value) => MapEntry(key, value as String)));

  /// Returns the text for the language code ("sv" or "en"), falling back to English.
  String of(String languageCode) =>
      _values[languageCode] ?? _values['en'] ?? '';
}

/// A list of texts in both languages, used for steps and tips.
class LocalizedList {
  final Map<String, List<String>> _values;

  const LocalizedList(this._values);

  factory LocalizedList.fromJson(Map<String, dynamic> json) => LocalizedList(
    json.map((key, value) => MapEntry(key, List<String>.from(value as List))),
  );

  List<String> of(String languageCode) =>
      _values[languageCode] ?? _values['en'] ?? const [];
}

enum BodyArea {
  neck('neck'),
  shoulders('shoulders'),
  upperBack('upper_back'),
  lowerBack('lower_back'),
  chest('chest'),
  hips('hips'),
  legs('legs');

  /// The value used in exercises.json.
  final String jsonValue;
  const BodyArea(this.jsonValue);

  static BodyArea fromJson(String value) => BodyArea.values.firstWhere(
    (area) => area.jsonValue == value,
    orElse: () => throw FormatException('Unknown body area: "$value"'),
  );
}

enum ExerciseType { stretch, mobility, strengthening }

enum ExercisePosition { standing, sitting, floor }

/// Which figure the user wants to see in the images.
enum FigureGender { male, female }

class Dose {
  /// Default hold time for one side (or the whole exercise if not per side).
  final int holdSeconds;

  /// True if the exercise is done once on each side.
  final bool perSide;

  const Dose({required this.holdSeconds, required this.perSide});

  int get sides => perSide ? 2 : 1;

  /// Total time, e.g. 45 s per side = 90 s.
  int get totalSeconds => holdSeconds * sides;

  factory Dose.fromJson(Map<String, dynamic> json) => Dose(
    holdSeconds: json['holdSeconds'] as int,
    perSide: (json['perSide'] as bool?) ?? false,
  );
}

class Exercise {
  final String id;
  final LocalizedText name;
  final LocalizedText summary;
  final LocalizedList steps;
  final LocalizedList tips;
  final List<BodyArea> bodyAreas;
  final ExerciseType type;
  final ExercisePosition position;
  final List<String> equipment;
  final Dose dose;
  final int difficulty;
  final bool workFriendly;
  final LocalizedText? caution;

  const Exercise({
    required this.id,
    required this.name,
    required this.summary,
    required this.steps,
    required this.tips,
    required this.bodyAreas,
    required this.type,
    required this.position,
    required this.equipment,
    required this.dose,
    required this.difficulty,
    required this.workFriendly,
    required this.caution,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    try {
      return Exercise(
        id: id,
        name: LocalizedText.fromJson(json['name']),
        summary: LocalizedText.fromJson(json['summary']),
        steps: LocalizedList.fromJson(json['steps']),
        tips: LocalizedList.fromJson(json['tips']),
        bodyAreas: (json['bodyAreas'] as List)
            .map((value) => BodyArea.fromJson(value as String))
            .toList(),
        type: ExerciseType.values.byName(json['type'] as String),
        position: ExercisePosition.values.byName(json['position'] as String),
        equipment: List<String>.from(json['equipment'] as List),
        dose: Dose.fromJson(json['dose']),
        difficulty: json['difficulty'] as int,
        workFriendly: json['workFriendly'] as bool,
        caution: json['caution'] == null
            ? null
            : LocalizedText.fromJson(json['caution']),
      );
    } catch (e) {
      // Makes typos in exercises.json easy to find.
      throw FormatException('Error in exercise "$id": $e');
    }
  }

  /// Image path, e.g. assets/exercises/childs_pose/female.png
  String imagePath(FigureGender gender) =>
      'assets/exercises/$id/${gender.name}.png';
}
