import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';

class Serie {
  final String name;
  final String? description;
  final List<Exercise> exercises;
  final bool durationGlobal;
  final bool bpmGlobal;
  final String uid;
  int? durationValueGlobal;
  int? bpmValueGlobal;

  Serie({
    required this.name,
    required this.uid,
    this.description = '',
    this.exercises = const [],
    required this.durationGlobal,
    required this.bpmGlobal,
    this.durationValueGlobal,
    this.bpmValueGlobal,
  });

  @override
  String toString() {
    return 'Serie{name: $name, description: $description, exercises: $exercises, durationValueGlobal: $durationValueGlobal, bpmGlobal: $bpmGlobal, durationGlobal: $durationGlobal, bpmValueGlobal: $bpmValueGlobal}';
  }

  Serie copyWith({
    String? name,
    String? description,
    bool? bpmGlobal,
    bool? durationGlobal,
    int? bpmValueGlobal,
    int? durationValueGlobal,
    List<Exercise>? exercises,
  }) {
    return Serie(
      name: name ?? this.name,
      uid: uid,
      description: description ?? this.description,
      bpmGlobal: bpmGlobal ?? this.bpmGlobal,
      durationGlobal: durationGlobal ?? this.durationGlobal,
      bpmValueGlobal: bpmValueGlobal ?? this.bpmValueGlobal,
      durationValueGlobal: durationValueGlobal ?? this.durationValueGlobal,
      // List.from es vital para que la nueva lista sea independiente de la anterior
      exercises: exercises ?? List.from(this.exercises),
    );
  }

  String totalTime() {
    int totalSeconds = 0;
    for (var exercise in exercises) {
      totalSeconds += exercise.duration;
    }

    return formatDuration(totalSeconds);
    // return '${minutes}m ${seconds}s';
  }

  int totalTimeInSeconds() {
    int totalSeconds = 0;
    for (var exercise in exercises) {
      totalSeconds += exercise.duration;
    }
    return totalSeconds;
  }

  int totalExercises() {
    return exercises.length;
  }
}
