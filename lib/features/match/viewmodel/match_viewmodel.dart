import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/match_manager_service.dart';
import 'package:flutter/widgets.dart';

class MatchViewmodel extends ChangeNotifier {
  final MatchManagerService _matchManagerService;

  late final String playerOneSide;
  late final String playerTwoSide;
  late String sideToMove;
  late String playerOneCastlingRight;
  late String playerTwoCastlingRight;
  late int halfMoveClock;
  late int fullMoveCount;

  late List<PieceTypes> playerOnePieceCaptured;
  late List<PieceTypes> playerTwoPieceCaptured;

  late List<String> algebraicHistory;

  bool isMatchEnd = false;
  late bool isWinner;

  late final StreamSubscription _matchStateSubscription;
  late final StreamSubscription _algebraicHistorySubscription;
  late final StreamSubscription _isMatchEndSubscription;

  MatchViewmodel(this._matchManagerService) {
    playerOneSide = _matchManagerService.playerOneSide.name;
    playerTwoSide = _matchManagerService.playerTwoSide.name;
    playerOnePieceCaptured = _matchManagerService
        .matchState
        .capturedPieces[Sides.fromName(playerOneSide)]!;
    playerTwoPieceCaptured = _matchManagerService
        .matchState
        .capturedPieces[Sides.fromName(playerTwoSide)]!;

    sideToMove = _matchManagerService.matchState.activeSide.name;
    halfMoveClock = _matchManagerService.matchState.halfMoveClock;
    fullMoveCount = _matchManagerService.matchState.fullMoveNumber;

    algebraicHistory = _matchManagerService.algebraicHistory;

    _matchStateSubscription = _matchManagerService.stateStream.listen((
      newState,
    ) {
      sideToMove = newState.activeSide.name;
      halfMoveClock = newState.halfMoveClock;
      fullMoveCount = newState.fullMoveNumber;
      playerOnePieceCaptured =
          newState.capturedPieces[Sides.fromName(playerOneSide)]!;
      playerTwoPieceCaptured =
          newState.capturedPieces[Sides.fromName(playerTwoSide)]!;

      notifyListeners();
    });

    _algebraicHistorySubscription = _matchManagerService.algebraicHistoryStream
        .listen((newState) {
          algebraicHistory = newState;

          notifyListeners();
        });

    _isMatchEndSubscription = _matchManagerService.isMatchEndStream.listen((
      newState,
    ) {
      isMatchEnd = newState.$1;
      isWinner = newState.$2.name == playerOneSide;

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _matchStateSubscription.cancel();
    _isMatchEndSubscription.cancel();
    _algebraicHistorySubscription.cancel();
    super.dispose();
  }
}
