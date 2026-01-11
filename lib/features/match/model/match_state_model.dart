import 'package:chess_app/core/constants/all_enum.dart';
import 'package:dart_mappable/dart_mappable.dart';
part 'match_state_model.mapper.dart';

@MappableClass()
class MatchState with MatchStateMappable {
  final Sides activeSide; // Current active side
  final String castlingRight; // Castling right
  final Squares? enPassantSquare; // enpassant target sqsuare
  final int halfMoveClock;
  final int fullMoveNumber;
  final Map<Sides, List<PieceTypes>> capturedPieces;
  final bool isChecking;
  final bool isCheckmate;

  MatchState({
    required this.activeSide,
    required this.castlingRight,
    this.enPassantSquare,
    this.halfMoveClock = 0,
    this.fullMoveNumber = 0,
    Map<Sides, List<PieceTypes>>? capturedPieces,
    this.isChecking = false,
    this.isCheckmate = false,
  }) : capturedPieces = capturedPieces ?? {Sides.black: [], Sides.white: []};
}
