import 'package:beatlio_v2/models/exercise.dart';

class SessionStep {
  final String name;
  final int duration;
  final bool isRest;
  final int bpm;

  const SessionStep({
    required this.name,
    required this.duration,
    required this.isRest,
    this.bpm = 120,
  });

  factory SessionStep.exercise(Exercise exercise) {
    return SessionStep(
      name: exercise.name,
      duration: exercise.duration,
      isRest: false,
      bpm: exercise.bpm,
    );
  }

  factory SessionStep.rest(int durationSeconds) {
    return SessionStep(
      name: 'Descanso',
      duration: durationSeconds,
      isRest: true,
    );
  }
}
