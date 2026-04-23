import 'package:chess_app/core/services/settings_service.dart';
import 'package:flutter/material.dart';

class AppViewmodel extends ChangeNotifier {
  late final SettingsService _settingsService;

  late int _themeColorHexValue;
  int get themeColorHexValue => _themeColorHexValue;

  AppViewmodel(SettingsService settingsService) {
    _settingsService = settingsService;
    _themeColorHexValue = settingsService.themeColorHexValue.value;
    _settingsService.themeColorHexValue.addListener(_onThemeColorHexChange);
  }

  void _onThemeColorHexChange() {
    _themeColorHexValue = _settingsService.themeColorHexValue.value;
    notifyListeners();
  }

  @override
  void dispose() {
    _settingsService.themeColorHexValue.removeListener(_onThemeColorHexChange);
    super.dispose();
  }
}
