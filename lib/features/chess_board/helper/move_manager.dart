import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';

class MoveManager {
  List<MoveModel> _moveList = [];
  final Map<int, MoveModel> _movePromotionList = {};
  final Map<int, Map<int, int>> _moveMap = {};

  void populateMoveMap(List<MoveModel> moveList) {
    _movePromotionList.clear();
    _moveMap.clear();

    _moveList = moveList;
    for (int i = 0; i < moveList.length; i++) {
      MoveModel move = moveList[i];
      MoveFlags flag = move.moveFlag;
      int from = move.from;
      int to = move.to;

      if (flag == MoveFlags.promotion || flag == MoveFlags.promotionCapture) {
        _movePromotionList[to + move.piecePromotedTo.value] ??= move;
      }

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

  MoveModel getPromotionMove(int to, PieceTypes piecePromotedTo) {
    return _movePromotionList[to + piecePromotedTo.value]!;
  }
}
