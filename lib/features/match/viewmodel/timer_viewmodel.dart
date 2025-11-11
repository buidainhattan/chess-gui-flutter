import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/match_manager_service.dart';
import 'package:flutter/widgets.dart';

class TimerViewmodel extends ChangeNotifier {
  final MatchManagerService _matchManagerService;

  Timer? _timer;
  DateTime? _lastTickTime;
  bool _isTimerRunning = false;
  Duration _playerOneRemainingTime = const Duration(minutes: 10);
  Duration _playerTwoRemainingTime = const Duration(minutes: 10);
  late String playerOneTime;
  late String playerTwoTime;

  late Sides _playerOneSide;
  late Sides _playerTwoSide;
  late Sides _sideToMove;

  late final StreamSubscription _matchStateSubscription;

  TimerViewmodel(this._matchManagerService) {
    _playerOneSide = _matchManagerService.playerOneSide;
    _playerTwoSide = _matchManagerService.playerTwoSide;
    _sideToMove = _matchManagerService.matchState.activeSide;

    playerOneTime = _formatDuration(_playerOneRemainingTime);
    playerTwoTime = _formatDuration(_playerTwoRemainingTime);

    _startTimer();

    _matchStateSubscription = _matchManagerService.stateStream.listen((
      newState,
    ) {
      if (_sideToMove == newState.activeSide) {
        return;
      } else {
        _sideToMove = newState.activeSide;
      }
    });
  }

  @override
  void dispose() {
    _matchStateSubscription.cancel();
    _timer?.cancel();
    super.dispose();
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

    notifyListeners();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final miliseconds = duration.inMilliseconds.remainder(1000);

    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');
    final formattedMiliseconds = miliseconds.toString().padLeft(4, '0');

    return '$formattedMinutes:$formattedSeconds:$formattedMiliseconds';
  }
}
