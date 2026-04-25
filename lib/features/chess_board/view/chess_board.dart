import 'dart:math' as math;

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:chess_app/features/chess_board/view/promotion.dart';
import 'package:chess_app/features/chess_board/viewmodel/chess_board_viewmodel.dart';
import 'package:chess_app/core/widgets/piece.dart';
import 'package:chess_app/core/widgets/square.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final ChessBoardViewmodel chessBoardViewmodel = context
        .read<ChessBoardViewmodel>();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final bool isPlayerOneWhite =
        chessBoardViewmodel.playerOneSide == Sides.white;

    const List<String> files = ["a", "b", "c", "d", "e", "f", "g", "h"];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double size = math.min(
          constraints.maxHeight,
          constraints.maxWidth,
        );

        final double tileSize, pieceSize;
        tileSize = size * 46 / 370;
        pieceSize = tileSize * 0.75;

        // final double rankOffset, fileOffset;
        // rankOffset = fileOffset = tileSize / 2;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Selector<ChessBoardViewmodel, bool>(
                selector: (context, viewmodel) =>
                    viewmodel.boardState.isPromotion,
                builder: (context, isPromotion, _) {
                  if (isPromotion) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      PromotionDialog.show(
                        context,
                        chessBoardViewmodel.boardState.activeSide,
                      ).then((chosenPiece) {
                        chessBoardViewmodel.promotePiece(
                          piecePromotedTo: chosenPiece!,
                        );
                      });
                    });
                  }
                  return SizedBox.shrink();
                },
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  child: Column(
                    children: List.generate(8, (rowIndex) {
                      return Row(
                        children: List.generate(8, (colIndex) {
                          int squareIndex = rowIndex * 8 + 7 - colIndex;

                          Sides squareColor = (rowIndex + colIndex).isEven
                              ? Sides.black
                              : Sides.white;

                          return Square(
                            chessBoardViewmodel: chessBoardViewmodel,
                            tileSize: tileSize,
                            squareColor: squareColor,
                            index: isPlayerOneWhite
                                ? 63 - squareIndex
                                : squareIndex,
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),

              IgnorePointer(
                ignoring: true,
                child: Column(
                  children: List.generate(8, (rank) {
                    int rankNumber = isPlayerOneWhite ? 8 - rank : rank + 1;

                    return SizedBox(
                      width: tileSize,
                      height: tileSize,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          tileSize * 0.05,
                          tileSize * 0.025,
                          0,
                          0,
                        ),
                        child: Text(
                          "$rankNumber",
                          style: TextStyle(fontSize: tileSize * 0.2),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: IgnorePointer(
                  ignoring: true,
                  child: Row(
                    children: List.generate(8, (file) {
                      int fileIndex = isPlayerOneWhite ? file : 7 - file;

                      return SizedBox(
                        width: tileSize,
                        height: tileSize,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              0,
                              tileSize * 0.05,
                              tileSize * 0.025,
                            ),
                            child: Text(
                              files[fileIndex],
                              style: TextStyle(fontSize: tileSize * 0.2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              ...chessBoardViewmodel.boardState.pieceList.entries.map(
                (entry) => Selector<ChessBoardViewmodel, PieceModel?>(
                  key: ValueKey(entry.key),

                  selector: (context, viewModel) =>
                      viewModel.boardState.pieceList[entry.key],
                  builder: (context, pieceModel, child) {
                    if (pieceModel == null || pieceModel.isCaptured) {
                      return SizedBox.shrink();
                    }
                    int index = isPlayerOneWhite
                        ? pieceModel.index
                        : 63 - pieceModel.index;

                    int rowIndex = (7 - index ~/ 8);
                    int colIndex = (index % 8 + 1);
                    double topPosition =
                        ((rowIndex * tileSize) + (tileSize - pieceSize) / 2);
                    double leftPosition =
                        (((colIndex - 1) * tileSize) +
                        (tileSize - pieceSize) / 2);

                    return Piece(
                      piece: pieceModel,
                      pieceSize: pieceSize,
                      topPosition: topPosition,
                      leftPosition: leftPosition,
                    );
                  },
                ),
              ),
     
              Selector<ChessBoardViewmodel, bool>(
                selector: (context, chessBoardViewmodel) =>
                    chessBoardViewmodel.lockBoard,
                builder: (context, lockBoard, child) {
                  if (lockBoard) {
                    return AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(width: size, height: size),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              Selector<ChessBoardViewmodel, FirstPlayerPOVResult>(
                selector: (context, chessBoardViewmodel) =>
                    chessBoardViewmodel.result,
                builder: (context, result, child) {
                  if (result != FirstPlayerPOVResult.ongoing) {
                    return AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(width: size, height: size),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
