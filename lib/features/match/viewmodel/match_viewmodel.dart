import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/services/settings_service.dart';
import 'package:chess_app/core/services/match_manager_service.dart';
import 'package:chess_app/features/match/model/match_end_result_model.dart';
import 'package:flutter/widgets.dart';

class MatchViewmodel extends ChangeNotifier {
  final SettingsService _settingsService;
  final MatchManagerService _matchManagerService;

  late bool botEnabled;

  late final String playerOneName;
  late final Sides playerOneSide;
  final String playerTwoName = "player 2";
  late final Sides playerTwoSide;
  late Sides sideToMove;
  late String playerOneCastlingRight;
  late String playerTwoCastlingRight;
  late int halfMoveClock;
  late int fullMoveCount;

  late List<PieceTypes> playerOnePieceCaptured;
  late List<PieceTypes> playerTwoPieceCaptured;

  late List<String> algebraicHistory;

  late Duration elapsedTime;

  MatchEndResult? result;

  late final StreamSubscription _matchStateSubscription;
  late final StreamSubscription _algebraicHistorySubscription;

  MatchViewmodel(this._settingsService, this._matchManagerService) {
    botEnabled = _matchManagerService.botEnabled;
    playerOneName = _settingsService.playerName;
    playerOneSide = _matchManagerService.playerOneSide;
    playerTwoSide = _matchManagerService.playerTwoSide;
    playerOnePieceCaptured =
        _matchManagerService.matchState.capturedPieces[playerOneSide]!;
    playerTwoPieceCaptured =
        _matchManagerService.matchState.capturedPieces[playerTwoSide]!;

    sideToMove = _matchManagerService.matchState.activeSide;
    halfMoveClock = _matchManagerService.matchState.halfMoveClock;
    fullMoveCount = _matchManagerService.matchState.fullMoveNumber;

    algebraicHistory = _matchManagerService.algebraicHistory;

    elapsedTime = _matchManagerService.elapsedTime;

    _matchStateSubscription = _matchManagerService.stateStream.listen((
      newState,
    ) {
      sideToMove = newState.activeSide;
      halfMoveClock = newState.halfMoveClock;
      fullMoveCount = newState.fullMoveNumber;
      playerOnePieceCaptured = newState.capturedPieces[playerOneSide]!;
      playerTwoPieceCaptured = newState.capturedPieces[playerTwoSide]!;

      notifyListeners();
    });

    _algebraicHistorySubscription = _matchManagerService.algebraicHistoryStream
        .listen((newState) {
          algebraicHistory = List<String>.from(newState);

          notifyListeners();
        });

    _matchManagerService.resultNotifier.addListener(_onMatchEnd);
  }

  void relayUnMakeSignal() {
    if (!_matchManagerService.botEnabled) return;

    _matchManagerService.proceedUnMakeMove();

    notifyListeners();
  }

  void _onMatchEnd() {
    result = _matchManagerService.resultNotifier.value;
    elapsedTime = _matchManagerService.elapsedTime;

    notifyListeners();
  }

  @override
  void dispose() {
    _matchStateSubscription.cancel();
    _algebraicHistorySubscription.cancel();
    _matchManagerService.resultNotifier.removeListener(_onMatchEnd);
    super.dispose();
  }
}
