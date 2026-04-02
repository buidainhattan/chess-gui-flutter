import 'dart:async';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/controllers/audio_controller.dart';
import 'package:chess_app/core/engine_bridge.dart';
import 'package:chess_app/features/chess_board/model/board_state_model.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:chess_app/features/chess_board/helper/match_manager_service.dart';
import 'package:chess_app/features/chess_board/helper/move_manager.dart';
import 'package:flutter/material.dart';

class ChessBoardViewmodel extends ChangeNotifier {
  final AudioController _audioController = AudioController();
  final EngineBridge _engineBridge = EngineBridge();
  final MoveManager _moveManager = MoveManager();
  final MatchManagerService _matchManagerService;

  late final StreamSubscription _redoSignalSubscription;
  late final StreamSubscription _isMatchEndSubscription;

  // <--- State to control GUI --->
  late Sides _playerOneSide;
  Sides get playerOneSide => _playerOneSide;

  late BoardState _boardState;
  BoardState get boardState => _boardState;
  late final List<BoardState> _boardStateHistory;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  GameResultType result = GameResultType.ongoing;

  ChessBoardViewmodel(this._matchManagerService);

  // <===== Initialize ChessBoard ====>
  Future<void> initializeChessBoard() async {
    if (_isInitialized) return;

    _boardStateHistory = [];

    await _parseFEN();

    for (var piece in _boardState.pieceList.values) {
      final int pieceSquareIndex = piece.index;
      final String pieceKey = piece.key;
      List<String> pieceKeys = _boardState.pieceKeys;
      pieceKeys[pieceSquareIndex] = pieceKey;
      _boardState.copyWith(pieceKeys: pieceKeys);
    }

    _redoSignalSubscription = _matchManagerService.redoSignalStream.listen((
      newState,
    ) async {
      await _unMakeMove(newState);
    });

    _isMatchEndSubscription = _matchManagerService.isMatchEndStream.listen((
      newState,
    ) {
      result = newState;

      notifyListeners();
    });

    _isInitialized = true;
    await _startTurn();
  }

  Future<void> _parseFEN() async {
    String fen = _matchManagerService.fen;
    await _engineBridge.loadFromFEN(fen);
    _playerOneSide = _matchManagerService.playerOneSide;
    Sides activeSide = _matchManagerService.matchState.activeSide;
    Map<String, PieceModel> pieceList =
        _matchManagerService.fenHelper.pieceList;
    _boardState = BoardState(activeSide: activeSide, pieceList: pieceList);
  }
  // <===== End Initialization =====>

  // |==================================================|

  // <===== Turn Cycle Logic =====>
  Future<void> _startTurn({bool isUnMake = false}) async {
    if (!isUnMake) {
      _boardStateHistory.add(_boardState);
      _matchManagerService.pushMatchStateHistory();
    }

    if (_matchManagerService.botEnabled &&
        _matchManagerService.isPlayerTwoTurn()) {
      await _startBotBehavior();
      return;
    }

    await _getMoves();
  }

  Future<void> _makeMove(MoveModel move) async {
    String pieceToMoveKey = _boardState.pieceKeys[move.from];
    PieceModel? pieceToMove = _boardState.pieceList[pieceToMoveKey];
    int fromSquare = move.from;
    int toSquare = move.to;
    MoveFlags flag = move.moveFlag;

    if (pieceToMove == null) return;

    switch (flag) {
      case MoveFlags.doublePawnPush:
        _matchManagerService.setEnPassantTarget(toSquare);
      case (MoveFlags.promotion || MoveFlags.promotionCapture):
        if (!_matchManagerService.botEnabled) {
          _openPromotionDialog();
        } else {
          if (_matchManagerService.isPlayerTwoTurn()) {
            PieceTypes? piecePromotedTo = move.piecePromotedTo;
            _botPromotePiece(fromSquare, piecePromotedTo);
          }
        }
        if (flag == MoveFlags.promotionCapture) continue capture;
      capture:
      case MoveFlags.capture:
        _capturePiece(toSquare);
      case MoveFlags.enPassant:
        _enPasssantCapture();
      case (MoveFlags.kingCastle || MoveFlags.queenCastle):
        _castling(flag);
      default:
        _matchManagerService.setEnPassantTarget(null);
    }
    _movePiece(pieceToMoveKey, fromSquare, toSquare);
    _audioController.playSoundEffect(_getSound(move.moveFlag));
    _deSelectPiece();
    notifyListeners();

    if (_boardState.isPromotion) return;

    _engineBridge.makeMove(move.index);
    await _endTurn(pieceToMove.type, move);
  }

  Future<void> _unMakeMove(int loopCount) async {
    _boardStateHistory.removeLast();
    _boardState = _boardStateHistory.last;

    if (loopCount <= 1) {
      await _startTurn(isUnMake: true);
    }

    notifyListeners();
  }

  // Move a piece to a new square
  void _movePiece(String pieceKey, int from, int to) {
    final List<String> newPieceKeys = List<String>.from(_boardState.pieceKeys);
    newPieceKeys[from] = "";
    newPieceKeys[to] = pieceKey;
    PieceModel newPieceModel = _boardState.pieceList[pieceKey]!.copyWith(
      index: to,
    );

    _boardState = _boardState.copyWith(
      preFrom: from,
      to: to,
      pieceKeys: newPieceKeys,
      pieceList: {..._boardState.pieceList, pieceKey: newPieceModel},
    );
  }

  // Capture a piece at destination square
  void _capturePiece(int to) {
    String pieceKey = _boardState.pieceKeys[to];
    PieceModel newPieceModel = _boardState.pieceList[pieceKey]!.copyWith(
      isCaptured: true,
    );

    _boardState = _boardState.copyWith(
      pieceList: {..._boardState.pieceList, pieceKey: newPieceModel},
    );
    _matchManagerService.updatePieceCaptured(newPieceModel.type);
  }

  // EnPassant
  void _enPasssantCapture() {
    Squares? enPassantSquare = _matchManagerService.matchState.enPassantSquare;
    if (enPassantSquare == null) return;

    int squareIndex = enPassantSquare.index;
    _capturePiece(squareIndex);
    final List<String> newPieceKeys = List<String>.from(_boardState.pieceKeys);
    newPieceKeys[squareIndex] = "";

    _boardState = _boardState.copyWith(pieceKeys: newPieceKeys);
  }

  // Castling
  void _castling(MoveFlags flag) {
    Sides sideToMove = _matchManagerService.matchState.activeSide;
    int rookMoveFrom, rookMoveTo;
    String rookKey;
    if (flag == MoveFlags.kingCastle) {
      rookMoveFrom = sideToMove == Sides.white ? 7 : 63;
      rookMoveTo = sideToMove == Sides.white ? 5 : 61;
    } else {
      rookMoveFrom = sideToMove == Sides.white ? 0 : 56;
      rookMoveTo = sideToMove == Sides.white ? 3 : 59;
    }
    rookKey = _boardState.pieceKeys[rookMoveFrom];
    _movePiece(rookKey, rookMoveFrom, rookMoveTo);
  }

  Future<void> _endTurn(
    PieceTypes movedPiece,
    MoveModel move, {
    PieceTypes capturedPiece = PieceTypes.pieceType_NB,
  }) async {
    _matchManagerService.getAlgebraicNotation(movedPiece, move);
    _matchManagerService.updateHalfMoveClock(movedPiece, move.moveFlag);
    _matchManagerService.updatePieceCaptured(capturedPiece);
    await _matchManagerService.switchSide();

    final checkedKingSquare = _matchManagerService.matchState.isChecking
        ? await _engineBridge.getKingSquare(
            _matchManagerService.matchState.activeSide,
          )
        : null;
    _boardState = _boardState.copyWith(
      activeSide: _matchManagerService.matchState.activeSide,
      checkedKingSquare: checkedKingSquare,
    );

    await _startTurn();
  }

  // <===== End Of Turn Cycle Logic =====>

  // |==================================================|

  // <===== Player Interactions Handling Logic =====>

  void onSquareTapped(int index) {
    if (!_conditionCheck(index)) {
      notifyListeners();
      return;
    }

    int? from = _boardState.from;
    int? to = _boardState.to;
    if (from == null || to == null) return;

    MoveModel move = _moveManager.getMove(from, to);
    _makeMove(move);
  }

  Future<void> _openPromotionDialog() async {
    _boardState = _boardState.copyWith(
      isPromotion: true,
      promoteSquareIndex: _boardState.to,
    );

    notifyListeners();
  }

  Future<void> promotePiece({
    PieceTypes piecePromotedTo = PieceTypes.queen,
  }) async {
    int? squareIndex = _boardState.promoteSquareIndex;
    if (squareIndex == null) return;

    MoveModel move = _moveManager.getPromotionMove(
      squareIndex,
      piecePromotedTo,
    );
    String key = _boardState.pieceKeys[squareIndex];
    PieceModel? pieceToBePromoted = _boardState.pieceList[key];
    if (pieceToBePromoted == null) return;

    PieceModel newPieceModel = pieceToBePromoted.copyWith(
      type: piecePromotedTo,
    );
    _boardState = _boardState.copyWith(
      pieceList: {..._boardState.pieceList, key: newPieceModel},
      isPromotion: false,
    );

    notifyListeners();

    _engineBridge.makeMove(move.index);
    await _endTurn(PieceTypes.pawn, move);
  }
  // <===== End Of User Interaction Logic =====>

  // |==================================================|

  // <===== Chess Bot Behaviors Logic =====>
  Future<void> _startBotBehavior() async {
    MoveModel bestMove = await _engineBridge.getBestMove(6);
    _makeMove(bestMove);
  }

  void _botPromotePiece(int from, PieceTypes? piecePromotedTo) {
    String pieceKey = _boardState.pieceKeys[from];
    PieceModel? pieceToBePromoted = _boardState.pieceList[pieceKey];

    if (pieceToBePromoted == null) return;

    PieceModel newPieceModel = pieceToBePromoted.copyWith(
      type: piecePromotedTo,
    );
    _boardState = _boardState.copyWith(
      pieceList: {..._boardState.pieceList, pieceKey: newPieceModel},
    );
  }
  // <===== End of Chess Bot Behaviors Logic =====>

  // |==================================================|

  // <===== Helper Methods =====>
  bool _conditionCheck(int index) {
    // Checking and gather all necessary information if not any.
    String key = _boardState.pieceKeys[index];

    // If no piece key is selected
    if (_boardState.selectedPieceKey == null) {
      // If the square clicked on has no piece
      if (key == "") return false;

      if (_boardState.pieceList[key]!.color !=
          _matchManagerService.matchState.activeSide) {
        // The piece not belong to current side to move
        return false;
      }
      // Select a piece key
      _selectPiece(index);
      return false;
    } else {
      // If the second clicked square is the same as the first one and not belong to moveList
      if (_boardState.pieceKeys[index] == _boardState.selectedPieceKey ||
          !_boardState.moveList.contains(index)) {
        _deSelectPiece();
        return false;
      }
    }

    _boardState = _boardState.copyWith(to: index);
    return true;
  }

  void _selectPiece(int squareIndex) {
    // Select piece
    _boardState = _boardState.copyWith(
      selectedPieceKey: _boardState.pieceKeys[squareIndex],
      from: squareIndex,
    );

    // Populate moveList
    _getLegalMoves(squareIndex);
  }

  void _deSelectPiece() {
    // Deselect piece and clear moveList
    _boardState = _boardState.copyWith(
      selectedPieceKey: null,
      from: null,
      moveList: [],
    );
  }

  Future<void> _getMoves() async {
    final List<MoveModel> legalMoves = await _engineBridge.getLegalMoves();
    if (legalMoves.isEmpty) {
      _matchManagerService.noLegalMoveToMake();
      return;
    }
    _moveManager.populateMoveMap(legalMoves);
  }

  void _getLegalMoves(int selectedPieceIndex) {
    // Populate moveList with moves based on selected piece index

    _boardState = _boardState.copyWith(
      moveList: _moveManager.getMovesOfPiece(selectedPieceIndex),
    );
  }

  SoundFXs _getSound(MoveFlags f) {
    if (f == MoveFlags.capture || f == MoveFlags.enPassant) {
      return SoundFXs.capturePiece;
    }
    if (f == MoveFlags.kingCastle || f == MoveFlags.queenCastle) {
      return SoundFXs.castling;
    }
    return SoundFXs.movePiece;
  }

  @override
  void dispose() {
    _redoSignalSubscription.cancel();
    _isMatchEndSubscription.cancel();
    super.dispose();
  }
}
