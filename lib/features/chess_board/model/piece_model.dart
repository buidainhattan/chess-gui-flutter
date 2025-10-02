import 'package:chess_app/core/constants/all_enum.dart';

class PieceModel {
  const PieceModel({
    required this.key,
    required this.index,
    required this.color,
    required this.type,
  });

  final String key;
  final int index;
  final Sides color;
  final PieceTypes type;
}
