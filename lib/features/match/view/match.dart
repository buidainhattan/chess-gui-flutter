import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:chess_app/features/match/viewmodel/timer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Match extends StatelessWidget {
  final bool enableBot;

  const Match({super.key, this.enableBot = false});

  @override
  Widget build(BuildContext context) {
    final MatchViewmodel matchViewmodel = Provider.of<MatchViewmodel>(
      context,
      listen: false,
    );

    final double pieceSize = 20;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      const Text("Player 2 (Bot)"),
                      Selector<MatchViewmodel, List<PieceTypes>?>(
                        selector: (context, matchViewmodel) =>
                            matchViewmodel.playerTwoPieceCaptured,
                        builder: (context, pieceCaptured, child) {
                          if (pieceCaptured == null || pieceCaptured.isEmpty) {
                            return SizedBox.shrink();
                          }
                          return Row(
                            children: pieceCaptured.map((piece) {
                              return SvgPicture.asset(
                                "assets/images/chess_pieces/${matchViewmodel.playerOneSide}/${piece.name}.svg",
                                width: pieceSize,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                  Selector<TimerViewmodel, String>(
                    selector: (context, timerViewmodel) =>
                        timerViewmodel.playerTwoTime,
                    builder: (context, timeString, child) {
                      return Text(timeString);
                    },
                  ),
                ],
              ),
              Expanded(
                flex: 5,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ChessBoard(enableBot: enableBot),
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      const Text("Player 1"),
                      Selector<MatchViewmodel, List<PieceTypes>?>(
                        selector: (context, matchViewmodel) =>
                            matchViewmodel.playerOnePieceCaptured,
                        builder: (context, pieceCaptured, child) {
                          if (pieceCaptured == null || pieceCaptured.isEmpty) {
                            return SizedBox.shrink();
                          }
                          return Row(
                            children: pieceCaptured.map((piece) {
                              return SvgPicture.asset(
                                "assets/images/chess_pieces/${matchViewmodel.playerTwoSide}/${piece.name}.svg",
                                width: pieceSize,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                  Selector<TimerViewmodel, String>(
                    selector: (context, timerViewmodel) =>
                        timerViewmodel.playerOneTime,
                    builder: (context, timeString, child) {
                      return Text(timeString);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
