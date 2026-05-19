import 'dart:math' as math;

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:chess_app/features/chess_board/view/promotion.dart';
import 'package:chess_app/features/chess_board/viewmodel/chess_board_viewmodel.dart';
import 'package:chess_app/core/widgets/piece.dart';
import 'package:chess_app/core/widgets/square.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
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
        tileSize = size / 8;
        pieceSize = tileSize * 0.75;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: colorScheme.primary,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
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
                          style: context.matchCoordinateLabel(
                            size: tileSize * 0.2,
                          ),
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
                              style: context.matchCoordinateLabel(
                                size: tileSize * 0.2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              ...chessBoardViewmodel.boardState.pieceList.entries.map(
                (entry) =>
                    Selector<
                      ChessBoardViewmodel,
                      ({PieceModel? piece, bool skipAnimation})
                    >(
                      selector: (context, viewModel) => (
                        piece: viewModel.boardState.pieceList[entry.key],
                        skipAnimation: viewModel.isDragMove,
                      ),
                      builder: (context, state, child) {
                        final pieceModel = state.piece;
                        final skipAnimation = state.skipAnimation;

                        if (pieceModel == null || pieceModel.isCaptured) {
                          return const SizedBox.shrink();
                        }

                        // Flip the isDragMove flag as soon as render finished
                        if (skipAnimation) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            chessBoardViewmodel.clearDragMoveFlag();
                          });
                        }

                        int index = isPlayerOneWhite
                            ? pieceModel.index
                            : 63 - pieceModel.index;
                        int rowIndex = (7 - index ~/ 8);
                        int colIndex = (index % 8 + 1);
                        double offset = (tileSize - pieceSize) / 2;
                        double topPosition = ((rowIndex * tileSize) + offset);
                        double leftPosition =
                            (((colIndex - 1) * tileSize) + offset);

                        final int mode = chessBoardViewmodel.pieceMovementType;

                        return AnimatedPositioned(
                          duration: skipAnimation
                              ? Duration.zero
                              : const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          top: topPosition,
                          left: leftPosition,
                          child: Draggable<int>(
                            data: pieceModel.index,
                            maxSimultaneousDrags: mode == 1 ? 0 : 1,
                            onDragStarted: () {
                              if (chessBoardViewmodel.boardState.from != null &&
                                  chessBoardViewmodel.boardState.from !=
                                      pieceModel.index) {
                                chessBoardViewmodel.onSquareTapped(
                                  chessBoardViewmodel.boardState.from!,
                                );
                              }
                              if (chessBoardViewmodel.boardState.from == null) {
                                chessBoardViewmodel.onSquareTapped(
                                  pieceModel.index,
                                );
                              }
                            },
                            onDraggableCanceled: (_, _) {
                              if (chessBoardViewmodel.boardState.from ==
                                  pieceModel.index) {
                                chessBoardViewmodel.onSquareTapped(
                                  pieceModel.index,
                                );
                              }
                            },
                            feedback: Material(
                              color: Colors.transparent,
                              child: SvgPicture.asset(
                                "assets/images/chess_pieces/${pieceModel.color.name}/${pieceModel.type.name}.svg",
                                width: pieceSize,
                                height: pieceSize,
                              ),
                            ),
                            childWhenDragging: const SizedBox.shrink(),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (mode != 0) {
                                  chessBoardViewmodel.onSquareTapped(
                                    pieceModel.index,
                                  );
                                }
                              },
                              child: Piece(
                                piece: pieceModel,
                                pieceSize: pieceSize,
                              ),
                            ),
                          ),
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
              Selector<ChessBoardViewmodel, POVResult>(
                selector: (context, chessBoardViewmodel) =>
                    chessBoardViewmodel.result,
                builder: (context, result, child) {
                  if (result != POVResult.ongoing) {
                    return AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(width: size, height: size),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),

              Selector<ChessBoardViewmodel, bool>(
                selector: (context, viewmodel) => viewmodel.isPromotion,
                builder: (context, isPromotion, child) {
                  if (isPromotion) {
                    return Positioned.fill(
                      child: PromotionOverlay(
                        sideToMove: chessBoardViewmodel.boardState.activeSide,
                        file:
                            chessBoardViewmodel.boardState.promoteSquareIndex! %
                            8,
                        isPOVPromote: chessBoardViewmodel.isPOVTurn,
                        boardSize: size,
                        onPieceSelected: (piece) => chessBoardViewmodel
                            .promotePiece(piecePromotedTo: piece),
                      ),
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
