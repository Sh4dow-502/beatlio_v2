import 'package:beatlio_v2/mappers/exercise_mapper.dart';
import 'package:beatlio_v2/mappers/serie_mapper.dart';
import 'package:beatlio_v2/models/db_models/session_db_model.dart';
import 'package:beatlio_v2/models/session.dart';

class SessionMapper {
  static Session toDomain(SessionDbModel db) {
    return Session(
      name: db.name,
      restDuration: db.restDuration,
      uid: db.uid,

      series: db.series.map((s) => SerieMapper.toDomain(s)).toList(),

      exercises: db.exercises.map((e) => ExerciseMapper.toDomain(e)).toList(),
    );
  }
}
