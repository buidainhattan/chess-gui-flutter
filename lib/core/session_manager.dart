// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/main_menu/model/time_setting_model.dart';
import 'package:flutter/material.dart';

class SessionManagerService extends ChangeNotifier {
  late IO.Socket _socket;

  bool _isOnline = false;
  bool get isOnline => _isOnline;
  bool _isQueuing = false;
  bool get isQueuing => _isQueuing;

  String _gameMode = "pvp";
  String _timeMode = "normal";
  String _timeSetting = "10 min";

  String get gameMode => _gameMode;
  String get timeMode => _timeMode;
  String get timeSetting => _timeSetting;

  void connectSocket() {
    _socket = IO.io(
      "http://localhost:3000",
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      _isOnline = true;
    });

    _socket.onDisconnect((_) {
      _isOnline = false;
    });
  }

  void disconnectSocket() {
    _socket.disconnect();
  }

  void joinMatchMaking() {
    _socket.on("match_start", (data) {
      if (data["status"] == "MATCH_FOUND") {
        _isQueuing = false;
        notifyListeners();
      }
    });

    _socket.emit("join_match_making");

    _isQueuing = true;
    notifyListeners();
  }

  void leaveMatchMaking() {
    _socket.clearListeners();
    _socket.emit("leave_match_making");
    _isQueuing = false;
  }

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

  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
    super.dispose();
  }
}
