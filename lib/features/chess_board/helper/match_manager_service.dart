import 'dart:async';

import 'package:chess_app/core/basics/helper_methods.dart';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/constants/game_end_constraint.dart';
import 'package:chess_app/core/engine_bridge.dart';
import 'package:chess_app/features/chess_board/helper/fen_helper.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';

class MatchManagerService {
  late final FENHelper _fenHelper;
  FENHelper get fenHelper => _fenHelper;
  final EngineBridge _engineBridge = EngineBridge();

  final StreamController<MatchState> _stateController =
      StreamController<MatchState>.broadcast();
  Stream<MatchState> get stateStream => _stateController.stream;

  final StreamController<List<String>> _algebraicHistoryController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get algebraicHistoryStream =>
      _algebraicHistoryController.stream;

  final StreamController<GameResultType> _isMatchEndController =
      StreamController<GameResultType>.broadcast();
  Stream<GameResultType> get isMatchEndStream => _isMatchEndController.stream;

  late String _fen;
  String get fen => _fen;

  late final Sides _playerOneSide;
  Sides get playerOneSide => _playerOneSide;
  late final Sides _playerTwoSide;
  Sides get playerTwoSide => _playerTwoSide;

  late MatchState _matchState;
  MatchState get matchState => _matchState;
  late List<String> _algebraicHistory;
  List<String> get algebraicHistory => _algebraicHistory;

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
    _algebraicHistory = [];
  }

  void switchSide({bool isCheckmate = false}) async {
    int newFullMoveCount = _updateFullMoveNumber();
    Sides activeSide = Sides.fromValue(_matchState.activeSide.value ^ 1)!;
    bool isChecking = await _engineBridge.isKingInCheck(activeSide);
    _matchState = _matchState.copyWith(
      activeSide: activeSide,
      fullMoveNumber: newFullMoveCount,
      isChecking: isChecking,
      isCheckmate: isCheckmate,
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
    if (_draw75MovesRule(_matchState.halfMoveClock)) {
      _matchEnd(GameResultType.draw);
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
      _matchEnd(GameResultType.win);
    } else {
      _matchEnd(GameResultType.draw);
    }
  }

  void dispose() {
    _stateController.close();
    _algebraicHistoryController.close();
    _isMatchEndController.close();
  }

  void _matchEnd(GameResultType result) {
    _isMatchEndController.add(result);
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
}

class MatchState {
  final Sides activeSide; // Current active side
  final String castlingRight; // Castling right
  final Squares? enPassantTarget; // enpassant target sqsuare
  final int halfMoveClock;
  final int fullMoveNumber;
  final Map<Sides, List<PieceTypes>> capturedPieces;
  final bool isChecking;
  final bool isCheckmate;

  MatchState({
    required this.activeSide,
    required this.castlingRight,
    this.enPassantTarget,
    this.halfMoveClock = 0,
    this.fullMoveNumber = 0,
    Map<Sides, List<PieceTypes>>? capturedPieces,
    this.isChecking = false,
    this.isCheckmate = false,
  }) : capturedPieces = capturedPieces ?? {Sides.black: [], Sides.white: []};

  MatchState copyWith({
    Sides? activeSide,
    String? castlingRight,
    Squares? enPassantTarget,
    int? halfMoveClock,
    int? fullMoveNumber,
    Map<Sides, List<PieceTypes>>? capturedPieces,
    bool? isChecking,
    bool? isCheckmate,
  }) {
    return MatchState(
      activeSide: activeSide ?? this.activeSide,
      castlingRight: castlingRight ?? this.castlingRight,
      enPassantTarget: enPassantTarget ?? this.enPassantTarget,
      halfMoveClock: halfMoveClock ?? this.halfMoveClock,
      fullMoveNumber: fullMoveNumber ?? this.fullMoveNumber,
      capturedPieces: capturedPieces ?? this.capturedPieces,
      isChecking: isChecking ?? this.isChecking,
      isCheckmate: isCheckmate ?? this.isCheckmate,
    );
  }
}
