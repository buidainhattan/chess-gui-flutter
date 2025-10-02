import 'package:chess_app/features/chess_board/model/move_model.dart';

class MoveService {
  List<MoveModel> _moveList = [];
  final Map<int, Map<int, int>> _moveMap = {};
  
  void populateMoveMap(List<MoveModel> moveList) {
    _moveList.clear();
    _moveMap.clear();

    _moveList = moveList;
    for (int i = 0; i < moveList.length; i++)
    {
      MoveModel move = moveList[i];
      int from = move.from;
      int to = move.to;

      _moveMap[from] ??= {};
      _moveMap[from]?[to] ??= i;
    }
  }

  List<int> getMovesOfPiece(int index) {
    if (_moveMap[index] == null) {
      return List.empty();
    }

    return _moveMap[index]!.keys.toList();
  }

  MoveModel getMove(int from, int to) {
    int index = _moveMap[from]![to]!;
    return _moveList[index];
  }
}