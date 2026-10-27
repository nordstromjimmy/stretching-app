/// A finished routine, saved when the player reaches "Well done!".
class CompletedSession {
  final DateTime completedAt;
  final String routineName;
  final int exerciseCount;
  final int seconds;

  const CompletedSession({
    required this.completedAt,
    required this.routineName,
    required this.exerciseCount,
    required this.seconds,
  });

  factory CompletedSession.fromJson(Map<String, dynamic> json) =>
      CompletedSession(
        completedAt: DateTime.parse(json['completedAt'] as String),
        routineName: json['routineName'] as String,
        exerciseCount: json['exerciseCount'] as int,
        seconds: json['seconds'] as int,
      );

  Map<String, dynamic> toJson() => {
    'completedAt': completedAt.toIso8601String(),
    'routineName': routineName,
    'exerciseCount': exerciseCount,
    'seconds': seconds,
  };
}
