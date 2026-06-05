import 'package:beatlio_v2/engine/metronome_engine.dart';
import 'package:beatlio_v2/models/acent_type.dart';
import 'package:beatlio_v2/services/audio_service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MetronomeGlobalProvider extends ChangeNotifier {
  final AudioService _audioService;

  late final MetronomeEngine _engine;

  MetronomeGlobalProvider(this._audioService) {
    _engine = MetronomeEngine(
      audio: _audioService,
      getBpm: () => bpm,
      getAccentPattern: () => List.unmodifiable(_accentPattern),
      onBeat: (beat) {
        currentBeatNotifier.value = beat;
      },
    );
  }

  static const int minBpm = 40;
  static const int maxBpm = 300;

  bool _isPlaying = false;
  bool _isMuted = false;
  int _bpm = 120;
  int _compasNumerator = 4;
  int _compasDenominator = 4;

  final ValueNotifier<int> currentBeatNotifier = ValueNotifier<int>(0);

  // int _currentBeat = 0;

  List<AccentType> _accentPattern = [
    AccentType.accent,
    AccentType.normal,
    AccentType.normal,
    AccentType.normal,
  ];

  int get bpm => _bpm;
  int get compasNumerator => _compasNumerator;
  int get compasDenominator => _compasDenominator;
  String get compasLabel => '$_compasNumerator/$_compasDenominator';
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  // int get currentBeat => _currentBeat;
  List<AccentType> get accentPattern => List.unmodifiable(_accentPattern);

  void setBpm(int newBpm) {
    final clamped = newBpm.clamp(minBpm, maxBpm);

    if (clamped == _bpm) return;
    _bpm = clamped;
    notifyListeners();
  }

  void setBpmWithoutNotify(int newBpm) {
    final clamped = newBpm.clamp(minBpm, maxBpm);

    if (clamped == _bpm) return;
    _bpm = clamped;
  }

  void playClick() async {
    if (_isPlaying) return;

    _isPlaying = true;
    notifyListeners();

    await _engine.start();
  }

  void stopClick() {
    if (!_isPlaying) return;

    _engine.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void stopFinishedClick() {
    // if (!_isPlaying) return;

    _engine.stop();
    _isPlaying = false;
    // notifyListeners();
  }

  void togglePlaying() {
    if (_isPlaying) {
      stopClick();
    } else {
      playClick();
    }
  }

  void setCompasSignature(int numerator, int denominator) {
    if (_compasNumerator == numerator && _compasDenominator == denominator) {
      return;
    }

    _compasNumerator = numerator;
    _compasDenominator = denominator;

    // Patrón por defecto:
    _accentPattern = List.generate(
      numerator,
      (index) => index == 0 ? AccentType.accent : AccentType.normal,
    );

    notifyListeners();
  }

  void setAccentAt(int index, AccentType accent) {
    if (index < 0 || index >= _accentPattern.length) {
      return;
    }

    _accentPattern[index] = accent;

    notifyListeners();
  }

  void setAccentPattern(List<AccentType> pattern) {
    if (pattern.isEmpty) return;

    _accentPattern = List.from(pattern);

    _compasNumerator = pattern.length;

    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _audioService.mute();
    } else {
      _audioService.unmute();
    }
    notifyListeners();
  }

  void playEndSessionSound() {
    _audioService.playSessionEndSound();
  }

  void playRestSound() {
    _audioService.playRestSound();
  }

  @override
  void dispose() {
    currentBeatNotifier.dispose();
    _engine.stop();
    super.dispose();
  }
}
