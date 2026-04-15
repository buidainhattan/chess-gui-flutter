import 'dart:async';

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
  bool _matchInProgress = false;
  bool get matchInProgress => _matchInProgress;

  String? _matchId;
  Sides _playerSide = Sides.white;
  Sides get playerSide => _playerSide;

  late StreamController<String> _opponentMoveController;
  Stream<String> get opponentMoveStream => _opponentMoveController.stream;

  String _gameMode = "pvp";
  String get gameMode => _gameMode;
  TimeMode _timeMode = TimeMode.normal;
  TimeMode get timeMode => _timeMode;
  TimeSetting _timeSetting = TimeSetting(10, 0);
  TimeSetting get timeSetting => _timeSetting;

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
    _matchId = null;
    _socket.disconnect();
  }

  void joinMatchMaking() {
    _matchMakingStatus = MatchMakingStatus.pending;
    notifyListeners();

    _socket.on("match_start", (data) {
      _matchInProgress = true;
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

  void endMatch(String winner, String result) {
    if (!_isOnline) return;

    _matchInProgress = false;

    _socket.emit("match_ended", {
      "matchId": _matchId,
      "winner": winner.toUpperCase(),
      "result": result.toUpperCase(),
    });
  }

  void leaveMatch() {
    if (_isOnline && _matchInProgress) {
      endMatch(Sides.opposite(_playerSide).name, MatchResult.resignation.name);
      _matchInProgress = false;
    }

    disconnectSocket();
  }

  void updateGameMode(String mode) {
    _gameMode = mode;
  }

  void updateTimeMode(TimeMode mode) {
    _timeMode = mode;
  }

  void updateTimeSetting(TimeSetting setting) {
    _timeSetting = setting;
  }

  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
    _opponentMoveController.close();
    super.dispose();
  }
}
