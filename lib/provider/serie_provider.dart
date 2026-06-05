import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/models/serie.dart';
import 'package:flutter/material.dart';

class SerieProvider extends ChangeNotifier {
  bool metronomeGlobal = true;
  bool bpmGlobal = true;
  bool get isMetronomeGlobal => metronomeGlobal;
  bool get isBpmGlobal => bpmGlobal;

  void addExercise(Exercise exercise, Serie serie, int serieId) {
    // serie.exercises.add(exercise);

    notifyListeners();
  }

  void changeMetronomeGlobal(bool value) {
    metronomeGlobal = value;
    // metronomeGlobal = value; --- IGNORE ---
    notifyListeners();
  }

  void changeBpmGlobal(bool value) {
    bpmGlobal = value;
    // bpmGlobal = value; --- IGNORE ---
    notifyListeners();
  }
}
