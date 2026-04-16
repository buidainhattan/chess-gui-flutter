import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferences _prefs;

  // Initialize the preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a boolean based on a key (like your index-based system)
  Future<void> saveSetting(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Load a boolean, default to false if not found
  bool loadSetting(String key) {
    return _prefs.getBool(key) ?? false;
  }
}
