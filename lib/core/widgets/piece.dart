import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Piece extends StatelessWidget {
  const Piece({super.key, required this.piece, required this.pieceSize});

  final PieceModel piece;
  final double pieceSize;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SvgPicture.asset(
        "assets/images/chess_pieces/${piece.color.name}/${piece.type.name}.svg",
        width: pieceSize,
        height: pieceSize,
      ),
    );
  }
}
