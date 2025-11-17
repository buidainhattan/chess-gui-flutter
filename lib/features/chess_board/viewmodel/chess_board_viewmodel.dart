import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/controllers/audio_controller.dart';
import 'package:chess_app/core/engine_bridge.dart';
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

  // <--- GUI control variables --->
  // A bool value to control whether to display a promotion dialog or not
  bool isPromotion = false;
  // List to hold address (key) of current piece on that square
  final List<String> pieceKeys = List.filled(64, "", growable: false);
  Sides get activeSide => _matchManagerService.matchState.activeSide;
  // A map to access piece properties through key
  late final Map<String, PieceModel> pieceList;
  // Moveable square indices of selected piece
  final List<int> moveList = [];
  String? _selectedPieceKey; // Store current selected piece key
  int? preFrom; // The index which selected piece a turn before from
  int? from; // The index which selected piece is on
  int? to; // The index which seletected piece is about to move to
  int? checkedKingSquare;
  int? _promoteIndex;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ChessBoardViewmodel(this._matchManagerService);

  Future<void> initializeChessBoard() async {
    if (_isInitialized) return;
    await _parseFEN();
    for (var piece in pieceList.values) {
      pieceKeys[piece.index] = piece.key;
    }
    _isInitialized = true;
  }

  Future<void> _parseFEN() async {
    String fen = _matchManagerService.fen;
    await _engineBridge.loadFromFEN(fen);
    await _getMoves();
    pieceList = _matchManagerService.fenHelper.pieceList;
  }

  void toggleBot(bool toggleBot, Sides botSide) {
    if (toggleBot) {
      _matchManagerService.botEnabled = true;
    }
  }

  void onSquareTapped(int index) {
    if (!_conditionCheck(index)) {
      notifyListeners();
      return;
    } else {
      to = index;
    }

    _playerMakeMove();
  }

  void promotePiece({
    PieceTypes piecePromotedTo = PieceTypes.queen,
    MoveModel? botPromoteMove,
  }) {
    MoveModel move;
    if (botPromoteMove == null) {
      move = _moveManager.getPromotionMove(_promoteIndex!, piecePromotedTo);
    } else {
      move = botPromoteMove;
    }
    String key = pieceKeys[_promoteIndex!];
    PieceModel pieceWithNewAttribute = pieceList[key]!.copyWith(
      type: piecePromotedTo,
    );
    pieceList[key] = pieceWithNewAttribute;
    isPromotion = false;
    _update(move.index);
    notifyListeners();
  }

  bool _conditionCheck(int index) {
    // Checking and gather all necessary information if not any.

    String key = pieceKeys[index];
    // If no piece key is selected
    if (_selectedPieceKey == null) {
      // If the square clicked on has no piece
      if (key == "") {
        return false;
      } else if (pieceList[key]!.color !=
          _matchManagerService.matchState.activeSide) {
        // The piece not belong to current side to move
        return false;
      }
      // Select a piece key
      _selectPiece(index);
      return false;
    } else {
      // If the second clicked square is the same as the first one
      if (pieceKeys[index] == _selectedPieceKey) {
        _deSelectPiece();
        return false;
      } else if (!moveList.contains(index)) {
        // If the second clicked square is not belong to moveList
        _deSelectPiece();
        return false;
      }
    }
    return true;
  }

  void _update(int moveIndex) async {
    _engineBridge.makeMove(moveIndex);
    await _matchManagerService.switchSide();
    if (_matchManagerService.matchState.isChecking) {
      checkedKingSquare = await _engineBridge.getKingSquare(
        _matchManagerService.matchState.activeSide,
      );
    } else {
      checkedKingSquare = null;
    }
    if (_matchManagerService.botEnabled) {
      if (_matchManagerService.isPlayerTwoTurn()) {
        await _botMakeMove();
        return;
      }
    }
    await _getMoves();
  }

  Future<void> _getMoves() async {
    final List<MoveModel> legalMoves = await _engineBridge.getLegalMoves();
    if (legalMoves.isEmpty) {
      _matchManagerService.noLegalMoveToMake();
    }
    _moveManager.populateMoveMap(legalMoves);
  }

  void _playerMakeMove() {
    MoveModel move = _moveManager.getMove(from!, to!);
    _makeMove(move);
    notifyListeners();
  }

  Future<void> _botMakeMove() async {
    MoveModel bestMove = await _engineBridge.getBestMove(5);
    _makeMove(bestMove);
    notifyListeners();
  }

  void _makeMove(MoveModel move, [bool isBotMakeMove = false]) {
    // Make a move after all conditions are met

    int moveFrom = move.from;
    String pieceToMoveKey = pieceKeys[moveFrom];
    int moveTo = move.to;
    MoveFlags flag = move.moveFlag;
    _matchManagerService.updateHalfMoveClock(
      pieceList[pieceToMoveKey]!.type,
      flag,
    );
    switch (flag) {
      case MoveFlags.doublePawnPush:
        _matchManagerService.setEnPassantTarget(moveTo);
      case (MoveFlags.promotion || MoveFlags.promotionCapture):
        if (isBotMakeMove) {
          promotePiece(botPromoteMove: move);
        } else {
          _openPromotionDialog();
        }
        if (flag == MoveFlags.promotionCapture) continue capture;
      capture:
      case MoveFlags.capture:
        _capturePiece(moveTo);
      case MoveFlags.enPassant:
        _enPasssantCapture();
      case MoveFlags.kingCastle:
        _castling(flag);
      case MoveFlags.queenCastle:
        _castling(flag);
      default:
        _matchManagerService.setEnPassantTarget(null);
    }

    _movePiece(pieceToMoveKey, moveFrom, moveTo);
    _deSelectPiece();
    _matchManagerService.getAlgebraicNotation(
      pieceList[pieceToMoveKey]!.type,
      move,
    );

    if (flag != MoveFlags.promotion && flag != MoveFlags.promotionCapture) {
      _update(move.index);
    }

    // Handle sound
    switch (flag) {
      case MoveFlags.capture || MoveFlags.enPassant:
        _audioController.playSoundEffect(SoundFXs.capturePiece);
      case MoveFlags.kingCastle || MoveFlags.queenCastle:
        _audioController.playSoundEffect(SoundFXs.castling);
      default:
        _audioController.playSoundEffect(SoundFXs.movePiece);
    }
  }

  void _movePiece(String pieceKey, int from, int to) {
    // Move a piece from from-to index

    pieceKeys[from] = "";
    pieceKeys[to] = pieceKey;
    PieceModel pieceWithNewAttribute = pieceList[pieceKey]!.copyWith(index: to);
    pieceList[pieceKey] = pieceWithNewAttribute;
  }

  void _capturePiece(int to) {
    // Capture piece if there's any at move to square

    String key = pieceKeys[to];
    PieceModel pieceWithNewAttribute = pieceList[key]!.copyWith(
      isCaptured: true,
    );
    pieceList[key] = pieceWithNewAttribute;
    _matchManagerService.updatePieceCaptured(pieceWithNewAttribute.type);
  }

  void _enPasssantCapture() {
    // EnPassant Capture if eligible

    Squares? enPassantTargetSquare =
        _matchManagerService.matchState.enPassantTarget;
    int index = enPassantTargetSquare!.index;
    _capturePiece(index);
    pieceKeys[index] = "";
  }

  void _castling(MoveFlags flag) {
    // Handle king castling for view

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
    rookKey = pieceKeys[rookMoveFrom];
    _movePiece(rookKey, rookMoveFrom, rookMoveTo);
  }

  void _openPromotionDialog() {
    isPromotion = true;
    _promoteIndex = to;

    notifyListeners();
  }

  void _selectPiece(int squareIndex) {
    // Select piece

    _selectedPieceKey = pieceKeys[squareIndex];
    from = squareIndex;
    // Populate moveList
    _getLegalMoves(squareIndex);
  }

  void _deSelectPiece() {
    // Deselect piece and clear moveList

    _selectedPieceKey = null;
    preFrom = from;
    moveList.clear();
  }

  void _getLegalMoves(int selectedPieceIndex) {
    // Populate moveList with moves based on selected piece index

    moveList.clear();
    moveList.addAll(_moveManager.getMovesOfPiece(selectedPieceIndex));
  }
}
