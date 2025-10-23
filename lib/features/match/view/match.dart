import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Match extends StatelessWidget {
  const Match({super.key, this.enableBot = false});

  final bool enableBot;

  @override
  Widget build(BuildContext context) {
    final double pieceSize = 20;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: ChessBoard(enableBot: enableBot),
            ),
          ),
          Consumer<MatchViewmodel>(
            builder: (context, matchViewmodel, child) {
              return Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: Text("Player 2")),
                    Expanded(
                      child: Container(
                        color: Colors.yellow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Playing as ${matchViewmodel.playerTwoSide}"),
                            Row(
                              children: [
                                Text(matchViewmodel.playerTwoTime),
                              ],
                            ),
                            Wrap(
                              children: [
                                Text("Piece captured: "),
                                ...matchViewmodel.playerTwoPieceCaptured!.map((
                                  piece,
                                ) {
                                  return SvgPicture.asset(
                                    "assets/images/chess_pieces/${matchViewmodel.playerOneSide}/${piece.name}.svg",
                                    width: pieceSize,
                                    height: pieceSize,
                                  );
                                }),
                              ],
                            ),
                            Text("Castling right: Both"),
                          ],
                        ),
                      ),
                    ),
                    Center(child: Text("Player 1")),
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Playing as ${matchViewmodel.playerOneSide}"),
                            Row(
                              children: [
                                Text(matchViewmodel.playerOneTime),
                              ],
                            ),
                            Wrap(
                              children: [
                                Text("Piece captured: "),
                                ...matchViewmodel.playerOnePieceCaptured!.map((
                                  piece,
                                ) {
                                  return SvgPicture.asset(
                                    "assets/images/chess_pieces/${matchViewmodel.playerTwoSide}/${piece.name}.svg",
                                    width: pieceSize,
                                    height: pieceSize,
                                  );
                                }),
                              ],
                            ),
                            Text("Castling right: Both"),
                          ],
                        ),
                      ),
                    ),
                    Center(child: Text("Match status")),
                    Expanded(
                      child: Container(
                        color: Colors.amberAccent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Current side to move: ${matchViewmodel.sideToMove}"),
                            Text("Halfmove clock: ${matchViewmodel.halfMoveClock}"),
                            Text("Number of full move: ${matchViewmodel.fullMoveCount}"),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Forfeit"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("TEST BUTTON"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text("BACK"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
