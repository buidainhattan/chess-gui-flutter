import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/theme.dart';
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final BoardTheme boardTheme = BoardThemes.classic;

    final Color fillColor;

    if (squareColor == Sides.white) {
      fillColor = boardTheme.lightSquare;
    } else {
      fillColor = boardTheme.darkSquare;
    }

    final Color hintColor = boardTheme.selectedOverlay(colorScheme);

    return GestureDetector(
      onTap: () {
        chessBoardViewmodel.onSquareTapped(index);
      },
      child: SizedBox(
        width: tileSize,
        height: tileSize,
        child: Stack(
          children: [
            Container(decoration: BoxDecoration(color: fillColor)),
            Selector<ChessBoardViewmodel, bool>(
              selector: (context, viewmodel) =>
                  viewmodel.boardState.preFrom == index ||
                  viewmodel.boardState.from == index ||
                  viewmodel.boardState.to == index,
              builder: (context, isSelected, child) {
                if (isSelected) {
                  return Container(decoration: BoxDecoration(color: hintColor));
                }
                return SizedBox.shrink();
              },
            ),
            Selector<
              ChessBoardViewmodel,
              ({bool isMoveableTo, bool isCapture})
            >(
              selector: (context, viewmodel) {
                final bool isMoveableTo = viewmodel.boardState.moveList
                    .contains(index);
                final bool isCapture =
                    viewmodel.boardState.pieceKeys[index].isNotEmpty;

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
                    colorFilter: ColorFilter.mode(hintColor, BlendMode.srcIn),
                  ),
                );
              },
            ),
            Selector<ChessBoardViewmodel, bool>(
              selector: (context, viewmodel) {
                if (viewmodel.boardState.checkedKingSquare != null &&
                    viewmodel.boardState.checkedKingSquare == index) {
                  return true;
                }
                return false;
              },
              builder: (context, isChecked, child) {
                if (!isChecked) {
                  return SizedBox.shrink();
                }
                final String hintName =
                    "assets/images/tiles/tile_hint_checking.svg";

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
