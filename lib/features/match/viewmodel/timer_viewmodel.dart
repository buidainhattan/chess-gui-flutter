import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/match_manager_service.dart';
import 'package:chess_app/features/main_menu/model/time_setting_model.dart';
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

  late Sides _playerOneSide;
  late Sides _playerTwoSide;
  late Sides _sideToMove;

  late final StreamSubscription _matchStateSubscription;
  late final StreamSubscription _isMatchEndSubscription;

  TimerViewmodel(this._matchManagerService) {
    _playerOneSide = _matchManagerService.playerOneSide;
    _playerTwoSide = _matchManagerService.playerTwoSide;
    _sideToMove = _matchManagerService.matchState.activeSide;

    _matchStateSubscription = _matchManagerService.stateStream.listen((
      newState,
    ) {
      if (_sideToMove == newState.activeSide) {
        return;
      } else {
        _sideToMove = newState.activeSide;
      }
    });

    _isMatchEndSubscription = _matchManagerService.isMatchEndStream.listen((
      newState,
    ) {
      if (newState != GameResultType.ongoing) {
        _stopTimer();
      }
    });
  }

  @override
  void dispose() {
    _matchStateSubscription.cancel();
    _isMatchEndSubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void setAndStartTimer({TimeSetting? setting}) {
    if (setting == null) {
      _playerOneRemainingTime = _playerTwoRemainingTime = const Duration(
        minutes: 10,
      );
    } else {
      Duration duration = setting.timeDuration;
      _playerOneRemainingTime = _playerTwoRemainingTime = duration;
    }

    playerOneTime = _formatDuration(_playerOneRemainingTime);
    playerTwoTime = _formatDuration(_playerTwoRemainingTime);

    _startTimer();
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
      }
      playerOneTime = _formatDuration(_playerOneRemainingTime);
    }
    if (_sideToMove == _playerTwoSide) {
      if (_playerTwoRemainingTime > Duration.zero) {
        _playerTwoRemainingTime -= elapsed;
      } else {
        _playerTwoRemainingTime = Duration.zero;
      }
      playerTwoTime = _formatDuration(_playerTwoRemainingTime);
    }
    _lastTickTime = now;

    if (_playerOneRemainingTime <= Duration.zero) {
      _matchManagerService.timerEnd(_playerOneSide);
    }
    if (_playerTwoRemainingTime <= Duration.zero) {
      _matchManagerService.timerEnd(_playerTwoSide);
    }

    notifyListeners();
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }
}
