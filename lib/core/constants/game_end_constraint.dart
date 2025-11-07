// The halfmove count (ply) that must be reached for a player to CLAIM a draw.
// 50 full moves * 2 halfmoves/move = 100
import 'package:chess_app/core/constants/all_enum.dart';

const int claimableDrawHalfMoves = 100;

// The halfmove count (ply) that is an AUTOMATIC draw by FIDE rules.
// 75 full moves * 2 halfmoves/move = 150
const int automaticDrawHalfMoves = 150;

// The number of times an EXACT position must repeat for a player to CLAIM a draw.
const int threefoldRepetitionCount = 3;

// A simple structure to hold the pieces that result in an automatic draw (excluding pawns).
// The full implementation checks *both* sides, but these are the critical pieces.
const List<Set<PieceTypes>> insufficientMaterialSets = [
  // King vs King
  {PieceTypes.king}, 

  // King vs King + Knight
  {PieceTypes.king, PieceTypes.knight}, 

  // King vs King + Bishop
  {PieceTypes.king, PieceTypes.bishop}, 
  
  // K + B vs K + B where Bishops are on the same color squares (Requires runtime check)
  // K + N vs K + B (Often treated as draw, but technically not always)
];