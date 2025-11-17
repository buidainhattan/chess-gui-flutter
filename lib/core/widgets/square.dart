import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/viewmodel/chess_board_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.chessBoardViewmodel,
    required this.tileSize,
    required this.index,
    required this.squareColor,
  });

  final ChessBoardViewmodel chessBoardViewmodel;
  final double tileSize;
  final int index;
  final Sides squareColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        chessBoardViewmodel.onSquareTapped(index);
      },
      child: SizedBox(
        width: tileSize,
        height: tileSize,
        child: Stack(
          children: [
            Selector<ChessBoardViewmodel, bool>(
              selector: (context, viewmodel) =>
                  viewmodel.preFrom == index ||
                  viewmodel.from == index ||
                  viewmodel.to == index,
              builder: (context, isSelected, child) {
                final String assetName = isSelected
                    ? "assets/images/tiles/tile_${squareColor.name}_selected.svg"
                    : "assets/images/tiles/tile_${squareColor.name}.svg";

                return SvgPicture.asset(
                  assetName,
                  width: tileSize,
                  height: tileSize,
                );
              },
            ),
            Selector<
              ChessBoardViewmodel,
              ({bool isMoveableTo, bool isCapture})
            >(
              selector: (context, viewmodel) {
                final bool isMoveableTo = viewmodel.moveList.contains(index);
                final bool isCapture = viewmodel.pieceKeys[index].isNotEmpty;

                return (isMoveableTo: isMoveableTo, isCapture: isCapture);
              },
              builder: (context, state, child) {
                if (!state.isMoveableTo) {
                  return const SizedBox.shrink();
                }

                double hintPosition, hintSize;
                String hintName;
                if (state.isCapture) {
                  hintPosition = 0;
                  hintSize = tileSize;
                  hintName = "assets/images/tiles/tile_hint_capture.svg";
                } else {
                  hintPosition = (tileSize / 3);
                  hintSize = (tileSize / 3);
                  hintName = "assets/images/tiles/tile_hint_move.svg";
                }

                return Positioned(
                  top: hintPosition,
                  left: hintPosition,
                  child: SvgPicture.asset(
                    hintName,
                    width: hintSize,
                    height: hintSize,
                  ),
                );
              },
            ),
            Selector<ChessBoardViewmodel, bool>(
              selector: (context, viewmodel) {
                if (viewmodel.checkedKingSquare != null &&
                    viewmodel.checkedKingSquare == index) {
                  return true;
                }
                return false;
              },
              builder: (context, isChecked, child) {
                if (!isChecked) {
                  return SizedBox.shrink();
                }
                final String hintName = "assets/images/tiles/tile_hint_checking.svg";

                return SvgPicture.asset(
                  hintName,
                  width: tileSize,
                  height: tileSize,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
