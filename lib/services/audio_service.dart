import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  AudioSource? normal;
  AudioSource? accent;
  AudioSource? restSound;
  AudioSource? sessionEndSound;

  Future<void> initialize() async {
    await SoLoud.instance.init();

    normal = await SoLoud.instance.loadAsset(
      'assets/sounds/metronome_click.wav',
    );

    accent = await SoLoud.instance.loadAsset(
      'assets/sounds/metronome_accent.wav',
    );

    restSound = await SoLoud.instance.loadAsset('assets/sounds/rest_sound.mp3');
    sessionEndSound = await SoLoud.instance.loadAsset(
      'assets/sounds/session_end.mp3',
    );

    SoLoud.instance.play(normal!, volume: 0);
    SoLoud.instance.play(accent!, volume: 0);
    SoLoud.instance.play(restSound!, volume: 0);
    SoLoud.instance.play(sessionEndSound!, volume: 0);
  }

  Future<void> playNormal() async {
    if (normal == null) return;

    SoLoud.instance.play(normal!);
  }

  Future<void> playAccent() async {
    if (accent == null) return;

    SoLoud.instance.play(accent!);
  }

  Future<void> playRestSound() async {
    if (restSound == null) return;

    SoLoud.instance.play(restSound!);
  }

  Future<void> playSessionEndSound() async {
    if (sessionEndSound == null) return;

    SoLoud.instance.play(sessionEndSound!);
  }

  Future<void> mute() async {
    SoLoud.instance.setGlobalVolume(0);
  }

  Future<void> unmute() async {
    SoLoud.instance.setGlobalVolume(1);
  }

  Future<void> dispose() async {
    if (normal != null) {
      await SoLoud.instance.disposeSource(normal!);
    }

    if (accent != null) {
      await SoLoud.instance.disposeSource(accent!);
    }

    SoLoud.instance.deinit();
  }
}
