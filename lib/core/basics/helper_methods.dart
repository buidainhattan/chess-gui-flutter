import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';

/// Converts structured move data into standard algebraic chess notation using a
/// single flag for move type (capture, castling, etc.).
///
/// Parameters:
/// - pieceMoved: The symbol of the piece (K, Q, R, B, N, or P for Pawn).
/// - targetSquare: The destination square (e.g., 'e4').
/// - moveFlagValue: The integer value from the MoveFlags enum defining the move type.
/// - isChecking: True if the move puts the opponent in check ('+').
/// - isCheckmate: True if the move delivers checkmate ('#').
/// - startFile (optional): The starting file (a-h). Required for pawn captures, used for piece disambiguation.
/// - startRank (optional): The starting rank (1-8). Used for piece disambiguation if files are the same.
/// - promotionPiece (optional): The symbol of the piece promoted to (Q, R, B, N).
String toAlgebraic(
  String pieceMoved,
  MoveModel move, {
  String disambiguation = '',
  bool isChecking = false,
  bool isCheckmate = false,
}) {
  // Convert move data into String
  final String targetSquare = Squares.fromIndex(move.to)!.name;
  final String promotionPiece = move.piecePromotedTo.name;

  // Derive move characteristics from the flag value
  final MoveFlags moveFlag = move.moveFlag;
  final bool isCastling =
      moveFlag == MoveFlags.kingCastle || moveFlag == MoveFlags.queenCastle;
  final bool isPromotion =
      moveFlag == MoveFlags.promotion || moveFlag == MoveFlags.promotionCapture;

  // A move is a capture if the flag is 4 (standard), 5 (en passant), or 12 (promotion capture).
  final bool isCapture =
      moveFlag == MoveFlags.capture ||
      moveFlag == MoveFlags.enPassant ||
      moveFlag == MoveFlags.promotionCapture;

  // Convert inputs to standard symbols/case
  final String piece = pieceMoved.toUpperCase();
  final String promotion = promotionPiece.toUpperCase();

  // 1. Castling has the highest priority and is handled uniquely
  if (isCastling) {
    // King-side (g-file destination) or Queen-side (c-file destination)
    return targetSquare.contains('g') ? 'O-O' : 'O-O-O';
  }

  String notation = '';

  // 2. Piece Symbol and Disambiguation
  if (piece == 'PAWN') {
    if (isCapture) {
      // Pawn captures MUST include the starting file (e.g., exd5)
      final String pawnStartFile = Squares.fromIndex(move.from)!.name;
      notation += '${pawnStartFile[0]}x';
    }
  } else {
    // Standard Piece (K, Q, R, B, N)
    if (piece.toLowerCase() == PieceTypes.knight.name) {
      notation += piece[1];
    } else {
      notation += piece[0];
    }

    // Disambiguation Logic (applies only to non-Pawn, non-King pieces)
    // Append the start file OR start rank if provided.
    if (disambiguation.isNotEmpty) {
      notation += disambiguation;
    }

    // Capture indicator ('x') goes AFTER the piece symbol and optional disambiguation
    if (isCapture) {
      notation += 'x';
    }
  }

  // 3. Target Square
  notation += targetSquare;

  // 4. Promotion
  if (isPromotion && promotion.isNotEmpty) {
    notation += promotion;
  }

  // 5. Check/Checkmate notation is added last
  if (isCheckmate) {
    notation += '#';
  } else if (isChecking) {
    notation += '+';
  }

  return notation;
}
