import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferencesAsync _asyncPrefs;

  // Profile
  late String _playerName;
  String get playerName => _playerName;

  // Gameplay
  late final ValueNotifier<bool> confirmMovesValue;
  late final ValueNotifier<bool> autoPromoteValue;
  late final ValueNotifier<bool> showLegalMovesValue;
  late final ValueNotifier<int> movementStyleValue;

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
  late final ValueNotifier<int> animationSpeedValue;

  // Sound
  late final ValueNotifier<double> overallVolumeValue;
  late final ValueNotifier<bool> overallMutedValue;

  late final ValueNotifier<double> gameFXsVolumeValue;
  late final ValueNotifier<bool> gameFXsMutedValue;

  late final ValueNotifier<double> lowTimeWarningVolumeValue;
  late final ValueNotifier<bool> lowTimeWarningMutedValue;

  // Notifications
  late final ValueNotifier<bool> opponentMovedValue;
  late final ValueNotifier<bool> gameRemindersValue;

  Future<void> init() async {
    _asyncPrefs = SharedPreferencesAsync();

    _playerName = await loadPlayerName();

    confirmMovesValue = ValueNotifier<bool>(await loadConfirmMoves());
    autoPromoteValue = ValueNotifier<bool>(await loadAutoPromote());
    showLegalMovesValue = ValueNotifier<bool>(await loadShowLegalMoves());
    movementStyleValue = ValueNotifier<int>(await loadMovementStyle());

    _colorHexList = await loadColorHexToList();
    themeColorHexValue = ValueNotifier<int>(await loadThemeColorHex());
    animationSpeedValue = ValueNotifier<int>(await loadAnimationSpeed());

    overallVolumeValue = ValueNotifier<double>(await loadOverallVolume());
    overallMutedValue = ValueNotifier<bool>(await loadOverallMuted());
    gameFXsVolumeValue = ValueNotifier<double>(await loadGameFXsVolume());
    gameFXsMutedValue = ValueNotifier<bool>(await loadGameFXsMuted());
    lowTimeWarningVolumeValue = ValueNotifier<double>(
      await loadLowTimeWarningVolume(),
    );
    lowTimeWarningMutedValue = ValueNotifier<bool>(
      await loadLowTimeWarningMuted(),
    );

    opponentMovedValue = ValueNotifier<bool>(await loadOpponentMoved());
    gameRemindersValue = ValueNotifier<bool>(await loadGameReminders());
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
    confirmMovesValue.value = value;
    await _asyncPrefs.setBool('confirm_moves', value);
  }

  Future<bool> loadConfirmMoves() async =>
      await _asyncPrefs.getBool('confirm_moves') ?? false;

  Future<void> saveAutoPromote(bool value) async {
    autoPromoteValue.value = value;
    await _asyncPrefs.setBool('auto_promote', value);
  }

  Future<bool> loadAutoPromote() async =>
      await _asyncPrefs.getBool('auto_promote') ?? false;

  Future<void> saveShowLegalMoves(bool value) async {
    showLegalMovesValue.value = value;
    await _asyncPrefs.setBool('show_legal_moves', value);
  }

  Future<bool> loadShowLegalMoves() async =>
      await _asyncPrefs.getBool('show_legal_moves') ?? true;

  Future<void> saveMovementStyle(int value) async {
    movementStyleValue.value = value;
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
    animationSpeedValue.value = value;
    await _asyncPrefs.setInt('animation_speed', value);
  }

  Future<int> loadAnimationSpeed() async =>
      await _asyncPrefs.getInt('animation_speed') ?? 1;

  // ── Sound ──────────────────────────────────────────────────────────────────

  Future<void> saveOverallVolume(double value) async {
    overallVolumeValue.value = value;
    await _asyncPrefs.setDouble('overall_volume', value);
  }

  Future<double> loadOverallVolume() async =>
      await _asyncPrefs.getDouble('overall_volume') ?? 1.0;

  Future<void> saveOverallMuted(bool value) async {
    overallMutedValue.value = value;
    await _asyncPrefs.setBool('overall_muted', value);
  }

  Future<bool> loadOverallMuted() async =>
      await _asyncPrefs.getBool('overall_muted') ?? false;

  Future<void> saveGameFXsVolume(double value) async {
    gameFXsVolumeValue.value = value;
    await _asyncPrefs.setDouble('game_fxs_volume', value);
  }

  Future<double> loadGameFXsVolume() async =>
      await _asyncPrefs.getDouble('game_fxs_volume') ?? 1.0;

  Future<void> saveGameFXsMuted(bool value) async {
    gameFXsMutedValue.value = value;
    await _asyncPrefs.setBool('game_fxs_muted', value);
  }

  Future<bool> loadGameFXsMuted() async =>
      await _asyncPrefs.getBool('game_fxs_muted') ?? false;

  Future<void> saveLowTimeWarningVolume(double value) async {
    lowTimeWarningVolumeValue.value = value;
    await _asyncPrefs.setDouble('low_time_warning_volume', value);
  }

  Future<double> loadLowTimeWarningVolume() async =>
      await _asyncPrefs.getDouble('low_time_warning_volume') ?? 1.0;

  Future<void> saveLowTimeWarningMuted(bool value) async {
    lowTimeWarningMutedValue.value = value;
    await _asyncPrefs.setBool('low_time_warning_muted', value);
  }

  Future<bool> loadLowTimeWarningMuted() async =>
      await _asyncPrefs.getBool('low_time_warning_muted') ?? false;

  // ── Notifications ──────────────────────────────────────────────────────────

  Future<void> saveOpponentMoved(bool value) async {
    opponentMovedValue.value = value;
    await _asyncPrefs.setBool('notif_opponent_moved', value);
  }

  Future<bool> loadOpponentMoved() async =>
      await _asyncPrefs.getBool('notif_opponent_moved') ?? false;

  Future<void> saveGameReminders(bool value) async {
    gameRemindersValue.value = value;
    await _asyncPrefs.setBool('notif_game_reminders', value);
  }

  Future<bool> loadGameReminders() async =>
      await _asyncPrefs.getBool('notif_game_reminders') ?? false;
}
