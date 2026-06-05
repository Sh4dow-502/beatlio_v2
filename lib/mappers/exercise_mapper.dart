import 'package:beatlio_v2/models/db_models/exercise_db_model.dart';
import 'package:beatlio_v2/models/exercise.dart';

class ExerciseMapper {
  static Exercise toDomain(ExerciseDbModel db) {
    return Exercise(
      name: db.name,
      uid: db.uid,
      description: db.description,
      duration: db.duration,
      bpm: db.bpm,
      useGlobalBpm: db.useGlobalBpm,
      useGlobalDuration: db.useGlobalDuration,
    );
  }
}
