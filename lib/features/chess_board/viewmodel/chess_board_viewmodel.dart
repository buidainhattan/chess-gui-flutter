import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/controllers/audio_controller.dart';
import 'package:chess_app/core/engine_bridge.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:chess_app/features/chess_board/helper/fen_helper.dart';
import 'package:chess_app/features/chess_board/helper/match_manager.dart';
import 'package:chess_app/features/chess_board/helper/move_manager.dart';
import 'package:flutter/material.dart';

class ChessBoardViewmodel extends ChangeNotifier {
  late final FENHelper _fenHelper;
  final MoveManager _moveManager = MoveManager();
  final AudioController _audioController = AudioController();
  final EngineBridge _engineBridge = EngineBridge();
  final MatchManager _matchManager = MatchManager();

  // <--- GUI control variables --->
  // A bool value to control whether to display a promotion dialog or not
  bool isPromotion = false;
  // List to hold address (key) of current piece on that square
  final List<String> pieceKeys = List.filled(64, "", growable: false);
  // A map to access piece properties through key
  late final Map<String, PieceModel> _pieceList;
  Map<String, PieceModel> get pieceList => _pieceList;
  // Moveable square indices of selected piece
  final List<int> moveList = [];
  String? _selectedPieceKey; // Store current selected piece key
  int? from; // The index which selected piece is on
  int? to; // The index which seletected piece is about to move to
  int? promoteIndex;

  ChessBoardViewmodel() {
    _parseFEN();
    initializeChessBoard();
  }

  void initializeChessBoard() {
    for (var piece in _pieceList.values) {
      _addToPieceCoordKeys(piece.index, piece.key);
    }
  }

  void toggleBot(bool toggleBot, Sides botSide) {
    if (toggleBot) {
      _engineBridge.toggleBot(botSide);
      _matchManager.enableBot(botSide);
    }
  }

  void onSquareTapped(int index) {
    if (!_conditionCheck(index)) {
      notifyListeners();
      return;
    } else {
      to = index;
    }

    _makeMove();
    notifyListeners();
  }

  Sides getCurrentSide() {
    return _matchManager.getSideToMove();
  }

  void openPromotionDialog() {
    isPromotion = true;
    promoteIndex = to;

    notifyListeners();
  }

  void promotePiece(PieceTypes piecePromotedTo) {
    MoveModel move = _moveManager.getPromotionMove(
      promoteIndex!,
      piecePromotedTo,
    );
    String key = pieceKeys[promoteIndex!];
    PieceModel pieceWithNewAttribute = _pieceList[key]!.copyWith(
      type: piecePromotedTo,
    );
    _pieceList[key] = pieceWithNewAttribute;
    isPromotion = false;
    _update(move.index);
    notifyListeners();
  }

  void _parseFEN({String fen = FENHelper.startFEN}) {
    _fenHelper = stringFENParser(fen);
    _engineBridge.loadFromFEN(fen);
    _update();
    _matchManager.initialSet(_fenHelper);
    _pieceList = _fenHelper.pieceList;
  }

  void _addToPieceCoordKeys(int squareIndex, String key) {
    pieceKeys[squareIndex] = key;
  }

  bool _conditionCheck(int index) {
    // Checking and gather all necessary information if not any.

    String key = pieceKeys[index];
    // If no piece key is selected
    if (_selectedPieceKey == null) {
      // If the square clicked on has no piece
      if (key == "") {
        return false;
      } else if (_pieceList[key]!.color != _matchManager.getSideToMove()) {
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

  void _update([final int? moveIndex]) async {
    if (moveIndex != null) {
      _matchManager.switchSide();
      _engineBridge.makeMove(moveIndex);
      if (_matchManager.isBotEnabled()) {
        if (_matchManager.isBotTurn()) {
          _botMakeMove();
          return;
        }
      }
    }
    final List<MoveModel> legalMoves = await _engineBridge.getLegalMoves();
    _moveManager.populateMoveMap(legalMoves);
  }

  void _makeMove([MoveModel? botMove]) {
    // Make a move after all conditions are met

    MoveModel move;
    if (botMove == null) {
      move = _moveManager.getMove(from!, to!);
    } else {
      move = botMove;
    }
    int moveFrom = move.from;
    String pieceToMoveKey = pieceKeys[moveFrom];
    int moveTo = move.to;
    MoveFlags flag = move.moveFlag;
    switch (flag) {
      case MoveFlags.doublePawnPush:
        _matchManager.setEnPassantTarget(moveTo);
      case MoveFlags.promotion || MoveFlags.promotionCapture:
        openPromotionDialog();
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
        _matchManager.setEnPassantTarget(null);
    }

    _movePiece(pieceToMoveKey, moveFrom, moveTo);
    _deSelectPiece();

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
    PieceModel pieceWithNewAttribute = _pieceList[pieceKey]!.copyWith(
      index: to,
    );
    _pieceList[pieceKey] = pieceWithNewAttribute;
  }

  void _capturePiece(int to) {
    // Capture piece if there's any at move to square

    String key = pieceKeys[to];
    PieceModel pieceWithNewAttribute = _pieceList[key]!.copyWith(
      isCaptured: true,
    );
    _pieceList[key] = pieceWithNewAttribute;
  }

  void _enPasssantCapture() {
    // EnPassant Capture if eligible

    Squares? enPassantTargetSquare = _matchManager.getEnPassantTarget();
    int index = enPassantTargetSquare!.index;
    _capturePiece(index);
    pieceKeys[index] = "";
  }

  void _castling(MoveFlags flag) {
    // Handle king castling for view

    Sides sideToMove = _matchManager.getSideToMove();
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
    from = null;
    moveList.clear();
  }

  void _getLegalMoves(int selectedPieceIndex) {
    // Populate moveList with moves based on selected piece index

    moveList.clear();
    moveList.addAll(_moveManager.getMovesOfPiece(selectedPieceIndex));
  }

  void _botMakeMove() async {
    MoveModel bestMove = await _engineBridge.getBestMove(5);
    _makeMove(bestMove);
    notifyListeners();
  }
}
