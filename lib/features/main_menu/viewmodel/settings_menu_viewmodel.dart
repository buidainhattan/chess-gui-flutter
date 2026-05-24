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
  late double _overallVolume;
  double get overallVolume => _overallVolume;
  late bool _overallMuted;
  bool get overallMuted => _overallMuted;

  late double _gameFXsVolume;
  double get gameFXsVolume => _gameFXsVolume;
  late bool _gameFXsMuted;
  bool get gameFXsMuted => _gameFXsMuted;

  late double _lowTimeWarningVolume;
  double get lowTimeWarningVolume => _lowTimeWarningVolume;
  late bool _lowTimeWarningMuted;
  bool get lowTimeWarningMuted => _lowTimeWarningMuted;

  bool get allSoundsMuted =>
      _overallMuted && _gameFXsMuted && _lowTimeWarningMuted;

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
    _profileIconIndex = _settingsService.profileIconIndex;

    // Gameplay
    _confirmMoves = _settingsService.confirmMovesValue.value;
    _autoPromote = _settingsService.autoPromoteValue.value;
    _showLegalMoves = _settingsService.showLegalMovesValue.value;
    _movementStyle = _settingsService.movementStyleValue.value;

    // Appearance
    _colorHexList = _settingsService.colorHexList;
    _themeColorHexValue = _settingsService.themeColorHexValue.value;
    _animationSpeed = _settingsService.animationSpeedValue.value;

    // Sound
    _gameFXsVolume = _settingsService.gameFXsVolumeValue.value;
    _gameFXsMuted = _settingsService.gameFXsMutedValue.value;
    _overallVolume = _settingsService.overallVolumeValue.value;
    _overallMuted = _settingsService.overallMutedValue.value;
    _lowTimeWarningVolume = _settingsService.lowTimeWarningVolumeValue.value;
    _lowTimeWarningMuted = _settingsService.lowTimeWarningMutedValue.value;

    // Notifications
    _opponentMoved = _settingsService.opponentMovedValue.value;
    _gameReminders = _settingsService.gameRemindersValue.value;
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
    await _settingsService.saveProfileIconIndex(index);
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
  void updateOverallVolume(double value) async {
    if (_overallVolume == value) return;
    _overallVolume = value;
    notifyListeners();
    await _settingsService.saveOverallVolume(value);
  }

  void updateOverallMuted(bool value) async {
    if (_overallMuted == value) return;
    _overallMuted = value;
    notifyListeners();
    await _settingsService.saveOverallMuted(value);
  }

  void updateGameFXsVolume(double value) async {
    if (_gameFXsVolume == value) return;
    _gameFXsVolume = value;
    notifyListeners();
    await _settingsService.saveGameFXsVolume(value);
  }

  void updateGameFXsMuted(bool value) async {
    if (_gameFXsMuted == value) return;
    _gameFXsMuted = value;
    notifyListeners();
    await _settingsService.saveGameFXsMuted(value);
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
    _overallMuted = value;
    _gameFXsMuted = value;
    _lowTimeWarningMuted = value;
    notifyListeners();
    await Future.wait([
      _settingsService.saveOverallMuted(value),
      _settingsService.saveGameFXsMuted(value),
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
