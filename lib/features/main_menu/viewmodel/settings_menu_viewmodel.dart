import 'package:chess_app/core/settings_service.dart';
import 'package:flutter/material.dart';

class SettingsMenuViewmodel extends ChangeNotifier {
  late final SettingsService _settingsService;

  // UI
  final List<String> _options = const ["General", "Theme"];
  List<String> get options => _options;
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  // General settings
  late String _playerName;
  String get playerName => _playerName;

  // Theme settings
  late Color _themeColor;
  Color get themeColor => _themeColor;

  SettingsMenuViewmodel(SettingsService service) {
    _settingsService = service;
    _settingInitialization();
  }

  void _settingInitialization() {
    _playerName = _settingsService.playerName;
    _themeColor = Color(_settingsService.colorHexValue);
  }

  void updateSelectedTabIndex(int newIndex) {
    if (_selectedTabIndex == newIndex) return;

    _selectedTabIndex = newIndex;
    notifyListeners();
  }

  Future<void> updatePlayerName(String newName) async {
    if (_playerName == newName) return;

    _playerName = newName;
    notifyListeners();

    await _settingsService.savePlayerName(newName);
  }

  Future<void> updateThemeColor(int newColorHex) async {
    _themeColor = Color(newColorHex);
    notifyListeners();

    await _settingsService.saveColorHex(newColorHex);
  }
}
