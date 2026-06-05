// import 'package:beatlio_v2/services/audio_service.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class MetronomeSoundProvider extends ChangeNotifier {
//   final AudioService _audioService;

//   MetronomeSoundProvider(this._audioService);
// }

import 'dart:async';

import 'package:beatlio_v2/services/audio_service.dart';
import 'package:flutter/material.dart';

class MetronomeSoundProvider extends ChangeNotifier {
  final AudioService _audioService;

  Timer? _timer;
  int _currentBeat = 1;

  MetronomeSoundProvider(this._audioService);

  bool get isRunning => _timer != null;

  void start({
    required int bpm,
    required int numerator,
    required Set<int> accents,
  }) {
    stop();

    final interval = Duration(milliseconds: (60000 / bpm).round());

    _timer = Timer.periodic(interval, (_) async {
      if (accents.contains(_currentBeat)) {
        await _audioService.playAccent();
      } else {
        await _audioService.playNormal();
      }

      _currentBeat++;

      if (_currentBeat > numerator) {
        _currentBeat = 1;
      }
    });

    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _currentBeat = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
