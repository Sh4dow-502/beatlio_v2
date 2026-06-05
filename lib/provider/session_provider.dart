import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/models/session_step.dart';
import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  List<Serie> _series = [];
  List<Serie> get series => _series;

  SessionStep? _currentExercise;
  SessionStep? get currentExercise => _currentExercise;

  SessionStep? _nextExercise;
  SessionStep? get nextExercise => _nextExercise;

  String _progressText = '';
  String get progressText => _progressText;

  bool _isSessionCompleted = false;
  bool get isSessionCompleted => _isSessionCompleted;

  int _currentExerciseIndex = 0;
  int get currentExerciseIndex => _currentExerciseIndex;

  int _totalExercises = 0;
  int get totalExercises => _totalExercises;

  int _restTimeSeconds = 0;
  int get restTimeSeconds => _restTimeSeconds;

  bool _isSessionInitialized = false;
  bool get isSessionInitialized => _isSessionInitialized;

  bool _isSessionPlaying = false;
  bool get isSessionPlaying => _isSessionPlaying;

  int _sessionResetToken = 0;
  int get sessionResetToken => _sessionResetToken;

  void toggleSessionPlaying() {
    if (!_isSessionInitialized) {
      _isSessionInitialized = true;
    }
    _isSessionPlaying = !_isSessionPlaying;
    notifyListeners();
  }

  void reset() {
    _isSessionPlaying = false;
    _isSessionInitialized = false;
    notifyListeners();
  }

  void pause() {
    _isSessionPlaying = false;
    notifyListeners();
  }

  void pauseFinishedSession() {
    if (_isSessionCompleted) {
      _isSessionPlaying = false;
      // notifyListeners();
    }
  }

  void play() {
    _isSessionPlaying = true;
    notifyListeners();
  }

  void setExercises(List<Exercise> exercises) {
    _exercises = exercises;
    _currentExerciseIndex = 0;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  void setSeries(List<Serie> series) {
    _series = series;
    if (_exercises.isEmpty) {
      _currentExerciseIndex = 0;
      _syncCurrentAndNextExercise();
    }
    notifyListeners();
  }

  void setRestTimeSeconds(int seconds) {
    _restTimeSeconds = seconds;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  void setTotalExercises(int total) {
    _totalExercises = total;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  List<Exercise> _resolvedExercises() {
    if (_exercises.isNotEmpty) {
      return _exercises;
    }

    return _series.expand((serie) => serie.exercises).toList();
  }

  List<SessionStep> _resolvedSteps() {
    final resolvedExercises = _resolvedExercises();
    if (resolvedExercises.isEmpty) {
      return [];
    }

    final steps = <SessionStep>[];
    for (var index = 0; index < resolvedExercises.length; index++) {
      steps.add(SessionStep.exercise(resolvedExercises[index]));

      final hasNextExercise = index < resolvedExercises.length - 1;
      if (_restTimeSeconds > 0 && hasNextExercise) {
        steps.add(SessionStep.rest(_restTimeSeconds));
      }
    }

    return steps;
  }

  SessionStep? _stepAt(int index) {
    final resolvedSteps = _resolvedSteps();
    if (index < 0 || index >= resolvedSteps.length) {
      return null;
    }

    return resolvedSteps[index];
  }

  int? _findNextExerciseIndex(int startIndex) {
    final resolvedSteps = _resolvedSteps();

    for (var index = startIndex; index < resolvedSteps.length; index++) {
      if (!resolvedSteps[index].isRest) {
        return index;
      }
    }

    return null;
  }

  int? _findPreviousExerciseIndex(int startIndex) {
    final resolvedSteps = _resolvedSteps();

    for (var index = startIndex; index >= 0; index--) {
      if (!resolvedSteps[index].isRest) {
        return index;
      }
    }

    return null;
  }

  bool get canGoNextExercise {
    return _findNextExerciseIndex(_currentExerciseIndex + 1) != null;
  }

  bool get canGoPreviousExercise {
    return _findPreviousExerciseIndex(_currentExerciseIndex - 1) != null;
  }

  int _completedExerciseCountAtCurrentStep() {
    final resolvedSteps = _resolvedSteps();
    if (resolvedSteps.isEmpty) {
      return 0;
    }

    final clampedIndex = _currentExerciseIndex.clamp(
      0,
      resolvedSteps.length - 1,
    );
    var completedExercises = 0;

    for (var index = 0; index <= clampedIndex; index++) {
      if (!resolvedSteps[index].isRest) {
        completedExercises++;
      }
    }

    return completedExercises;
  }

  void _syncProgressText() {
    final resolvedExercises = _resolvedExercises();
    final total = _totalExercises > 0
        ? _totalExercises
        : resolvedExercises.length;

    if (total <= 0) {
      _progressText = '0 / 0';
      return;
    }

    final completedExercises = _completedExerciseCountAtCurrentStep();
    final progress = completedExercises.clamp(0, total);
    _progressText = '$progress / $total';
  }

  void _syncCurrentAndNextExercise() {
    final currentStep = _stepAt(_currentExerciseIndex);
    if (currentStep == null) {
      _currentExercise = null;
      _nextExercise = null;
      _isSessionCompleted = true;
      // Stop playing when the session completes to avoid timers/metronome continuing.
      _isSessionPlaying = false;
      _syncProgressText();
      return;
    }

    _currentExercise = currentStep;
    _nextExercise = _stepAt(_currentExerciseIndex + 1);
    _isSessionCompleted = false;
    _syncProgressText();
  }

  void goToNextExercise() {
    final nextExerciseIndex = _findNextExerciseIndex(_currentExerciseIndex + 1);

    if (nextExerciseIndex == null) {
      _currentExerciseIndex = _resolvedSteps().length;
      _syncCurrentAndNextExercise();
      notifyListeners();
      return;
    }

    _currentExerciseIndex = nextExerciseIndex;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  /// Advance exactly one step in the resolved steps sequence (includes rests).
  /// This is used for automatic timer-driven advancement so rests are not skipped.
  void advanceOneStep() {
    final resolved = _resolvedSteps();

    if (resolved.isEmpty) {
      _currentExerciseIndex = 0;
      _syncCurrentAndNextExercise();
      notifyListeners();
      return;
    }

    if (_currentExerciseIndex >= resolved.length - 1) {
      _currentExerciseIndex = resolved.length;
      _syncCurrentAndNextExercise();
      notifyListeners();
      return;
    }

    _currentExerciseIndex = _currentExerciseIndex + 1;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  void goToPreviousExercise() {
    final previousExerciseIndex = _findPreviousExerciseIndex(
      _currentExerciseIndex - 1,
    );

    if (previousExerciseIndex == null) {
      _currentExerciseIndex = 0;
      _syncCurrentAndNextExercise();
      notifyListeners();
      return;
    }

    _currentExerciseIndex = previousExerciseIndex;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  void setCurrentExercise() {
    goToNextExercise();
  }

  void setNextExercise() {
    goToNextExercise();
  }

  void goToNextStep() {
    final resolved = _resolvedSteps();

    if (_currentExerciseIndex >= resolved.length - 1) {
      return;
    }

    _currentExerciseIndex++;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  void goToPreviousStep() {
    if (_currentExerciseIndex <= 0) {
      return;
    }

    _currentExerciseIndex--;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }

  void setInitialProgressText(String progressText) {
    _progressText = progressText;
    notifyListeners();
  }

  bool get canGoNextStep {
    return _currentExerciseIndex < _resolvedSteps().length - 1;
  }

  bool get canGoPreviousStep {
    return _currentExerciseIndex > 0;
  }

  void resetSession() {
    _sessionResetToken++;
    _currentExerciseIndex = 0;
    _isSessionPlaying = false;
    _isSessionInitialized = false;
    _syncCurrentAndNextExercise();
    notifyListeners();
  }
}
