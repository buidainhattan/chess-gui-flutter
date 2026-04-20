import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferencesAsync _asyncPrefs;

  late String _playerName;
  String get playerName => _playerName;
  late final ValueNotifier<int> themeColorHexValue;

  // Initialize the preferences
  Future<void> init() async {
    _asyncPrefs = SharedPreferencesAsync();

    _playerName = await loadPlayerName();
    themeColorHexValue = ValueNotifier<int>(await loadThemeColorHex());
  }

  Future<void> savePlayerName(String value) async {
    _playerName = value;
    await _asyncPrefs.setString("player_name", value);
  }

  Future<String> loadPlayerName() async {
    return await _asyncPrefs.getString("player_name") ?? "Player";
  }

  Future<void> saveThemeColorHex(int value) async {
    themeColorHexValue.value = value;
    await _asyncPrefs.setInt("color_hex_value", value);
  }

  Future<int> loadThemeColorHex() async {
    return await _asyncPrefs.getInt("color_hex_value") ?? 0xff7B61FF;
  }
}
