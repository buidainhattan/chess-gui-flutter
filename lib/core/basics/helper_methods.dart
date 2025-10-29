import 'package:chess_app/core/constants/all_enum.dart';

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
  String targetSquare,
  int moveFlagValue,
  bool isChecking,
  bool isCheckmate, {
  String startFile = '',
  String startRank = '',
  String promotionPiece = '',
}) {
  // Derive move characteristics from the flag value
  final isCastling = moveFlagValue == MoveFlags.kingCastle.value || moveFlagValue == MoveFlags.queenCastle.value;
  final isEnPassant = moveFlagValue == MoveFlags.enPassant.value;
  final isPromotion = moveFlagValue == MoveFlags.promotion.value || moveFlagValue == MoveFlags.promotionCapture.value;

  // A move is a capture if the flag is 4 (standard), 5 (en passant), or 12 (promotion capture).
  final isCapture = moveFlagValue == MoveFlags.capture.value ||
                    moveFlagValue == MoveFlags.enPassant.value ||
                    moveFlagValue == MoveFlags.promotionCapture.value;

  // Convert inputs to standard symbols/case
  final piece = pieceMoved.toUpperCase();
  final target = targetSquare.toLowerCase();
  final file = startFile.toLowerCase();
  final rank = startRank.toLowerCase();
  final promotion = promotionPiece.toUpperCase();

  // 1. Castling has the highest priority and is handled uniquely
  if (isCastling) {
    // King-side (g-file destination) or Queen-side (c-file destination)
    return target.contains('g') ? 'O-O' : 'O-O-O';
  }

  String notation = '';

  // 2. Piece Symbol and Disambiguation
  if (piece == 'P' || piece == 'PAWN') {
    if (isCapture) {
      // Pawn captures MUST include the starting file (e.g., exd5)
      notation += file;
      notation += 'x';
    }
  } else {
    // Standard Piece (K, Q, R, B, N)
    notation += piece;

    // Disambiguation Logic (applies only to non-Pawn, non-King pieces)
    // Append the start file OR start rank if provided.
    if (file.isNotEmpty) {
      notation += file;
    } else if (rank.isNotEmpty) {
      notation += rank;
    }

    // Capture indicator ('x') goes AFTER the piece symbol and optional disambiguation
    if (isCapture) {
      notation += 'x';
    }
  }

  // 3. Target Square
  notation += target;

  // 4. Promotion
  if (isPromotion && promotion.isNotEmpty) {
    notation += '=';
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