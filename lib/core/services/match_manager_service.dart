import 'dart:async';

import 'package:chess_app/core/basics/helper_methods.dart';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/constants/game_end_constraint.dart';
import 'package:chess_app/core/engine_interface/engine_bridge_factory.dart';
import 'package:chess_app/core/engine_interface/engine_bridge_interface.dart';
import 'package:chess_app/core/services/session_service.dart';
import 'package:chess_app/features/chess_board/helper/fen_helper.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';
import 'package:chess_app/features/match/model/match_end_result_model.dart';
import 'package:chess_app/features/match/model/match_state_model.dart';
import 'package:flutter/material.dart';

class MatchManagerService {
  final SessionService _sessionService;

  late final FENHelper _fenHelper;
  FENHelper get fenHelper => _fenHelper;
  final EngineBridgeInterface _engineBridge = getEngineBridge();

  final StreamController<int> _redoSignalController =
      StreamController<int>.broadcast();
  Stream<int> get redoSignalStream => _redoSignalController.stream;

  final StreamController<MatchState> _stateController =
      StreamController<MatchState>.broadcast();
  Stream<MatchState> get stateStream => _stateController.stream;

  final StreamController<List<String>> _algebraicHistoryController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get algebraicHistoryStream =>
      _algebraicHistoryController.stream;

  final ValueNotifier<MatchEndResult?> resultNotifier = ValueNotifier(null);

  bool _botEnabled = false;
  bool get botEnabled => _botEnabled;

  late String _fen;
  String get fen => _fen;

  late final Sides _playerOneSide;
  Sides get playerOneSide => _playerOneSide;
  late final Sides _playerTwoSide;
  Sides get playerTwoSide => _playerTwoSide;

  late int? _checkedKingSquare;
  int? get checkedKingSquare => _checkedKingSquare;

  late MatchState _matchState;
  MatchState get matchState => _matchState;
  late List<MatchState> _matchStateHistory;
  late List<String> _algebraicHistory;
  List<String> get algebraicHistory => _algebraicHistory;

  MatchManagerService(this._sessionService);

  void initialSet(String fen, Sides playerOneSide, bool isBotEnabled) {
    _botEnabled = isBotEnabled;
    _fen = fen.isEmpty ? FENHelper.startFEN : fen;
    _fenHelper = stringFENParser(_fen);
    _playerOneSide = playerOneSide;
    _playerTwoSide = Sides.opposite(playerOneSide);
    _matchState = MatchState(
      activeSide: _fenHelper.activeColor,
      castlingRight: _fenHelper.castlingAvailability,
      enPassantSquare: _fenHelper.enPassantTarget,
      halfMoveClock: _fenHelper.halfmoveClock,
      fullMoveNumber: _fenHelper.fullmoveNumber,
    );
    _matchStateHistory = [];
    _algebraicHistory = [];
  }

  Future<void> switchSide({bool isCheckmate = false}) async {
    int newFullMoveCount = _updateFullMoveNumber();
    Sides activeSide = Sides.opposite(_matchState.activeSide);
    bool isChecking = await _engineBridge.isKingInCheck(activeSide);
    _matchState = _matchState.copyWith(
      activeSide: activeSide,
      fullMoveNumber: newFullMoveCount,
      isChecking: isChecking,
      isCheckmate: isCheckmate,
    );
    _stateController.add(_matchState);
  }

  void pushMatchStateHistory() {
    _matchStateHistory.add(_matchState);
  }

  void proceedUnMakeMove() {
    for (int i = 2; i > 0; i--) {
      if (_matchStateHistory.isEmpty || _algebraicHistory.isEmpty) return;

      _matchStateHistory.removeLast();
      _matchState = _matchStateHistory.last;
      _algebraicHistory.removeLast();
      _engineBridge.unMakeMove();

      _redoSignalController.add(i);
      _stateController.add(_matchState);
      _algebraicHistoryController.add(_algebraicHistory);
    }
  }

  bool isPlayerOneTurn() {
    return _playerOneSide == _matchState.activeSide;
  }

  bool isPlayerTwoTurn() {
    return _playerTwoSide == _matchState.activeSide;
  }

  void updatePieceCaptured(PieceTypes piece) {
    if (piece == PieceTypes.pieceType_NB) return;

    final activeSide = _matchState.activeSide;
    final updated = {
      ..._matchState.capturedPieces,
      activeSide: [..._matchState.capturedPieces[activeSide]!, piece],
    };
    _matchState = _matchState.copyWith(capturedPieces: updated);
  }

  void setEnPassantTarget(int? index) {
    if (index == null) {
      _matchState = _matchState.copyWith(enPassantSquare: null);
      return;
    }
    Squares? enPassantTarget = Squares.fromIndex(index);
    _matchState = _matchState.copyWith(enPassantSquare: enPassantTarget);
  }

  void updateHalfMoveClock(PieceTypes movingPiece, MoveFlags flag) async {
    if (movingPiece != PieceTypes.pawn && flag != MoveFlags.capture) {
      _matchState = _matchState.copyWith(
        halfMoveClock: _matchState.halfMoveClock + 1,
      );
    } else {
      _matchState = _matchState.copyWith(halfMoveClock: 0);
    }

    if (await _engineBridge.isRepetition()) {
      _endMatch(POVResult.draw, Sides.color_NB, MatchResult.draw);
    }
    if (_draw75MovesRule(_matchState.halfMoveClock)) {
      _endMatch(POVResult.draw, Sides.color_NB, MatchResult.draw);
    }
  }

  void getAlgebraicNotation(PieceTypes movingPiece, MoveModel move) async {
    String disambiguation = await _engineBridge.disambiguating(
      matchState.activeSide,
      move.index,
    );
    String algebraic = toAlgebraic(
      movingPiece.name,
      move,
      disambiguation: disambiguation,
    );
    final List<String> newAlgebraicHistory = [..._algebraicHistory, algebraic];
    _algebraicHistory = newAlgebraicHistory;
    _algebraicHistoryController.add(_algebraicHistory);
  }

  void noLegalMoveToMake() {
    if (_matchState.isChecking) {
      _matchState = _matchState.copyWith(isChecking: false, isCheckmate: true);
      if (_matchState.activeSide == _playerOneSide) {
        _endMatch(POVResult.lose, _playerTwoSide, MatchResult.checkmate);
      } else {
        _endMatch(POVResult.win, _playerOneSide, MatchResult.checkmate);
      }
    } else {
      _endMatch(POVResult.draw, Sides.color_NB, MatchResult.draw);
    }
  }

  void timerEnd(Sides endedSide) {
    if (endedSide == _playerOneSide) {
      _endMatch(POVResult.lose, _playerTwoSide, MatchResult.timeout);
    } else {
      _endMatch(POVResult.win, _playerOneSide, MatchResult.timeout);
    }
  }

  void _endMatch(POVResult resultPOV, Sides winner, MatchResult result) {
    resultNotifier.value = MatchEndResult(resultPOV, result);
    _sessionService.endMatch(winner.name, result.name);
  }

  int _updateFullMoveNumber() {
    if (_matchState.activeSide == Sides.black) {
      return _matchState.fullMoveNumber + 1;
    }
    return _matchState.fullMoveNumber;
  }

  bool _draw75MovesRule(int halfMoveClock) {
    return halfMoveClock == automaticDrawHalfMoves;
  }

  void dispose() {
    _stateController.close();
    _algebraicHistoryController.close();
    _redoSignalController.close();
    resultNotifier.dispose();
  }
}
