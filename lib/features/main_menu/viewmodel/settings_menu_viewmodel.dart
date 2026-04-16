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
  String _playerName = "Player";
  String get playerName => _playerName;

  // Theme settings
  Color _themeColor = const Color(0xff7B61FF);
  Color get themeColor => _themeColor;

  SettingsMenuViewmodel(SettingsService service) {
    _settingsService = service;
  }

  void updateSelectedTabIndex(int newIndex) {
    if (_selectedTabIndex == newIndex) return;

    _selectedTabIndex = newIndex;
    notifyListeners();
  }

  void updatePlayerName(String newName) {
    _playerName = newName;
    notifyListeners();
  }

  void updateThemeColor(Color newColor) {
    _themeColor = newColor;
    notifyListeners();
  }
}
