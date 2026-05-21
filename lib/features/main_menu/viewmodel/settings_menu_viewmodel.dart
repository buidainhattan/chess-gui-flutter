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

  bool get allSoundsMuted =>
      _moveSoundsMuted &&
      _captureSoundsMuted &&
      _gameEndSoundMuted &&
      _lowTimeWarningMuted;

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
    _moveSoundsVolume = _settingsService.moveSoundsVolume;
    _moveSoundsMuted = _settingsService.moveSoundsMuted;
    _captureSoundsVolume = _settingsService.captureSoundsVolume;
    _captureSoundsMuted = _settingsService.captureSoundsMuted;
    _gameEndSoundVolume = _settingsService.gameEndSoundVolume;
    _gameEndSoundMuted = _settingsService.gameEndSoundMuted;
    _lowTimeWarningVolume = _settingsService.lowTimeWarningVolume;
    _lowTimeWarningMuted = _settingsService.lowTimeWarningMuted;

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
  void updateMoveSoundsVolume(double value) async {
    if (_moveSoundsVolume == value) return;
    _moveSoundsVolume = value;
    notifyListeners();
    await _settingsService.saveMoveSoundsVolume(value);
  }

  void updateMoveSoundsMuted(bool value) async {
    if (_moveSoundsMuted == value) return;
    _moveSoundsMuted = value;
    notifyListeners();
    await _settingsService.saveMoveSoundsMuted(value);
  }

  void updateCaptureSoundsVolume(double value) async {
    if (_captureSoundsVolume == value) return;
    _captureSoundsVolume = value;
    notifyListeners();
    await _settingsService.saveCaptureSoundsVolume(value);
  }

  void updateCaptureSoundsMuted(bool value) async {
    if (_captureSoundsMuted == value) return;
    _captureSoundsMuted = value;
    notifyListeners();
    await _settingsService.saveCaptureSoundsMuted(value);
  }

  void updateGameEndSoundVolume(double value) async {
    if (_gameEndSoundVolume == value) return;
    _gameEndSoundVolume = value;
    notifyListeners();
    await _settingsService.saveGameEndSoundVolume(value);
  }

  void updateGameEndSoundMuted(bool value) async {
    if (_gameEndSoundMuted == value) return;
    _gameEndSoundMuted = value;
    notifyListeners();
    await _settingsService.saveGameEndSoundMuted(value);
  }

  void updateLowTimeWarningVolume(double value) async {
    if (_lowTimeWarningVolume == value) return;
    _lowTimeWarningVolume = value;
    notifyListeners();
    await _settingsService.saveLowTimeWarningVolume(value);
  }

  void updateLowTimeWarningMuted(bool value) async {
    if (_lowTimeWarningMuted == value) return;
    _lowTimeWarningMuted = value;
    notifyListeners();
    await _settingsService.saveLowTimeWarningMuted(value);
  }

  void updateMuteAll(bool value) async {
    _moveSoundsMuted = value;
    _captureSoundsMuted = value;
    _gameEndSoundMuted = value;
    _lowTimeWarningMuted = value;
    notifyListeners();
    await Future.wait([
      _settingsService.saveMoveSoundsMuted(value),
      _settingsService.saveCaptureSoundsMuted(value),
      _settingsService.saveGameEndSoundMuted(value),
      _settingsService.saveLowTimeWarningMuted(value),
    ]);
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
