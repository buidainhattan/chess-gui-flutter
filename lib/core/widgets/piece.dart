import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Piece extends StatelessWidget {
  const Piece({
    super.key,
    required this.piece,
    required this.pieceSize,
    required this.topPosition,
    required this.leftPosition,
  });

  final PieceModel piece;
  final double pieceSize;
  final double topPosition;
  final double leftPosition;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
      top: topPosition,
      left: leftPosition,
      child: IgnorePointer(
        child: SvgPicture.asset(
          "assets/images/chess_pieces/${piece.color.name}/${piece.type.name}.svg",
          width: pieceSize,
          height: pieceSize,
        ),
      ),
    );
  }
}
