import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';

/// A class to hold the parsed information from a FEN string.
class FENService {
  static const startFEN =
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

  final Map<String, PieceModel> pieceList;
  final Sides activeColor;
  final String castlingAvailability;
  final Squares? enPassantTarget;
  final int halfmoveClock;
  final int fullmoveNumber;

  FENService({
    required this.pieceList,
    required this.activeColor,
    required this.castlingAvailability,
    required this.enPassantTarget,
    required this.halfmoveClock,
    required this.fullmoveNumber,
  });

  @override
  String toString() {
    return '''
FEN String Breakdown:
----------------------
Board Positions:
$pieceList
Active Color: ${activeColor.toString().split('.')[1]}
Castling Availability: $castlingAvailability
En Passant Target: $enPassantTarget
Halfmove Clock: $halfmoveClock
Fullmove Number: $fullmoveNumber
''';
  }
}

/// Parses a FEN (Forsyth-Edwards Notation) string and returns a [FENService] object.
///
/// Throws a [FormatException] if the FEN string is invalid.
FENService stringFENParser(String fenString) {
  final parts = fenString.split(' ');

  if (parts.length != 6) {
    throw FormatException(
      'Invalid FEN string. Expected 6 parts, but got ${parts.length}',
    );
  }

  // Part 1: Piece placement
  final boardPositionString = parts[0];
  final boardMap = _parseBoardPosition(boardPositionString);

  // Part 2: Active color
  final activeColorString = parts[1];
  final activeColor = _getPieceColor(activeColorString);

  // Part 3: Castling availability
  final castlingAvailability = parts[2];

  // Part 4: En passant target square
  final enPassantTarget = Squares.fromNotation(parts[3]);

  // Part 5: Halfmove clock
  final halfmoveClock = int.tryParse(parts[4]);
  if (halfmoveClock == null) {
    throw FormatException('Invalid halfmove clock in FEN string: ${parts[4]}');
  }

  // Part 6: Fullmove number
  final fullmoveNumber = int.tryParse(parts[5]);
  if (fullmoveNumber == null) {
    throw FormatException('Invalid fullmove number in FEN string: ${parts[5]}');
  }

  return FENService(
    pieceList: boardMap,
    activeColor: activeColor,
    castlingAvailability: castlingAvailability,
    enPassantTarget: enPassantTarget,
    halfmoveClock: halfmoveClock,
    fullmoveNumber: fullmoveNumber,
  );
}

/// A private helper function to parse the board position string into a Map.
Map<String, PieceModel> _parseBoardPosition(String boardFen) {
  final Map<String, PieceModel> board = {};
  final ranks = boardFen.split('/');
  final reversedRanks = ranks.reversed;
  int squareIndex = 0;
  int pieceCount = 0;

  if (ranks.length != 8) {
    throw FormatException(
      'Invalid board position in FEN string. Expected 8 ranks.',
    );
  }

  for (final rank in reversedRanks) {
    for (final char in rank.runes) {
      final String charStr = String.fromCharCode(char);

      if (charStr.contains(RegExp(r'[1-8]'))) {
        final int emptySquares = int.parse(charStr);
        squareIndex += emptySquares;
      } else if (charStr.contains(RegExp(r'[rnbqkpRNBQKP]'))) {
        final Sides color = charStr == charStr.toUpperCase()
            ? Sides.white
            : Sides.black;
        final PieceTypes type = _getPieceType(charStr.toLowerCase());

        final piece = PieceModel(
          key: '${type.toString().split('.')[1]}_$pieceCount',
          index: squareIndex,
          color: color,
          type: type,
        );
        board[piece.key] = piece;
        squareIndex += 1;
        pieceCount += 1;
      } else {
        throw FormatException(
          'Invalid character in FEN board position: $charStr',
        );
      }
    }
    // Check if the rank has exactly 8 squares
    if (squareIndex % 8 != 0) {
      throw FormatException(
        'Invalid rank in FEN string. Each rank must have 8 squares.',
      );
    }
  }
  return board;
}

/// Helper function to map a character to a PieceType.
PieceTypes _getPieceType(String char) {
  switch (char) {
    case 'p':
      return PieceTypes.pawn;
    case 'n':
      return PieceTypes.knight;
    case 'b':
      return PieceTypes.bishop;
    case 'r':
      return PieceTypes.rook;
    case 'q':
      return PieceTypes.queen;
    case 'k':
      return PieceTypes.king;
    default:
      throw FormatException('Unknown piece type character: $char');
  }
}

/// Helper function to map a character to a PieceColor.
Sides _getPieceColor(String char) {
  switch (char) {
    case 'w':
      return Sides.white;
    case 'b':
      return Sides.black;
    default:
      throw FormatException('Invalid active color character: $char');
  }
}
