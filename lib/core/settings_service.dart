import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferencesAsync _asyncPrefs;

  late String _playerName;
  String get playerName => _playerName;
  late int _colorHexValue;
  int get colorHexValue => _colorHexValue;

  // Initialize the preferences
  Future<void> init() async {
    _asyncPrefs = SharedPreferencesAsync();

    _playerName = await loadPlayerName();
    _colorHexValue = await loadColorHex();
  }

  Future<void> savePlayerName(String value) async {
    _playerName = value;
    await _asyncPrefs.setString("player_name", value);
  }

  Future<String> loadPlayerName() async {
    return await _asyncPrefs.getString("player_name") ?? "Player";
  }

  Future<void> saveColorHex(int value) async {
    _colorHexValue = value;
    await _asyncPrefs.setInt("color_hex_value", value);
  }

  Future<int> loadColorHex() async {
    return await _asyncPrefs.getInt("color_hex_value") ?? 0xff7B61FF;
  }
}
