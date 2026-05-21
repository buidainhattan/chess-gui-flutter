import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferencesAsync _asyncPrefs;

  // Profile
  late String _playerName;
  String get playerName => _playerName;

  // Gameplay
  late bool _confirmMoves;
  bool get confirmMoves => _confirmMoves;
  late bool _autoPromote;
  bool get autoPromote => _autoPromote;
  late bool _showLegalMoves;
  bool get showLegalMoves => _showLegalMoves;
  late int _movementStyle;
  int get movementStyle => _movementStyle;

  // Appearance
  final List<int> _defaultColorHexList = <int>[
    0xff6C3CE1,
    0xffFF5757,
    0xffFF9A3C,
    0xff00C896,
    0xff2FAEFF,
  ];
  late List<int> _colorHexList;
  List<int> get colorHexList => _colorHexList;
  late final ValueNotifier<int> themeColorHexValue;
  late int _animationSpeed;
  int get animationSpeed => _animationSpeed;

  // Sound
  late double _moveSoundsVolume;
  double get moveSoundsVolume => _moveSoundsVolume;
  late bool _moveSoundsMuted;
  bool get moveSoundsMuted => _moveSoundsMuted;

  late double _captureSoundsVolume;
  double get captureSoundsVolume => _captureSoundsVolume;
  late bool _captureSoundsMuted;
  bool get captureSoundsMuted => _captureSoundsMuted;

  late double _gameEndSoundVolume;
  double get gameEndSoundVolume => _gameEndSoundVolume;
  late bool _gameEndSoundMuted;
  bool get gameEndSoundMuted => _gameEndSoundMuted;

  late double _lowTimeWarningVolume;
  double get lowTimeWarningVolume => _lowTimeWarningVolume;
  late bool _lowTimeWarningMuted;
  bool get lowTimeWarningMuted => _lowTimeWarningMuted;

  // Notifications
  late bool _opponentMoved;
  bool get opponentMoved => _opponentMoved;
  late bool _gameReminders;
  bool get gameReminders => _gameReminders;

  Future<void> init() async {
    _asyncPrefs = SharedPreferencesAsync();

    _playerName = await loadPlayerName();

    _confirmMoves = await loadConfirmMoves();
    _autoPromote = await loadAutoPromote();
    _showLegalMoves = await loadShowLegalMoves();
    _movementStyle = await loadMovementStyle();

    _colorHexList = await loadColorHexToList();
    themeColorHexValue = ValueNotifier<int>(await loadThemeColorHex());
    _animationSpeed = await loadAnimationSpeed();

    _moveSoundsVolume = await loadMoveSoundsVolume();
    _moveSoundsMuted = await loadMoveSoundsMuted();
    _captureSoundsVolume = await loadCaptureSoundsVolume();
    _captureSoundsMuted = await loadCaptureSoundsMuted();
    _gameEndSoundVolume = await loadGameEndSoundVolume();
    _gameEndSoundMuted = await loadGameEndSoundMuted();
    _lowTimeWarningVolume = await loadLowTimeWarningVolume();
    _lowTimeWarningMuted = await loadLowTimeWarningMuted();

    _opponentMoved = await loadOpponentMoved();
    _gameReminders = await loadGameReminders();
  }

  // ── Profile ───────────────────────────────────────────────────────────────

  Future<void> savePlayerName(String value) async {
    _playerName = value;
    await _asyncPrefs.setString('player_name', value);
  }

  Future<String> loadPlayerName() async {
    return await _asyncPrefs.getString('player_name') ?? 'Player';
  }

  // ── Gameplay ───────────────────────────────────────────────────────────────

  Future<void> saveConfirmMoves(bool value) async {
    _confirmMoves = value;
    await _asyncPrefs.setBool('confirm_moves', value);
  }

  Future<bool> loadConfirmMoves() async =>
      await _asyncPrefs.getBool('confirm_moves') ?? false;

  Future<void> saveAutoPromote(bool value) async {
    _autoPromote = value;
    await _asyncPrefs.setBool('auto_promote', value);
  }

  Future<bool> loadAutoPromote() async =>
      await _asyncPrefs.getBool('auto_promote') ?? false;

  Future<void> saveShowLegalMoves(bool value) async {
    _showLegalMoves = value;
    await _asyncPrefs.setBool('show_legal_moves', value);
  }

  Future<bool> loadShowLegalMoves() async =>
      await _asyncPrefs.getBool('show_legal_moves') ?? true;

  Future<void> saveMovementStyle(int value) async {
    _movementStyle = value;
    await _asyncPrefs.setInt('movement_style', value);
  }

  Future<int> loadMovementStyle() async =>
      await _asyncPrefs.getInt('movement_style') ?? 1;

  // ── Appearance ─────────────────────────────────────────────────────────────
  Future<void> saveColorHexToList(int value) async {
    _colorHexList.add(value);
    final colorHexStrList = _colorHexList.map((e) => e.toString()).toList();
    await _asyncPrefs.setStringList('color_list', colorHexStrList);
  }

  Future<List<int>> loadColorHexToList() async {
    final colorHexStrList = await _asyncPrefs.getStringList('color_list');
    if (colorHexStrList == null) return _defaultColorHexList;
    return colorHexStrList.map(int.parse).toList();
  }

  Future<void> deleteColorHexFromList(int value) async {
    _colorHexList.remove(value);
    final colorHexStrList = _colorHexList.map((e) => e.toString()).toList();
    await _asyncPrefs.setStringList('color_list', colorHexStrList);
  }

  Future<void> saveThemeColorHex(int value) async {
    themeColorHexValue.value = value;
    await _asyncPrefs.setInt('color_hex_value', value);
  }

  Future<int> loadThemeColorHex() async {
    return await _asyncPrefs.getInt('color_hex_value') ?? 0xff7B61FF;
  }

  Future<void> saveAnimationSpeed(int value) async {
    _animationSpeed = value;
    await _asyncPrefs.setInt('animation_speed', value);
  }

  Future<int> loadAnimationSpeed() async =>
      await _asyncPrefs.getInt('animation_speed') ?? 1;

  // ── Sound ──────────────────────────────────────────────────────────────────

  Future<void> saveMoveSoundsVolume(double value) async {
    _moveSoundsVolume = value;
    await _asyncPrefs.setDouble('move_sounds_volume', value);
  }

  Future<double> loadMoveSoundsVolume() async =>
      await _asyncPrefs.getDouble('move_sounds_volume') ?? 1.0;

  Future<void> saveMoveSoundsMuted(bool value) async {
    _moveSoundsMuted = value;
    await _asyncPrefs.setBool('move_sounds_muted', value);
  }

  Future<bool> loadMoveSoundsMuted() async =>
      await _asyncPrefs.getBool('move_sounds_muted') ?? false;

  Future<void> saveCaptureSoundsVolume(double value) async {
    _captureSoundsVolume = value;
    await _asyncPrefs.setDouble('capture_sounds_volume', value);
  }

  Future<double> loadCaptureSoundsVolume() async =>
      await _asyncPrefs.getDouble('capture_sounds_volume') ?? 1.0;

  Future<void> saveCaptureSoundsMuted(bool value) async {
    _captureSoundsMuted = value;
    await _asyncPrefs.setBool('capture_sounds_muted', value);
  }

  Future<bool> loadCaptureSoundsMuted() async =>
      await _asyncPrefs.getBool('capture_sounds_muted') ?? false;

  Future<void> saveGameEndSoundVolume(double value) async {
    _gameEndSoundVolume = value;
    await _asyncPrefs.setDouble('game_end_sound_volume', value);
  }

  Future<double> loadGameEndSoundVolume() async =>
      await _asyncPrefs.getDouble('game_end_sound_volume') ?? 1.0;

  Future<void> saveGameEndSoundMuted(bool value) async {
    _gameEndSoundMuted = value;
    await _asyncPrefs.setBool('game_end_sound_muted', value);
  }

  Future<bool> loadGameEndSoundMuted() async =>
      await _asyncPrefs.getBool('game_end_sound_muted') ?? false;

  Future<void> saveLowTimeWarningVolume(double value) async {
    _lowTimeWarningVolume = value;
    await _asyncPrefs.setDouble('low_time_warning_volume', value);
  }

  Future<double> loadLowTimeWarningVolume() async =>
      await _asyncPrefs.getDouble('low_time_warning_volume') ?? 1.0;

  Future<void> saveLowTimeWarningMuted(bool value) async {
    _lowTimeWarningMuted = value;
    await _asyncPrefs.setBool('low_time_warning_muted', value);
  }

  Future<bool> loadLowTimeWarningMuted() async =>
      await _asyncPrefs.getBool('low_time_warning_muted') ?? false;

  // ── Notifications ──────────────────────────────────────────────────────────

  Future<void> saveOpponentMoved(bool value) async {
    _opponentMoved = value;
    await _asyncPrefs.setBool('notif_opponent_moved', value);
  }

  Future<bool> loadOpponentMoved() async =>
      await _asyncPrefs.getBool('notif_opponent_moved') ?? false;

  Future<void> saveGameReminders(bool value) async {
    _gameReminders = value;
    await _asyncPrefs.setBool('notif_game_reminders', value);
  }

  Future<bool> loadGameReminders() async =>
      await _asyncPrefs.getBool('notif_game_reminders') ?? false;
}
