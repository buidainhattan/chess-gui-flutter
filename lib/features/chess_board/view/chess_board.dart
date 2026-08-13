import 'dart:async';
import 'dart:math' as math;

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/widgets/animation_wrapper/hovering.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:chess_app/features/chess_board/view/confirm_overlay.dart';
import 'package:chess_app/features/chess_board/view/promotion_overlay.dart';
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
        tileSize = size / 8;
        pieceSize = tileSize * 0.75;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: colorScheme.primary,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: List.generate(8, (rowIndex) {
                    return Row(
                      children: List.generate(8, (colIndex) {
                        int squareIndex = rowIndex * 8 + 7 - colIndex;

                        Sides squareColor = (rowIndex + colIndex).isEven
                            ? Sides.black
                            : Sides.white;

                        return Square(
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
                      ({PieceModel? piece, bool isDragged, bool hoverEnabled})
                    >(
                      selector: (context, viewModel) => (
                        piece: viewModel.boardState.pieceList[entry.key],
                        isDragged: viewModel.isDragged,
                        hoverEnabled: !viewModel.isPieceAnimating(entry.key),
                      ),
                      builder: (context, state, child) {
                        final pieceModel = state.piece;

                        if (pieceModel == null || pieceModel.isCaptured) {
                          return const SizedBox.shrink();
                        }

                        int index = isPlayerOneWhite
                            ? pieceModel.index
                            : 63 - pieceModel.index;
                        int rowIndex = (7 - index ~/ 8);
                        int colIndex = (index % 8 + 1);
                        double offset = 0;
                        double topPosition = ((rowIndex * tileSize) + offset);
                        double leftPosition =
                            (((colIndex - 1) * tileSize) + offset);

                        return AnimatedPositioned(
                          duration: state.isDragged
                              ? Duration.zero
                              : Duration(
                                  milliseconds:
                                      chessBoardViewmodel.animationSpeed.value,
                                ),
                          curve: Curves.easeOut,
                          top: topPosition,
                          left: leftPosition,
                          onEnd: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              chessBoardViewmodel.onPieceAnimationEnd(
                                pieceModel.key,
                              );
                              chessBoardViewmodel.draggingEnd();
                            });
                          },
                          child: Draggable<int>(
                            data: pieceModel.index,
                            maxSimultaneousDrags:
                                chessBoardViewmodel.pieceMovementTypeSetting ==
                                    PieceMovementType.tap
                                ? 0
                                : 1,
                            onDragStarted: () {
                              chessBoardViewmodel.draggingStart();
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
                            dragAnchorStrategy: pointerDragAnchorStrategy,
                            feedback: Piece(
                              piece: pieceModel,
                              pieceSize: pieceSize,
                            ),
                            childWhenDragging: const SizedBox.shrink(),
                            child: GestureDetector(
                              onTap: () {
                                if (chessBoardViewmodel
                                        .pieceMovementTypeSetting !=
                                    PieceMovementType.drag) {
                                  chessBoardViewmodel.onSquareTapped(index);
                                }
                              },
                              child: IgnorePointer(
                                ignoring: state.isDragged,
                                child: HoveringWrapper(
                                  enabled: state.hoverEnabled,
                                  child: SizedBox(
                                    width: tileSize,
                                    height: tileSize,
                                    child: Center(
                                      child: Piece(
                                        piece: pieceModel,
                                        pieceSize: pieceSize,
                                      ),
                                    ),
                                  ),
                                ),
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

              Selector<ChessBoardViewmodel, Completer<bool>?>(
                selector: (context, viewmodel) =>
                    viewmodel.moveConfirmCompleter,
                builder: (context, moveCompleter, child) {
                  if (moveCompleter != null) {
                    final int toSquare = chessBoardViewmodel.boardState.to!;
                    final String pieceKey =
                        chessBoardViewmodel.boardState.pieceKeys[toSquare];

                    return Positioned.fill(
                      child: ConfirmOverlay(
                        squareIndex: toSquare,
                        boardSize: size,
                        confirmCompleter: moveCompleter,
                        pieceWidget: Piece(
                          piece: chessBoardViewmodel
                              .boardState
                              .pieceList[pieceKey]!,
                          pieceSize: pieceSize,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
