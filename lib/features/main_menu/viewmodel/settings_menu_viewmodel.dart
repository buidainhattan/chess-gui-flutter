import 'package:chess_app/core/services/settings_service.dart';
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
  late List<int> _colorHexList;
  List<int> get colorHexList => _colorHexList;
  late int _themeColorHexValue;
  int get themeColorHexValue => _themeColorHexValue;

  SettingsMenuViewmodel(SettingsService service) {
    _settingsService = service;
    _settingInitialization();
  }

  void _settingInitialization() {
    _playerName = _settingsService.playerName;
    _colorHexList = _settingsService.colorHexList;
    _themeColorHexValue = _settingsService.themeColorHexValue.value;
  }

  void updateSelectedTabIndex(int newIndex) {
    if (_selectedTabIndex == newIndex) return;

    _selectedTabIndex = newIndex;
    notifyListeners();
  }

  void updateActiveThemeColor(int selectedColorHex) async {
    _themeColorHexValue = selectedColorHex;
    notifyListeners();

    await _settingsService.saveThemeColorHex(selectedColorHex);
  }

  void updatePlayerName(String newName) async {
    if (_playerName == newName) return;

    _playerName = newName;
    notifyListeners();

    await _settingsService.savePlayerName(newName);
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
}
