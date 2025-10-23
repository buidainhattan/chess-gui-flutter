import 'package:chess_app/core/constants/all_enum.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioController {
  final SoLoud _soLoud = SoLoud.instance;
  final Map<SoundFXs, AudioSource> _sounds = {};

  // 1. Singleton pattern
  static final AudioController _instance = AudioController._internal();
  factory AudioController() {
    return _instance;
  }
  AudioController._internal();

  Future<void> initialize() async {
    await _soLoud.init();
    await _preloadSounds();
  }

  Future<void> playSoundEffect(SoundFXs sound) async {
    if (_sounds[sound] == null) {
      return;
    }

    await _soLoud.play(_sounds[sound]!);
  }

  void dispose() {
    _soLoud.deinit();
  }

  Future<void> _preloadSounds() async {
    final Map<SoundFXs, String> soundsToLoad = {
      SoundFXs.movePiece: "assets/sounds/move-self.mp3",
      SoundFXs.capturePiece: "assets/sounds/capture.mp3",
      SoundFXs.castling: "assets/sounds/castle.mp3",
    };

    for (var entry in soundsToLoad.entries) {
      final source = await _soLoud.loadAsset(entry.value);
      _sounds[entry.key] = source;
    }
  }
}
