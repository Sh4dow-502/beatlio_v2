import 'package:beatlio_v2/mappers/exercise_mapper.dart';
import 'package:beatlio_v2/models/db_models/serie_db_model.dart';
import 'package:beatlio_v2/models/serie.dart';

class SerieMapper {
  static Serie toDomain(SerieDbModel db) {
    return Serie(
      name: db.name,
      uid: db.uid,
      description: db.description,
      durationGlobal: db.durationGlobal,
      bpmGlobal: db.bpmGlobal,
      durationValueGlobal: db.durationValueGlobal,
      bpmValueGlobal: db.bpmValueGlobal,

      exercises: db.exercises.map((e) => ExerciseMapper.toDomain(e)).toList(),
    );
  }
}
