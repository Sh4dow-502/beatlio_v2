import 'dart:async';

import 'package:beatlio_v2/services/audio_service.dart';
import 'package:flutter/material.dart';

class MetronomeProvider extends ChangeNotifier {
  final AudioService _audioService;

  MetronomeProvider(this._audioService);
  static const int minBpm = 40;
  static const int maxBpm = 300;

  int bpm = 120;
  int compasNumerator = 4;
  int compasDenominator = 4;
  final Set<int> compasAccents = {1};

  final Stopwatch _stopwatch = Stopwatch();

  Timer? _scheduler;
  int _nextBeatIndex = 0;
  int _currentBeat = 1;
  int _visualBeat = 0;
  // final bool _emiting = false;

  int get currentBeat => _visualBeat;
  bool get isRunning => _scheduler != null;
  int get compas => compasNumerator;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool get isFirstBeat => _visualBeat == 1;

  bool isBeatAccented(int beat) {
    return compasAccents.contains(beat);
  }

  bool get currentBeatIsAccented {
    return compasAccents.contains(_visualBeat);
  }

  String get compasLabel => '$compasNumerator/$compasDenominator';

  bool isPlaying = false;

  void togglePlaying() async {
    isPlaying = !isPlaying;

    if (isPlaying) {
      await start();
    } else {
      stop();
    }
    notifyListeners();
  }

  void playClick() async {
    if (!isPlaying) {
      isPlaying = true;
      await start();
    }

    notifyListeners();
  }

  void stopClick() {
    print("STOP CLICK");
    if (isPlaying) {
      isPlaying = false;
      stop();
    }

    // notifyListeners();
  }

  void stopFinishedClick() {
    // stopClick();
    _scheduler?.cancel();

    _scheduler = null;

    _stopwatch
      ..stop()
      ..reset();

    _nextBeatIndex = 0;

    resetBeat();
    playEndSessionSound();
    // stop();
  }

  Future<void> setBpm(int newBpm) async {
    final clamped = newBpm.clamp(minBpm, maxBpm);

    if (clamped == bpm) return;

    bpm = clamped;

    if (isPlaying) {
      await restart();
    }

    notifyListeners();
  }

  void setCompasSignature(int numerator, int denominator) {
    if (compasNumerator == numerator && compasDenominator == denominator) {
      return;
    }

    compasNumerator = numerator;
    compasDenominator = denominator;

    compasAccents.removeWhere((beat) => beat > compasNumerator);

    _currentBeat = 1;

    notifyListeners();
  }

  bool isCompasAccented(int beat) {
    return compasAccents.contains(beat);
  }

  void toggleCompasAccent(int beat) {
    if (beat < 1 || beat > compasNumerator) return;

    if (compasAccents.contains(beat)) {
      compasAccents.remove(beat);
    } else {
      compasAccents.add(beat);
    }

    notifyListeners();
  }

  Future<void> start() async {
    stop();

    _stopwatch.start();

    _nextBeatIndex = 0;

    _scheduler = Timer.periodic(
      const Duration(milliseconds: 2),
      (_) => _tick(),
    );

    print("START scheduler=${identityHashCode(_scheduler)}");

    notifyListeners();
  }

  void _tick() {
    print(
      "TICK scheduler=${identityHashCode(_scheduler)} "
      "playing=$isPlaying",
    );
    // if (_emiting) return;
    if (!isPlaying) {
      return;
    }
    final elapsedUs = _stopwatch.elapsedMicroseconds;

    final beatUs = beatDuration.inMicroseconds;

    while (elapsedUs >= (_nextBeatIndex * beatUs)) {
      _emitBeat();
      _nextBeatIndex++;
    }
  }

  void _emitBeat() {
    print("BEAT");
    _visualBeat = _currentBeat;

    if (compasAccents.contains(_currentBeat)) {
      _audioService.playAccent();
    } else {
      _audioService.playNormal();
    }

    _advanceBeat();

    notifyListeners();
  }

  void _advanceBeat() {
    _currentBeat++;

    if (_currentBeat > compasNumerator) {
      _currentBeat = 1;
    }
  }

  Duration get beatDuration {
    return Duration(microseconds: (60000000 / bpm).round());
  }

  void resetBeat() {
    _currentBeat = 1;
    _visualBeat = 0;
  }

  Future<void> restart() async {
    print("RESTART");
    print("RESTART CALLED");
    print(StackTrace.current);
    // isPlaying = true;
    final wasPlaying = isPlaying;
    stop();

    isPlaying = wasPlaying;

    if (wasPlaying) {
      await start();
    }
    // await start();
  }

  void stopBeforeSession() {
    _scheduler?.cancel();
    _scheduler = null;
    _stopwatch
      ..stop()
      ..reset();

    _nextBeatIndex = 0;
    _currentBeat = 1;
    _visualBeat = 0;
    bpm = 120;
    compasNumerator = 4;
    compasDenominator = 4;
    compasAccents
      ..clear()
      ..add(1);
    isPlaying = false;
  }

  void mute() {
    _audioService.mute();
    _isMuted = true;
    notifyListeners();
  }

  void unmute() {
    _audioService.unmute();
    _isMuted = false;
    notifyListeners();
  }

  void toggleMuted() {
    if (_isMuted) {
      unmute();
    } else {
      mute();
    }
  }

  void playRestSound() {
    _audioService.playRestSound();
  }

  void playEndSessionSound() {
    _audioService.playSessionEndSound();
  }

  void stop() {
    print("STOP scheduler=${identityHashCode(_scheduler)}");
    _scheduler?.cancel();

    _scheduler = null;

    _stopwatch
      ..stop()
      ..reset();

    _nextBeatIndex = 0;

    resetBeat();

    notifyListeners();
  }
}
