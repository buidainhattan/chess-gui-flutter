import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/controllers/audio_controller.dart';
import 'package:chess_app/core/engine_bridge.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:chess_app/features/chess_board/service/fen_service.dart';
import 'package:chess_app/features/chess_board/service/match_manager_service.dart';
import 'package:chess_app/features/chess_board/service/move_service.dart';
import 'package:flutter/material.dart';

class ChessBoardViewmodel extends ChangeNotifier {
  late final FENService _fenService;
  final MoveService _moveService = MoveService();
  final AudioController _audioController = AudioController();
  final EngineBridge _engineBridge = EngineBridge();
  final MatchManagerService _matchManagerService = MatchManagerService();

  // <--- GUI control variables --->
  // A bool value to control whether to display a promotion dialog or not
  bool isPromotion = false;
  // List to hold address (key) of current piece on that square
  final List<String> pieceKeys = List.filled(64, "", growable: false);
  // Map to hold current index value of each piece
  final Map<String, int> pieceIndices = {};
  // Moveable square indices of selected piece
  final List<int> moveList = [];
  String? _selectedPieceKey; // Store current selected piece key
  int? from; // The index which selected piece is on
  int? to; // The index which seletected piece is about to move to
  int? promoteIndex;

  // A map to access piece properties through key
  late final Map<String, PieceModel> pieceList;

  ChessBoardViewmodel() {
    _parseFEN();
    initializeChessBoard();
  }

  void initializeChessBoard() {
    for (var piece in pieceList.values) {
      _addToPieceCoordKeys(piece.index, piece.key);
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
    return _matchManagerService.getSideToMove();
  }

  void openPromotionDialog() {
    isPromotion = true;
    promoteIndex = to;

    notifyListeners();
  }

  void promotePiece(PieceTypes? piecePromotedTo) {


    isPromotion = false;
    notifyListeners();
  }

  void _parseFEN({String fen = FENService.startFEN}) {
    _fenService = stringFENParser(fen);
    _engineBridge.loadFromFEN(fen);
    _update();
    _matchManagerService.initialSet(_fenService);
    pieceList = _fenService.pieceList;
  }

  void _addToPieceCoordKeys(int squareIndex, String key) {
    pieceKeys[squareIndex] = key;
    pieceIndices[key] = squareIndex;
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
          _matchManagerService.getSideToMove()) {
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

  void _update([final int? moveIndex]) {
    if (moveIndex != null) {
      _matchManagerService.switchSide();
      _engineBridge.makeMove(moveIndex);
    }
    final List<MoveModel> legalMoves = _engineBridge.getLegalMoves();
    _moveService.populateMoveMap(legalMoves);
  }

  void _makeMove() {
    // Make a move after all conditions are met
    if (_selectedPieceKey == null || from == null || to == null) return;

    MoveModel move = _moveService.getMove(from!, to!);
    MoveFlags flag = move.moveFlag;
    switch (flag) {
      case MoveFlags.doublePawnPush:
        _matchManagerService.setEnPassantTarget(to!);
      case MoveFlags.promotion || MoveFlags.promotionCapture:
        openPromotionDialog();
        if (flag == MoveFlags.promotionCapture) continue capture;
      capture:
      case MoveFlags.capture:
        _capturePiece(to!);
      case MoveFlags.enPassant:
        _enPasssantCapture();
      case MoveFlags.kingCastle:
        _castling(flag);
      case MoveFlags.queenCastle:
        _castling(flag);
      default:
        _matchManagerService.setEnPassantTarget(null);
    }

    _movePiece(_selectedPieceKey!, from!, to!);

    _update(move.index);
    _deSelectPiece();

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

    pieceIndices[pieceKey] = to;
    pieceKeys[from] = "";
    pieceKeys[to] = pieceKey;
  }

  void _capturePiece(int to) {
    // Capture piece if there's any at move to square

    String key = pieceKeys[to];
    pieceIndices.remove(key);
  }

  void _enPasssantCapture() {
    // EnPassant Capture if eligible

    Squares? enPassantTargetSquare = _matchManagerService.getEnPassantTarget();
    int index = enPassantTargetSquare!.index;
    String key = pieceKeys[index];
    pieceIndices.remove(key);
    pieceKeys[index] = "";
  }

  void _castling(MoveFlags flag) {
    // Handle king castling for view

    Sides sideToMove = _matchManagerService.getSideToMove();
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
    moveList.addAll(_moveService.getMovesOfPiece(selectedPieceIndex));
  }
}
