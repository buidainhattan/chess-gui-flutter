import 'package:chess_app/core/constants/all_enum.dart';

class PieceModel {
  final String key;
  final int index;
  final Sides color;
  final PieceTypes type;
  final bool isCaptured;

  const PieceModel({
    required this.key,
    required this.index,
    required this.color,
    required this.type,
    this.isCaptured = false,
  });

  PieceModel copyWith({int? index, PieceTypes? type, bool? isCaptured}) {
    return PieceModel(
      key: key,
      index: index ?? this.index,
      color: color,
      type: type ?? this.type,
      isCaptured: isCaptured ?? this.isCaptured,
    );
  }
}
