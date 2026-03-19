import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/main_menu/model/time_setting_model.dart';
import 'package:flutter/material.dart';

class SessionDataService extends ChangeNotifier {
  String _gameMode = "pvp";
  String _timeMode = "normal";
  String _timeSetting = "10 min";

  String get gameMode => _gameMode;
  String get timeMode => _timeMode;
  String get timeSetting => _timeSetting;

  void updateGameMode(String mode) {
    _gameMode = mode;
  }

  void updateTimeMode(String mode) {
    _timeMode = mode;
  }

  void updateTimeSetting(String setting) {
    _timeSetting = setting;
  }

  TimeSetting getSelectedSetting() {
    return TimeMode.fromName(_timeMode)!.settings[_timeSetting]!;
  }
}
