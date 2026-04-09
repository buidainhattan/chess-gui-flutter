import 'package:chess_app/core/constants/all_enum.dart';

class MoveModel {
  final int from, to, index;
  final PieceTypes? piecePromotedTo;
  final MoveFlags moveFlag;

  MoveModel({
    required this.from,
    required this.to,
    required this.index,
    this.piecePromotedTo,
    required this.moveFlag,
  });
}
