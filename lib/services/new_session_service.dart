import 'package:beatlio_v2/models/db_models/exercise_db_model.dart';
import 'package:beatlio_v2/models/db_models/serie_db_model.dart';
import 'package:beatlio_v2/models/db_models/session_db_model.dart';
import 'package:beatlio_v2/models/session.dart';
import 'package:beatlio_v2/objectbox.g.dart';

class NewSessionService {
  final Box<SessionDbModel> _box;
  final Box<SerieDbModel> _serieBox;
  final Box<ExerciseDbModel> _exerciseBox;
  NewSessionService(Store store)
    : _box = store.box<SessionDbModel>(),
      _serieBox = store.box<SerieDbModel>(),
      _exerciseBox = store.box<ExerciseDbModel>();

  void saveSession(Session session) {
    final existingSession = _box
        .query(SessionDbModel_.uid.equals(session.uid))
        .build()
        .findFirst();

    final existingSeriesByUid = <String, SerieDbModel>{};
    final existingExercisesByUid = <String, ExerciseDbModel>{};

    if (existingSession != null) {
      for (final serie in existingSession.series) {
        existingSeriesByUid[serie.uid] = serie;
        for (final exercise in serie.exercises) {
          existingExercisesByUid[exercise.uid] = exercise;
        }
      }

      for (final exercise in existingSession.exercises) {
        existingExercisesByUid[exercise.uid] = exercise;
      }
    }

    final sessionDbModel = SessionDbModel(
      name: session.name,
      restDuration: session.restDuration,
      uid: session.uid,
    );

    if (existingSession != null) {
      sessionDbModel.id = existingSession.id;
    }

    final usedSerieIds = <int>{};
    final usedExerciseIds = <int>{};

    for (final serie in session.series) {
      final SerieDbModel serieDbModel = SerieDbModel(
        name: serie.name,
        uid: serie.uid,
        description: serie.description,
        durationGlobal: serie.durationGlobal,
        bpmGlobal: serie.bpmGlobal,
        durationValueGlobal: serie.durationValueGlobal,
        bpmValueGlobal: serie.bpmValueGlobal,
      );

      final existingSerie = existingSeriesByUid[serie.uid];
      if (existingSerie != null) {
        serieDbModel.id = existingSerie.id;
        usedSerieIds.add(existingSerie.id);
      }

      serieDbModel.session.target = sessionDbModel;
      for (final exercise in serie.exercises) {
        final ExerciseDbModel exerciseDbModel = ExerciseDbModel(
          name: exercise.name,
          duration: exercise.duration,
          description: exercise.description,
          bpm: exercise.bpm,
          uid: exercise.uid,
        );

        final existingExercise = existingExercisesByUid[exercise.uid];
        if (existingExercise != null) {
          exerciseDbModel.id = existingExercise.id;
          usedExerciseIds.add(existingExercise.id);
        }

        exerciseDbModel.serie.target = serieDbModel;

        serieDbModel.exercises.add(exerciseDbModel);
      }

      sessionDbModel.series.add(serieDbModel);
    }

    for (final exercise in session.exercises) {
      final exerciseDbModel = ExerciseDbModel(
        name: exercise.name,
        duration: exercise.duration,
        description: exercise.description,
        bpm: exercise.bpm,
        uid: exercise.uid,
      );

      final existingExercise = existingExercisesByUid[exercise.uid];
      if (existingExercise != null) {
        exerciseDbModel.id = existingExercise.id;
        usedExerciseIds.add(existingExercise.id);
      }

      exerciseDbModel.session.target = sessionDbModel;

      sessionDbModel.exercises.add(exerciseDbModel);
    }

    _box.put(sessionDbModel);

    if (existingSession != null) {
      final orphanSeriesIds = existingSession.series
          .map((serie) => serie.id)
          .where((id) => id > 0 && !usedSerieIds.contains(id))
          .toList();

      final orphanExerciseIds = existingSession.exercises
          .map((exercise) => exercise.id)
          .where((id) => id > 0 && !usedExerciseIds.contains(id))
          .toList();

      final orphanSerieExerciseIds = existingSession.series
          .expand((serie) => serie.exercises)
          .map((exercise) => exercise.id)
          .where((id) => id > 0 && !usedExerciseIds.contains(id))
          .toList();

      final allOrphanExerciseIds = {
        ...orphanExerciseIds,
        ...orphanSerieExerciseIds,
      }.toList();

      if (allOrphanExerciseIds.isNotEmpty) {
        _exerciseBox.removeMany(allOrphanExerciseIds);
      }

      if (orphanSeriesIds.isNotEmpty) {
        _serieBox.removeMany(orphanSeriesIds);
      }
    }
  }

  Future<List<SessionDbModel>> getAllSessions() async {
    return _box.getAll();
  }

  Future<void> deleteSession(String uid) async {
    final sessionToDelete = _box
        .query(SessionDbModel_.uid.equals(uid))
        .build()
        .findFirst();

    if (sessionToDelete != null) {
      _box.remove(sessionToDelete.id);
    }
  }
}
