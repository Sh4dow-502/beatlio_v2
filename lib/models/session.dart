import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';

class Session {
  final String name;
  final int restDuration;
  final List<Serie> series;
  final List<Exercise> exercises;
  final String uid;

  Session({
    required this.name,
    required this.restDuration,
    this.series = const [],
    this.exercises = const [],
    required this.uid,
  });

  Session copyWith({
    String? name,
    int? restDuration,
    List<Serie>? series,
    List<Exercise>? exercises,
  }) {
    return Session(
      name: name ?? this.name,
      restDuration: restDuration ?? this.restDuration,
      uid: uid,
      series: series ?? List.from(this.series),
      exercises: exercises ?? List.from(this.exercises),
    );
  }

  String totalTime() {
    int totalSeconds = 0;

    final totalExercises = this.totalExercises();

    if (restDuration > 0) {
      totalSeconds += restDuration * (totalExercises - 1);
    }

    return formatDuration((totalExercises * 60 + totalSeconds));
  }

  int totalExercises() {
    int total = exercises.length;

    for (var serie in series) {
      total += serie.exercises.length;
    }

    return total;
  }

  int totalExerciseInSerie() {
    // return serie.exercises.length;
    int total = 0;
    for (var serie in series) {
      total += serie.exercises.length;
    }
    return total;
  }
}
