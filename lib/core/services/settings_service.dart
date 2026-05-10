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
  late bool _moveSounds;
  bool get moveSounds => _moveSounds;
  late bool _captureSounds;
  bool get captureSounds => _captureSounds;
  late bool _gameEndSound;
  bool get gameEndSound => _gameEndSound;
  late bool _lowTimeWarning;
  bool get lowTimeWarning => _lowTimeWarning;

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

    _moveSounds = await loadMoveSounds();
    _captureSounds = await loadCaptureSounds();
    _gameEndSound = await loadGameEndSound();
    _lowTimeWarning = await loadLowTimeWarning();

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

  Future<void> saveMoveSounds(bool value) async {
    _moveSounds = value;
    await _asyncPrefs.setBool('move_sounds', value);
  }

  Future<bool> loadMoveSounds() async =>
      await _asyncPrefs.getBool('move_sounds') ?? true;

  Future<void> saveCaptureSounds(bool value) async {
    _captureSounds = value;
    await _asyncPrefs.setBool('capture_sounds', value);
  }

  Future<bool> loadCaptureSounds() async =>
      await _asyncPrefs.getBool('capture_sounds') ?? true;

  Future<void> saveGameEndSound(bool value) async {
    _gameEndSound = value;
    await _asyncPrefs.setBool('game_end_sound', value);
  }

  Future<bool> loadGameEndSound() async =>
      await _asyncPrefs.getBool('game_end_sound') ?? false;

  Future<void> saveLowTimeWarning(bool value) async {
    _lowTimeWarning = value;
    await _asyncPrefs.setBool('low_time_warning', value);
  }

  Future<bool> loadLowTimeWarning() async =>
      await _asyncPrefs.getBool('low_time_warning') ?? false;

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
