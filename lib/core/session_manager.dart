import 'dart:async';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart'
    as IO; // ignore: library_prefixes

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/main_menu/model/time_setting_model.dart';
import 'package:flutter/material.dart';

class SessionManagerService extends ChangeNotifier {
  late IO.Socket _socket;

  bool _isOnline = false;
  bool get isOnline => _isOnline;
  MatchMakingStatus? _matchMakingStatus;
  MatchMakingStatus? get matchMakingStatus => _matchMakingStatus;

  late final String _matchId;
  Sides _playerSide =Sides.white;
  Sides get playerSide => _playerSide;

  late StreamController<String> _opponentMoveController;
  Stream<String> get opponentMoveStream => _opponentMoveController.stream;

  String _gameMode = "pvp";
  String _timeMode = "normal";
  String _timeSetting = "10 min";

  String get gameMode => _gameMode;
  String get timeMode => _timeMode;
  String get timeSetting => _timeSetting;

  void connectSocket() {
    if (Platform.isAndroid) {
      _socket = IO.io(
        "http://192.168.0.102:3000",
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build(),
      );
    } else {
      _socket = IO.io(
        "http://localhost:3000",
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build(),
      );
    }

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
    _matchMakingStatus = MatchMakingStatus.pending;
    notifyListeners();

    _socket.on("match_start", (data) {
      _opponentMoveController = StreamController<String>.broadcast();
      _matchId = data["id"];
      if (_socket.id == data["playerWhiteId"]) {
        _playerSide = Sides.white;
      } else {
        _playerSide = Sides.black;
      }
      _matchMakingStatus = MatchMakingStatus.matchFound;
      notifyListeners();

      _socket.clearListeners();
      _socket.on("opponent_move", (data) {
        _opponentMoveController.add(data["move"]);
      });
    });

    _socket.emit("join_match_making");
  }

  void leaveMatchMaking() {
    _matchMakingStatus = MatchMakingStatus.cancelled;

    _socket.clearListeners();
    _socket.emit("leave_match_making");
  }

  void makeMove(String move) {
    if (!_isOnline) return;

    _socket.emit("make_move", {"matchId": _matchId, "move": move});
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
    _opponentMoveController.close();
    super.dispose();
  }
}
