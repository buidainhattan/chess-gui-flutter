import 'package:chess_app/core/constants/all_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromotionDialog extends StatelessWidget {
  final Sides sideToMove;

  static Future<PieceTypes?> show(BuildContext context, Sides sideToMove) {
    return showGeneralDialog<PieceTypes>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Dismiss",
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.center,
          child: PromotionDialog._(sideToMove: sideToMove),
        );
      },
    );
  }

  const PromotionDialog._({required this.sideToMove});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(child: const Text('Choose your promotion piece')),
      children: <Widget>[
        Row(
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, PieceTypes.knight);
              },
              child: SvgPicture.asset(
                "assets/images/chess_pieces/${sideToMove.name}/knight.svg",
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, PieceTypes.bishop);
              },
              child: SvgPicture.asset(
                "assets/images/chess_pieces/${sideToMove.name}/bishop.svg",
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, PieceTypes.rook);
              },
              child: SvgPicture.asset(
                "assets/images/chess_pieces/${sideToMove.name}/rook.svg",
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, PieceTypes.queen);
              },
              child: SvgPicture.asset(
                "assets/images/chess_pieces/${sideToMove.name}/queen.svg",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
