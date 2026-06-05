import 'package:just_audio/just_audio.dart';

class SoundService {
  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _accentClickPlayer = AudioPlayer();

  Future<void> initialize() async {
    await _clickPlayer.setAsset(
      'assets/sounds/metronome_click.wav',
      preload: true,
    );
    await _accentClickPlayer.setAsset(
      'assets/sounds/metronome_accent.wav',
      preload: true,
    );
  }

  Future<void> playClick() async {
    await _clickPlayer.seek(Duration.zero);
    await _clickPlayer.play();
  }

  Future<void> playAccentClick() async {
    await _accentClickPlayer.seek(Duration.zero);
    await _accentClickPlayer.play();
  }

  Future<void> stop() async {
    await _clickPlayer.stop();
    await _accentClickPlayer.stop();
  }

  Future<void> setVolume(double volume) async {
    await _clickPlayer.setVolume(volume);
    await _accentClickPlayer.setVolume(volume);
  }

  Future<void> pause() async {
    await _clickPlayer.pause();
    await _accentClickPlayer.pause();
  }

  Future<void> dispose() async {
    await _clickPlayer.dispose();
    await _accentClickPlayer.dispose();
  }
}
