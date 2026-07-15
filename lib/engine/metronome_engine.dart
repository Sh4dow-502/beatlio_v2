import 'package:beatlio_v2/models/acent_type.dart';
import 'package:beatlio_v2/services/audio_service.dart';

class MetronomeEngine {
  final AudioService audio;

  final int Function() getBpm;
  final void Function(int beatInMeasure) onBeat;
  final List<AccentType> Function() getAccentPattern;

  MetronomeEngine({
    required this.audio,
    required this.getBpm,
    required this.onBeat,
    required this.getAccentPattern,
  });

  final Stopwatch _clock = Stopwatch();

  bool _running = false;

  // Future<void> start() async {
  //   if (_running) return;

  //   _running = true;

  //   int beatInMeasure = 0;

  //   _clock
  //     ..reset()
  //     ..start();

  //   int nextBeatTime = 0;

  //   while (_running) {
  //     final bpm = getBpm();
  //     if (bpm <= 0) continue;

  //     final microsPerBeat = (60000000 / bpm).round();

  //     // while (_running && _clock.elapsedMicroseconds < nextBeatTime) {
  //     //   await Future.delayed(const Duration(microseconds: 250));
  //     // }

  //     while (_running && _clock.elapsedMicroseconds < nextBeatTime) {
  //       await Future.delayed(const Duration(milliseconds: 1));
  //     }
  //     if (!_running) break;

  //     final pattern = getAccentPattern();

  //     if (pattern.isEmpty) {
  //       beatInMeasure = 0;
  //       nextBeatTime += microsPerBeat;
  //       continue;
  //     }

  //     // 🔥 CLAVE: asegurar índice válido SIEMPRE
  //     beatInMeasure = beatInMeasure % pattern.length;

  //     final currentAccent = pattern[beatInMeasure];

  //     onBeat(beatInMeasure);

  //     if (currentAccent == AccentType.accent) {
  //       audio.playAccent();
  //     } else {
  //       audio.playNormal();
  //     }

  //     beatInMeasure++;

  //     nextBeatTime += microsPerBeat;
  //   }
  // }
  Future<void> start() async {
    if (_running) return;

    _running = true;

    int beatInMeasure = 0;

    _clock
      ..reset()
      ..start();

    int nextBeatTime = 0;

    while (_running) {
      while (_running && _clock.elapsedMicroseconds < nextBeatTime) {
        await Future.delayed(const Duration(milliseconds: 1));
      }

      if (!_running) break;

      final pattern = getAccentPattern();

      if (pattern.isEmpty) {
        beatInMeasure = 0;

        final bpm = getBpm();
        final microsPerBeat = (60000000 / bpm).round();

        nextBeatTime += microsPerBeat;

        continue;
      }

      beatInMeasure = beatInMeasure % pattern.length;

      final currentAccent = pattern[beatInMeasure];

      onBeat(beatInMeasure);

      if (currentAccent == AccentType.accent) {
        audio.playAccent();
      } else {
        audio.playNormal();
      }

      beatInMeasure++;

      // Leer el BPM justo antes de programar el siguiente beat
      final bpm = getBpm();

      if (bpm <= 0) continue;

      final microsPerBeat = (60000000 / bpm).round();

      nextBeatTime += microsPerBeat;
    }
  }

  void stop() {
    _running = false;
    _clock.stop();
  }
}
