import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/fen_helper.dart';

class MatchManagerService {
  final StreamController<MatchState> _stateController =
      StreamController<MatchState>.broadcast();
  Stream<MatchState> get stateStream => _stateController.stream;

  late final Sides _playerOneSide;
  Sides get playerOneSide => _playerOneSide;
  late final Sides _playerTwoSide;
  Sides get playerTwoSide => _playerTwoSide;

  late MatchState _matchState;
  MatchState get matchState => _matchState;

  bool botEnabled = false;

  static final MatchManagerService _instance = MatchManagerService._internal();
  factory MatchManagerService() {
    return _instance;
  }

  MatchManagerService._internal();

  void initialSet(FENHelper fen, Sides playerOneSide) {
    _playerOneSide = playerOneSide;
    _playerTwoSide = playerOneSide == Sides.white ? Sides.black : Sides.white;
    _matchState = MatchState(
      activeSide: fen.activeColor,
      castlingRight: fen.castlingAvailability,
      enPassantTarget: fen.enPassantTarget,
      halfMoveClock: fen.halfmoveClock,
      fullMoveNumber: fen.fullmoveNumber,
    );
  }

  void switchSide() {
    Sides activeSide = Sides.fromValue(_matchState.activeSide.value ^ 1)!;
    _matchState = _matchState.copyWith(activeSide: activeSide);
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
      _matchState.copyWith(enPassantTarget: null);
      return;
    }
    Squares? enPassantTarget = Squares.fromIndex(index);
    _matchState.copyWith(enPassantTarget: enPassantTarget);
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
      enPassantTarget: enPassantTarget,
      halfMoveClock: halfMoveClock ?? this.halfMoveClock,
      fullMoveNumber: fullMoveNumber ?? this.fullMoveNumber,
      capturedPieces: capturedPieces ?? this.capturedPieces,
    );
  }
}
