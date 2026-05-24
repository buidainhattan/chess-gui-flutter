import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/services/settings_service.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioController {
  final SoLoud _soLoud = SoLoud.instance;
  late final SettingsService _settingsService;

  final Map<SoundFXs, AudioSource> _soundEffects = {};

  // 1. Singleton pattern
  static final AudioController _instance = AudioController._internal();
  factory AudioController() {
    return _instance;
  }
  AudioController._internal();

  // <--- Settings handlers --->
  void _onOverallVolumeChanged() {
    final overallVolume = _settingsService.overallVolumeValue.value;
    _soLoud.setGlobalVolume(overallVolume);
  }

  void _onOverallMutedChanged() {
    final overallMuted = _settingsService.overallMutedValue.value;
    final overallVolume = _settingsService.overallVolumeValue.value;
    _soLoud.setGlobalVolume(overallMuted ? 0.0 : overallVolume);
  }

  Future<void> initialize(SettingsService settingsService) async {
    _settingsService = settingsService;
    await _soLoud.init();
    await _preloadSounds();

    _soLoud.setGlobalVolume(
      _settingsService.overallMutedValue.value
          ? 0.0
          : _settingsService.overallVolumeValue.value,
    );

    _settingsService.overallVolumeValue.addListener(_onOverallVolumeChanged);
    _settingsService.overallMutedValue.addListener(_onOverallMutedChanged);
  }

  void playSoundEffect(SoundFXs sound) {
    if (_soundEffects[sound] == null) {
      return;
    }

    final gameFXsMuted = _settingsService.gameFXsMutedValue.value;
    final gameFXsVolume = _settingsService.gameFXsVolumeValue.value;
    final volume = gameFXsMuted ? 0.0 : gameFXsVolume;

    _soLoud.play(_soundEffects[sound]!, volume: volume);
  }

  void dispose() {
    _settingsService.overallVolumeValue.removeListener(_onOverallVolumeChanged);
    _settingsService.overallMutedValue.removeListener(_onOverallMutedChanged);
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
      _soundEffects[entry.key] = source;
    }
  }
}
