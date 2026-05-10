import 'package:chess_app/core/services/settings_service.dart';
import 'package:flutter/material.dart';

class SettingsMenuViewmodel extends ChangeNotifier {
  late final SettingsService _settingsService;

  // ── Profile ───────────────────────────────────────────────────────────────
  late String _playerName;
  String get playerName => _playerName;
  late int _profileIconIndex;
  int get profileIconIndex => _profileIconIndex;

  // ── Gameplay ───────────────────────────────────────────────────────────────
  late bool _confirmMoves;
  bool get confirmMoves => _confirmMoves;

  late bool _autoPromote;
  bool get autoPromote => _autoPromote;

  late bool _showLegalMoves;
  bool get showLegalMoves => _showLegalMoves;

  /// 0 = Drag, 1 = Tap, 2 = Both
  late int _movementStyle;
  int get movementStyle => _movementStyle;

  // ── Appearance ─────────────────────────────────────────────────────────────
  late List<int> _colorHexList;
  List<int> get colorHexList => _colorHexList;

  late int _themeColorHexValue;
  int get themeColorHexValue => _themeColorHexValue;

  /// 0 = Off, 1 = Normal, 2 = Slow
  late int _animationSpeed;
  int get animationSpeed => _animationSpeed;

  // ── Sound ──────────────────────────────────────────────────────────────────
  late bool _moveSounds;
  bool get moveSounds => _moveSounds;

  late bool _captureSounds;
  bool get captureSounds => _captureSounds;

  late bool _gameEndSound;
  bool get gameEndSound => _gameEndSound;

  late bool _lowTimeWarning;
  bool get lowTimeWarning => _lowTimeWarning;

  // ── Notifications ──────────────────────────────────────────────────────────
  late bool _opponentMoved;
  bool get opponentMoved => _opponentMoved;

  late bool _gameReminders;
  bool get gameReminders => _gameReminders;

  // ── Constructor ────────────────────────────────────────────────────────────
  SettingsMenuViewmodel(SettingsService service) {
    _settingsService = service;
    _init();
  }

  void _init() {
    // Profile
    _playerName = _settingsService.playerName;
    _profileIconIndex = 0;

    // Gameplay
    _confirmMoves = _settingsService.confirmMoves;
    _autoPromote = _settingsService.autoPromote;
    _showLegalMoves = _settingsService.showLegalMoves;
    _movementStyle = _settingsService.movementStyle;

    // Appearance
    _colorHexList = _settingsService.colorHexList;
    _themeColorHexValue = _settingsService.themeColorHexValue.value;
    _animationSpeed = _settingsService.animationSpeed;

    // Sound
    _moveSounds = _settingsService.moveSounds;
    _captureSounds = _settingsService.captureSounds;
    _gameEndSound = _settingsService.gameEndSound;
    _lowTimeWarning = _settingsService.lowTimeWarning;

    // Notifications
    _opponentMoved = _settingsService.opponentMoved;
    _gameReminders = _settingsService.gameReminders;
  }

  // ── Profile ────────────────────────────────────────────────
  void updatePlayerName(String newName) async {
    if (_playerName == newName) return;

    _playerName = newName;
    notifyListeners();
    await _settingsService.savePlayerName(newName);
  }

  void updateProfileIconIndex(int index) async {
    if (_profileIconIndex == index) return;

    _profileIconIndex = index;
    notifyListeners();
  }

  // ── Gameplay ───────────────────────────────────────────────────────────────
  void updateConfirmMoves(bool value) async {
    if (_confirmMoves == value) return;

    _confirmMoves = value;
    notifyListeners();
    await _settingsService.saveConfirmMoves(value);
  }

  void updateAutoPromote(bool value) async {
    if (_autoPromote == value) return;

    _autoPromote = value;
    notifyListeners();
    await _settingsService.saveAutoPromote(value);
  }

  void updateShowLegalMoves(bool value) async {
    if (_showLegalMoves == value) return;

    _showLegalMoves = value;
    notifyListeners();
    await _settingsService.saveShowLegalMoves(value);
  }

  void updateMovementStyle(int value) async {
    if (_movementStyle == value) return;

    _movementStyle = value;
    notifyListeners();
    await _settingsService.saveMovementStyle(value);
  }

  // ── Appearance ─────────────────────────────────────────────────────────────
  void updateActiveThemeColor(int selectedColorHex) async {
    _themeColorHexValue = selectedColorHex;
    notifyListeners();
    await _settingsService.saveThemeColorHex(selectedColorHex);
  }

  void addThemeColor(int newColorHex) async {
    _colorHexList = [..._colorHexList, newColorHex];
    _themeColorHexValue = newColorHex;
    notifyListeners();
    await _settingsService.saveColorHexToList(newColorHex);
    await _settingsService.saveThemeColorHex(newColorHex);
  }

  void deleteThemeColor(int colorHexToDelete) async {
    if (_themeColorHexValue == colorHexToDelete) return;

    _colorHexList = [..._colorHexList.where((e) => e != colorHexToDelete)];
    notifyListeners();
    await _settingsService.deleteColorHexFromList(colorHexToDelete);
  }

  void updateAnimationSpeed(int value) async {
    if (_animationSpeed == value) return;
    _animationSpeed = value;
    notifyListeners();
    await _settingsService.saveAnimationSpeed(value);
  }

  // ── Sound ──────────────────────────────────────────────────────────────────
  void updateMoveSounds(bool value) async {
    if (_moveSounds == value) return;

    _moveSounds = value;
    notifyListeners();
    await _settingsService.saveMoveSounds(value);
  }

  void updateCaptureSounds(bool value) async {
    if (_captureSounds == value) return;

    _captureSounds = value;
    notifyListeners();
    await _settingsService.saveCaptureSounds(value);
  }

  void updateGameEndSound(bool value) async {
    if (_gameEndSound == value) return;

    _gameEndSound = value;
    notifyListeners();
    await _settingsService.saveGameEndSound(value);
  }

  void updateLowTimeWarning(bool value) async {
    if (_lowTimeWarning == value) return;

    _lowTimeWarning = value;
    notifyListeners();
    await _settingsService.saveLowTimeWarning(value);
  }

  // ── Notifications ──────────────────────────────────────────────────────────
  void updateOpponentMoved(bool value) async {
    if (_opponentMoved == value) return;

    _opponentMoved = value;
    notifyListeners();
    await _settingsService.saveOpponentMoved(value);
  }

  void updateGameReminders(bool value) async {
    if (_gameReminders == value) return;

    _gameReminders = value;
    notifyListeners();
    await _settingsService.saveGameReminders(value);
  }
}
