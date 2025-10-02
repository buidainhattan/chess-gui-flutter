import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/constants/c_style_struct.dart';

class MoveModel {
  final int from, to, index;
  final PieceTypes piecePromotedTo;
  final MoveFlags moveFlag;
  MoveModel.fromFFI(MoveData data)
    : from = data.fromSquare,
      to = data.toSquare,
      piecePromotedTo = PieceTypes.fromValue(data.piecePromotedTo)!,
      moveFlag = MoveFlags.fromValue(data.moveType)!,
      index = data.moveIndex;
}
