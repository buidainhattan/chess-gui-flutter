import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/fen_helper.dart';

class MatchManagerService {
  late final FENHelper _fenHelper;
  FENHelper get fenHelper => _fenHelper;

  final StreamController<MatchState> _stateController =
      StreamController<MatchState>.broadcast();
  Stream<MatchState> get stateStream => _stateController.stream;

  final StreamController<(bool, Sides)> _isMatchEndController =
      StreamController<(bool, Sides)>.broadcast();
  Stream<(bool, Sides)> get isMatchEndStream => _isMatchEndController.stream;

  late String _fen;
  String get fen => _fen;

  late final Sides _playerOneSide;
  Sides get playerOneSide => _playerOneSide;
  late final Sides _playerTwoSide;
  Sides get playerTwoSide => _playerTwoSide;

  late MatchState _matchState;
  MatchState get matchState => _matchState;

  bool botEnabled = false;

  void initialSet(String fen, Sides playerOneSide) {
    _fen = fen.isEmpty ? FENHelper.startFEN : fen;
    _fenHelper = stringFENParser(_fen);
    _playerOneSide = playerOneSide;
    _playerTwoSide = playerOneSide == Sides.white ? Sides.black : Sides.white;
    _matchState = MatchState(
      activeSide: _fenHelper.activeColor,
      castlingRight: _fenHelper.castlingAvailability,
      enPassantTarget: _fenHelper.enPassantTarget,
      halfMoveClock: _fenHelper.halfmoveClock,
      fullMoveNumber: _fenHelper.fullmoveNumber,
    );
  }

  void switchSide() {
    int newFullMoveCount = _updateFullMoveNumber();
    Sides activeSide = Sides.fromValue(_matchState.activeSide.value ^ 1)!;
    _matchState = _matchState.copyWith(
      activeSide: activeSide,
      fullMoveNumber: newFullMoveCount,
    );
    _stateController.add(_matchState);
  }

  bool isPlayerOneTurn() {
    return _playerOneSide == _matchState.activeSide;
  }

  bool isPlayerTwoTurn() {
    return _playerTwoSide == _matchState.activeSide;
  }

  void updatePieceCaptured(PieceTypes piece) {
    _matchState.capturedPieces[_matchState.activeSide]!.add(piece);
  }

  void setEnPassantTarget(int? index) {
    if (index == null) {
      _matchState = _matchState.copyWith(enPassantTarget: null);
      return;
    }
    Squares? enPassantTarget = Squares.fromIndex(index);
    _matchState = _matchState.copyWith(enPassantTarget: enPassantTarget);
  }

  void updateHalfMoveClock(PieceTypes movingPiece, MoveFlags flag) {
    if (movingPiece != PieceTypes.pawn && flag != MoveFlags.capture) {
      _matchState = _matchState.copyWith(
        halfMoveClock: _matchState.halfMoveClock + 1,
      );
    } else {
      _matchState = _matchState.copyWith(halfMoveClock: 0);
    }
  }

  void matchEnd() {
    Sides winnerSide = _matchState.activeSide == Sides.white
        ? Sides.black
        : Sides.white;
    _isMatchEndController.add((true, winnerSide));
  }

  void dispose() {
    _stateController.close();
    _isMatchEndController.close();
  }

  int _updateFullMoveNumber() {
    if (_matchState.activeSide == Sides.black) {
      return _matchState.fullMoveNumber + 1;
    }
    return _matchState.fullMoveNumber;
  }
}

class MatchState {
  final Sides activeSide; // Current active side
  final String castlingRight; // Castling right
  final Squares? enPassantTarget; // enpassant target sqsuare
  final int halfMoveClock;
  final int fullMoveNumber;
  final Map<Sides, List<PieceTypes>> capturedPieces;

  MatchState({
    required this.activeSide,
    required this.castlingRight,
    this.enPassantTarget,
    this.halfMoveClock = 0,
    this.fullMoveNumber = 0,
    Map<Sides, List<PieceTypes>>? capturedPieces,
  }) : capturedPieces = capturedPieces ?? {Sides.black: [], Sides.white: []};

  MatchState copyWith({
    Sides? activeSide,
    String? castlingRight,
    Squares? enPassantTarget,
    int? halfMoveClock,
    int? fullMoveNumber,
    Map<Sides, List<PieceTypes>>? capturedPieces,
  }) {
    return MatchState(
      activeSide: activeSide ?? this.activeSide,
      castlingRight: castlingRight ?? this.castlingRight,
      enPassantTarget: enPassantTarget ?? this.enPassantTarget,
      halfMoveClock: halfMoveClock ?? this.halfMoveClock,
      fullMoveNumber: fullMoveNumber ?? this.fullMoveNumber,
      capturedPieces: capturedPieces ?? this.capturedPieces,
    );
  }
}
