import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferencesAsync _asyncPrefs;

  final List<int> _defaultColorHexList = <int>[
    0xff6C3CE1,
    0xffFF5757,
    0xffFF9A3C,
    0xff00C896,
    0xff2FAEFF,
  ];

  late String _playerName;
  String get playerName => _playerName;
  late List<int> _colorHexList;
  List<int> get colorHexList => _colorHexList;
  late final ValueNotifier<int> themeColorHexValue;

  // Initialize the preferences
  Future<void> init() async {
    _asyncPrefs = SharedPreferencesAsync();

    _playerName = await loadPlayerName();
    _colorHexList = await loadColorHexToList();
    themeColorHexValue = ValueNotifier<int>(await loadThemeColorHex());
  }

  Future<void> savePlayerName(String value) async {
    _playerName = value;
    await _asyncPrefs.setString("player_name", value);
  }

  Future<String> loadPlayerName() async {
    return await _asyncPrefs.getString("player_name") ?? "Player";
  }

  Future<void> saveColorHexToList(int value) async {
    _colorHexList.add(value);
    final List<String> colorHexStrList = _colorHexList
        .map((element) => element.toString())
        .toList();
    await _asyncPrefs.setStringList("color_list", colorHexStrList);
  }

  Future<void> deleteColorHexFromList(int value) async {
    _colorHexList.remove(value);
    final List<String> colorHexStrList = _colorHexList
        .map((element) => element.toString())
        .toList();
    await _asyncPrefs.setStringList("color_list", colorHexStrList);
  }

  Future<List<int>> loadColorHexToList() async {
    final List<String>? colorHexStrList = await _asyncPrefs.getStringList(
      "color_list",
    );
    if (colorHexStrList == null) {
      return _defaultColorHexList;
    } else {
      return colorHexStrList.map(int.parse).toList();
    }
  }

  Future<void> saveThemeColorHex(int value) async {
    themeColorHexValue.value = value;
    await _asyncPrefs.setInt("color_hex_value", value);
  }

  Future<int> loadThemeColorHex() async {
    return await _asyncPrefs.getInt("color_hex_value") ?? 0xff7B61FF;
  }
}
