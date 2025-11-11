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
  final bool enableBot;

  const ChessBoard({super.key, required this.enableBot});

  @override
  Widget build(BuildContext context) {
    final chessBoardViewmodel = Provider.of<ChessBoardViewmodel>(
      context,
      listen: false,
    );
    chessBoardViewmodel.toggleBot(enableBot, Sides.black);

    const List<String> files = ["A", "B", "C", "D", "E", "F", "G", "H"];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double size = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final double tileSize, pieceSize, rankOffset, fileOffset;
        tileSize = size * 43 / 370;
        pieceSize = tileSize * 0.75;
        rankOffset = fileOffset = tileSize / 2;
    
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Selector<ChessBoardViewmodel, bool>(
                selector: (context, viewmodel) => viewmodel.isPromotion,
                builder: (context, isPromotion, child) {
                  if (isPromotion) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      PromotionDialog.show(
                        context,
                        chessBoardViewmodel.activeSide,
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
              Column(
                children: List.generate(9, (rowIndex) {
                  return Row(
                    children: List.generate(9, (colIndex) {
                      int loopIndex = (8 - rowIndex) * 9 + colIndex;
                      int squareIndex = loopIndex - 17 + rowIndex;
    
                      // Generate board black and white squares
                      if (loopIndex % 9 != 0 && loopIndex > 8) {
                        Sides squareColor = (rowIndex + colIndex) % 2 == 0
                            ? Sides.black
                            : Sides.white;
    
                        return Square(
                          chessBoardViewmodel: chessBoardViewmodel,
                          tileSize: tileSize,
                          squareColor: squareColor,
                          index: squareIndex,
                        );
                      } else {
                        // Handle rank numbering
                        if (loopIndex % 9 == 0 && loopIndex > 8) {
                          return SizedBox(
                            width: rankOffset,
                            height: tileSize,
                            child: Center(
                              child: Text("${(8 - rowIndex).toInt()}"),
                            ),
                          );
                        } else {
                          // Handle file alphabetical numbering
                          // Skip a square between rank and file
                          if (loopIndex == 0) {
                            return SizedBox(
                              width: rankOffset,
                              height: fileOffset,
                            );
                          }
                          return SizedBox(
                            width: tileSize,
                            height: fileOffset,
                            child: Center(
                              child: Text((files[colIndex - 1])),
                            ),
                          );
                        }
                      }
                    }),
                  );
                }),
              ),
              ...chessBoardViewmodel.pieceList.entries.map(
                (entry) => Selector<ChessBoardViewmodel, PieceModel?>(
                  key: ValueKey(entry.key),
    
                  selector: (context, viewModel) =>
                      viewModel.pieceList[entry.key],
                  builder: (context, pieceModel, child) {
                    if (pieceModel!.isCaptured) {
                      return SizedBox.shrink();
                    }
    
                    int index = pieceModel.index;
                    int rowIndex = (7 - index ~/ 8);
                    int colIndex = (index % 8 + 1);
                    double topPosition =
                        ((rowIndex * tileSize) +
                        (tileSize - pieceSize) / 2);
                    double leftPosition =
                        (((colIndex - 1) * tileSize) +
                        rankOffset +
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
            ],
          ),
        );
      },
    );
  }
}
