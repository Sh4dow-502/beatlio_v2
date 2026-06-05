import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/models/session.dart';
import 'package:beatlio_v2/services/new_session_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NewSessionProvider extends ChangeNotifier {
  final NewSessionService _service;
  NewSessionProvider(this._service);

  String sessionName = '';
  int sessionRest = 10;
  int fabType = 0;
  bool _errorName = false;
  String? _editingSessionUid;
  String _baselineSignature = '';

  final List<Serie> _series = [];
  final List<Exercise> _exercises = [];
  List<Serie> get series => _series;
  List<Exercise> get exercises => _exercises;
  bool get errorName => _errorName;
  bool get hasUnsavedChanges => _buildSignature() != _baselineSignature;

  void resetSession() {
    sessionName = '';
    sessionRest = 10;
    fabType = 0;
    _errorName = false;
    _editingSessionUid = null;
    _series.clear();
    _exercises.clear();
    _baselineSignature = _buildSignature();
    notifyListeners();
  }

  void loadSession(Session session) {
    sessionName = session.name;
    sessionRest = session.restDuration;
    fabType = 0;
    _errorName = false;
    _editingSessionUid = session.uid;

    _series
      ..clear()
      ..addAll(session.series.map((serie) => serie.copyWith()));

    _exercises
      ..clear()
      ..addAll(
        session.exercises.map(
          (exercise) => Exercise(
            name: exercise.name,
            uid: exercise.uid,
            description: exercise.description,
            duration: exercise.duration,
            bpm: exercise.bpm,
            useGlobalBpm: exercise.useGlobalBpm,
            useGlobalDuration: exercise.useGlobalDuration,
          ),
        ),
      );

    _baselineSignature = _buildSignature();
    notifyListeners();
  }

  void addSerie(Serie serie) {
    _series.add(serie);
    notifyListeners();
  }

  void setSessionName(String name) {
    sessionName = name;
  }

  bool validateSessionName() {
    _errorName = sessionName.trim().isEmpty;
    notifyListeners();
    return !_errorName;
  }

  bool validateHasData() {
    return sessionName.trim().isNotEmpty &&
        (_series.isNotEmpty || _exercises.isNotEmpty);
  }

  bool validateHasSeries() {
    return _series.any((serie) => serie.exercises.isNotEmpty);
  }

  bool validateHasExercises() {
    return _exercises.isNotEmpty;
  }

  void setSessionRest(int rest) {
    sessionRest = rest;
    notifyListeners();
  }

  void addExerciseInSerie(Exercise exercise, int serieIndex) {
    final serie = _series[serieIndex];
    final newExerciseList = List<Exercise>.from(serie.exercises);
    newExerciseList.add(exercise);
    _series[serieIndex] = serie.copyWith(exercises: newExerciseList);
    notifyListeners();
  }

  void addExerciseInSerieByUid(Exercise exercise, String serieUid) {
    final serieIndex = _series.indexWhere((serie) => serie.uid == serieUid);
    if (serieIndex == -1) return;
    addExerciseInSerie(exercise, serieIndex);
  }

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(int exerciseIndex) {
    _exercises.removeAt(exerciseIndex);
    notifyListeners();
  }

  void deleteExercise(String uid) {
    _exercises.removeWhere((exercise) => exercise.uid == uid);
    notifyListeners();
  }

  void deleteSerie(String uid) {
    _series.removeWhere((serie) => serie.uid == uid);
    notifyListeners();
  }

  void deleteExerciseInSerieByUid(String serieUid, String exerciseUid) {
    final serieIndex = _series.indexWhere((serie) => serie.uid == serieUid);
    if (serieIndex == -1) return;
    final serie = _series[serieIndex];
    final newExerciseList = List<Exercise>.from(
      serie.exercises.where((exercise) => exercise.uid != exerciseUid),
    );
    _series[serieIndex] = serie.copyWith(exercises: newExerciseList);
    notifyListeners();
  }

  void removeExerciseInSerie(int exerciseIndex, int serieIndex) {
    final serie = _series[serieIndex];
    final newExerciseList = List<Exercise>.from(serie.exercises);
    newExerciseList.removeAt(exerciseIndex);
    _series[serieIndex] = serie.copyWith(exercises: newExerciseList);
    notifyListeners();
  }

  void removeSerie(int serieIndex) {
    _series.removeAt(serieIndex);
    notifyListeners();
  }

  void editSerie(int serieIndex, Serie newSerie) {
    _series[serieIndex] = newSerie;
    notifyListeners();
  }

  void editSerieByUid(String uid, Serie newSerie) {
    final serieIndex = _series.indexWhere((serie) => serie.uid == uid);
    if (serieIndex == -1) return;
    editSerie(serieIndex, newSerie);
  }

  void editExerciseInSerie(
    int exerciseIndex,
    int serieIndex,
    Exercise newExercise,
  ) {
    final serie = _series[serieIndex];
    final newExerciseList = List<Exercise>.from(serie.exercises);
    newExerciseList[exerciseIndex] = newExercise;
    _series[serieIndex] = serie.copyWith(exercises: newExerciseList);
    notifyListeners();
  }

  void editExerciseByUid(String uid, Exercise newExercise) {
    final exerciseIndex = _exercises.indexWhere(
      (exercise) => exercise.uid == uid,
    );
    if (exerciseIndex == -1) return;
    editExercise(exerciseIndex, newExercise);
  }

  void editExerciseInSerieByUid(
    String serieUid,
    String exerciseUid,
    Exercise newExercise,
  ) {
    final serieIndex = _series.indexWhere((serie) => serie.uid == serieUid);
    if (serieIndex == -1) return;
    final serie = _series[serieIndex];
    final exerciseIndex = serie.exercises.indexWhere(
      (exercise) => exercise.uid == exerciseUid,
    );
    if (exerciseIndex == -1) return;
    editExerciseInSerie(exerciseIndex, serieIndex, newExercise);
  }

  void editExercise(int exerciseIndex, Exercise newExercise) {
    _exercises[exerciseIndex] = newExercise;
    notifyListeners();
  }

  void reorderExercise(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final exercise = _exercises.removeAt(oldIndex);
    _exercises.insert(newIndex, exercise);
    notifyListeners();
  }

  void reorderSerie(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final serie = _series.removeAt(oldIndex);
    _series.insert(newIndex, serie);
    notifyListeners();
  }

  void reorderExerciseInSerie(int oldIndex, int newIndex, int serieIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final serie = _series[serieIndex];
    final newExerciseList = List<Exercise>.from(serie.exercises);
    final exercise = newExerciseList.removeAt(oldIndex);
    newExerciseList.insert(newIndex, exercise);
    _series[serieIndex] = serie.copyWith(exercises: newExerciseList);
    notifyListeners();
  }

  void reorderExerciseInSerieByUid(
    String serieUid,
    int oldIndex,
    int newIndex,
  ) {
    final serieIndex = _series.indexWhere((serie) => serie.uid == serieUid);
    if (serieIndex == -1) return;
    reorderExerciseInSerie(oldIndex, newIndex, serieIndex);
  }

  String saveSession() {
    final validateName = validateSessionName();
    if (!validateName) return "empty";

    final hasSeries = validateHasSeries();
    final hasExercises = validateHasExercises();
    if (!hasSeries && !hasExercises) {
      return "emptyData";
    }

    final Session session = Session(
      name: sessionName,
      restDuration: sessionRest,
      series: _series,
      exercises: _exercises,
      uid: _editingSessionUid ?? Uuid().v4(),
    );

    _service.saveSession(session);
    _baselineSignature = _buildSignature();

    // _service.saveSession(
    //   sessionName: sessionName,
    //   sessionRest: sessionRest,
    //   exercises: _exercises,
    //   series: _series,
    // );
    return "success";
  }

  String _buildSignature() {
    final seriesSignature = _series
        .map(
          (serie) => [
            serie.uid,
            serie.name,
            serie.description ?? '',
            serie.durationGlobal ? '1' : '0',
            serie.bpmGlobal ? '1' : '0',
            serie.durationValueGlobal?.toString() ?? '',
            serie.bpmValueGlobal?.toString() ?? '',
            ...serie.exercises
                .map(
                  (exercise) => [
                    exercise.uid,
                    exercise.name,
                    exercise.description ?? '',
                    exercise.duration.toString(),
                    exercise.bpm.toString(),
                    exercise.useGlobalBpm ? '1' : '0',
                    exercise.useGlobalDuration ? '1' : '0',
                  ].join('|'),
                )
                .toList(),
          ].join('|'),
        )
        .join(';;');

    final exerciseSignature = _exercises
        .map(
          (exercise) => [
            exercise.uid,
            exercise.name,
            exercise.description ?? '',
            exercise.duration.toString(),
            exercise.bpm.toString(),
            exercise.useGlobalBpm ? '1' : '0',
            exercise.useGlobalDuration ? '1' : '0',
          ].join('|'),
        )
        .join(';;');

    return [
      sessionName.trim(),
      sessionRest.toString(),
      _editingSessionUid ?? '',
      seriesSignature,
      exerciseSignature,
    ].join('||');
  }
}
