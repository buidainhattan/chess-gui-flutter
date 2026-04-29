import 'dart:async';

import 'package:chess_app/core/basics/duration_extensions.dart';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/services/match_manager_service.dart';
import 'package:chess_app/features/main_menu/model/time_setting_model.dart';
import 'package:chess_app/features/match/model/match_end_result_model.dart';
import 'package:flutter/widgets.dart';

class TimerViewmodel extends ChangeNotifier {
  final MatchManagerService _matchManagerService;

  Timer? _timer;
  DateTime? _lastTickTime;
  bool _isTimerRunning = false;
  late Duration _playerOneRemainingTime;
  late Duration _playerTwoRemainingTime;
  late String playerOneTime;
  late String playerTwoTime;
  late Duration _increment;

  late Sides _playerOneSide;
  late Sides _playerTwoSide;
  late Sides _sideToMove;

  late final StreamSubscription _matchStateSubscription;

  TimerViewmodel(this._matchManagerService) {
    _playerOneSide = _matchManagerService.playerOneSide;
    _playerTwoSide = _matchManagerService.playerTwoSide;
    _sideToMove = _matchManagerService.matchState.activeSide;

    _matchStateSubscription = _matchManagerService.stateStream.listen((
      newState,
    ) {
      _increaseTimer(_sideToMove);
      if (_sideToMove == newState.activeSide) {
        return;
      }
      _sideToMove = newState.activeSide;
    });

    _matchManagerService.resultNotifier.addListener(_onMatchEnd);
  }

  void setAndStartTimer({TimeSetting? setting}) {
    if (setting == null) {
      _playerOneRemainingTime = _playerTwoRemainingTime = const Duration(
        minutes: 10,
      );
      _increment = const Duration(seconds: 0);
    } else {
      _playerOneRemainingTime = _playerTwoRemainingTime = setting.timeDuration;
      _increment = Duration(seconds: setting.increment);
    }

    playerOneTime = _playerOneRemainingTime.toFormattedString();
    playerTwoTime = _playerTwoRemainingTime.toFormattedString();

    _startTimer();
  }

  void _onMatchEnd() {
    final MatchEndResult? result = _matchManagerService.resultNotifier.value;
    if (result == null) return;

    _stopTimer();
  }

  void _increaseTimer(Sides endTurnSide) {
    if (endTurnSide == _playerOneSide) {
      _playerOneRemainingTime += _increment;
      playerOneTime = _playerOneRemainingTime.toFormattedString();
    } else {
      _playerTwoRemainingTime += _increment;
      playerTwoTime = _playerTwoRemainingTime.toFormattedString();
    }
  }

  void _startTimer() {
    if (_isTimerRunning) return;

    _isTimerRunning = true;
    _lastTickTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);
  }

  void _tick(Timer timer) {
    if (!_isTimerRunning) {
      _timer?.cancel();
      return;
    }

    if (_lastTickTime == null) return;

    final DateTime now = DateTime.now();
    final Duration elapsed = now.difference(_lastTickTime!);
    if (_sideToMove == _playerOneSide) {
      if (_playerOneRemainingTime > Duration.zero) {
        _playerOneRemainingTime -= elapsed;
      } else {
        _playerOneRemainingTime = Duration.zero;
        _matchManagerService.timerEnd(_playerOneSide);
      }
      playerOneTime = _playerOneRemainingTime.toFormattedString();
    }
    if (_sideToMove == _playerTwoSide) {
      if (_playerTwoRemainingTime > Duration.zero) {
        _playerTwoRemainingTime -= elapsed;
      } else {
        _playerTwoRemainingTime = Duration.zero;
        _matchManagerService.timerEnd(_playerTwoSide);
      }
      playerTwoTime = _playerTwoRemainingTime.toFormattedString();
    }
    _lastTickTime = now;

    notifyListeners();
  }

  void _stopTimer() {
    _isTimerRunning = false;
    _timer?.cancel();
  }

  @override
  void dispose() {
    _matchStateSubscription.cancel();
    _timer?.cancel();
    _matchManagerService.resultNotifier.removeListener(_onMatchEnd);
    super.dispose();
  }
}
