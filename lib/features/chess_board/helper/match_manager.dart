import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/fen_helper.dart';

class MatchManager {
  bool _bot = false;
  Sides _botSide = Sides.color_NB;

  late Sides _activeColor; // Current active side
  late String _castlingRight; // Castling right
  late Squares? _enPassantTarget; // enpassant target sqsuare
  late int _halfmoveClock;
  late int _fullmoveNumber;

  void initialSet(FENHelper fen) {
    _activeColor = fen.activeColor;
    _castlingRight = fen.castlingAvailability;
    _enPassantTarget = fen.enPassantTarget;
    _halfmoveClock = fen.halfmoveClock;
    _fullmoveNumber = fen.fullmoveNumber;
  }

  void enableBot(Sides botSide) {
    _bot = true;
    _botSide = botSide;
  }

  bool isBotEnabled() {
    return _bot;
  }

  void switchSide() {
    _activeColor = Sides.fromValue(_activeColor.value ^ 1)!;
  }

  bool isBotTurn() {
    return _botSide == _activeColor;
  }

  void setEnPassantTarget(int? index) {
    if (index == null) {
      _enPassantTarget = null;
      return;
    }
    _enPassantTarget = Squares.fromIndex(index);
  }

  Sides getSideToMove() {
    return _activeColor;
  }

  String getCastlingRight() {
    return _castlingRight;
  }

  Squares? getEnPassantTarget() {
    return _enPassantTarget;
  }

  int getHalfMoveClock() {
    return _halfmoveClock;
  }

  int getFullMoveNumber() {
    return _fullmoveNumber;
  }

  void removeEnPassantTarget() {
    _enPassantTarget = null;
  }
}
