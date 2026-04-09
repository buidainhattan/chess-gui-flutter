import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';

abstract class EngineBridgeInterface {
  Future<void> loadFromFEN(String fen);
  Future<String> getSideToMove();
  Future<List<MoveModel>> getLegalMoves();
  void makeMove(int moveIndex);
  void unMakeMove();
  Future<MoveModel> getBestMove(int depth);
  Future<int> getKingSquare(Sides kingSide);
  Future<bool> isKingInCheck(Sides kingSide);
  Future<bool> isRepetition();
  Future<String> disambiguating(Sides sideToMove, int moveIndex);
  void dispose();
}
