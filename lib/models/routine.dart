import 'exercise.dart';

/// One exercise in a routine, with an optional custom hold time.
class RoutineItem {
  final String exerciseId;

  /// Custom hold time per side. null = use the exercise's default.
  final int? holdSeconds;

  const RoutineItem({required this.exerciseId, this.holdSeconds});

  int holdFor(Exercise exercise) => holdSeconds ?? exercise.dose.holdSeconds;

  /// Total time for this item, e.g. 45 s per side = 90 s.
  int totalFor(Exercise exercise) => holdFor(exercise) * exercise.dose.sides;

  RoutineItem withHoldSeconds(int? seconds) =>
      RoutineItem(exerciseId: exerciseId, holdSeconds: seconds);

  factory RoutineItem.fromJson(Map<String, dynamic> json) => RoutineItem(
    exerciseId: json['exerciseId'] as String,
    holdSeconds: json['holdSeconds'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    if (holdSeconds != null) 'holdSeconds': holdSeconds,
  };
}

class Routine {
  final String id;
  final String name;
  final List<RoutineItem> items; // in the order they should be done
  final DateTime createdAt;

  const Routine({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
  });

  List<String> get exerciseIds => items.map((item) => item.exerciseId).toList();

  Routine copyWith({String? name, List<RoutineItem>? items}) => Routine(
    id: id,
    name: name ?? this.name,
    items: items ?? this.items,
    createdAt: createdAt,
  );

  factory Routine.fromJson(Map<String, dynamic> json) {
    final List<RoutineItem> items;
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((item) => RoutineItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Older saved format: just a list of exercise ids.
      items = List<String>.from(
        json['exerciseIds'] as List? ?? const [],
      ).map((id) => RoutineItem(exerciseId: id)).toList();
    }

    return Routine(
      id: json['id'] as String,
      name: json['name'] as String,
      items: items,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'items': items.map((item) => item.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };
}
