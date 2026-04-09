import 'package:chess_app/core/engine_interface/engine_bridge_interface.dart';

class EngineBridgeStub {
  Future<void> loadFromFEN(String fen) => throw UnimplementedError();
  Future<String> getSideToMove() => throw UnimplementedError();
  Future<List<dynamic>> getLegalMoves() => throw UnimplementedError();
  void makeMove(int moveIndex) => throw UnimplementedError();
  void unMakeMove() => throw UnimplementedError();
  Future<dynamic> getBestMove(int depth) => throw UnimplementedError();
  Future<int> getKingSquare(dynamic kingSide) => throw UnimplementedError();
  Future<bool> isKingInCheck(dynamic kingSide) => throw UnimplementedError();
  Future<bool> isRepetition() => throw UnimplementedError();
  Future<String> disambiguating(dynamic sideToMove, int moveIndex) =>
      throw UnimplementedError();
  void dispose() => throw UnimplementedError();
}

EngineBridgeInterface createEngineBridge() => throw UnimplementedError();
