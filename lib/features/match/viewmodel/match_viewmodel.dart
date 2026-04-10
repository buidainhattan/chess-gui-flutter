import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/match_manager_service.dart';
import 'package:flutter/widgets.dart';

class MatchViewmodel extends ChangeNotifier {
  final MatchManagerService _matchManagerService;

  late bool botEnabled;

  late final Sides playerOneSide;
  late final Sides playerTwoSide;
  late Sides sideToMove;
  late String playerOneCastlingRight;
  late String playerTwoCastlingRight;
  late int halfMoveClock;
  late int fullMoveCount;

  late List<PieceTypes> playerOnePieceCaptured;
  late List<PieceTypes> playerTwoPieceCaptured;

  late List<String> algebraicHistory;

  FirstPlayerPOVResult result = FirstPlayerPOVResult.ongoing;

  late final StreamSubscription _matchStateSubscription;
  late final StreamSubscription _algebraicHistorySubscription;
  late final StreamSubscription _isMatchEndSubscription;

  MatchViewmodel(this._matchManagerService) {
    botEnabled = _matchManagerService.botEnabled;
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

    _isMatchEndSubscription = _matchManagerService.isMatchEndStream.listen((
      newState,
    ) {
      result = newState;

      notifyListeners();
    });
  }

  void relayUnMakeSignal() {
    if (!_matchManagerService.botEnabled) return;

    _matchManagerService.proceedUnMakeMove();

    notifyListeners();
  }

  @override
  void dispose() {
    _matchStateSubscription.cancel();
    _isMatchEndSubscription.cancel();
    _algebraicHistorySubscription.cancel();
    super.dispose();
  }
}
