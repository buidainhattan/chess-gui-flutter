import 'package:chess_app/core/basics/string_extensions.dart';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:chess_app/features/match/viewmodel/timer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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

    final double pieceSize = 25;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _PlayerInfoDisplayer(
                    playerName: "Player 2 (Bot)",
                    playerSide: matchViewmodel.playerOneSide,
                    isPlayerOne: false,
                    pieceSize: pieceSize,
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: ChessBoard(enableBot: enableBot),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _PlayerInfoDisplayer(
                    playerName: "Player 1",
                    playerSide: matchViewmodel.playerTwoSide,
                    isPlayerOne: true,
                    pieceSize: pieceSize,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(232, 237, 249, 1),
                border: Border(
                  bottom: BorderSide(width: 2),
                  left: BorderSide(width: 2),
                ),
                borderRadius: BorderRadius.only(topRight: Radius.circular(5)),
              ),
              child: Column(
                children: [
                  _MatchStateDisplayer(),
                  SizedBox(height: 20),
                  Expanded(child: _ZebraStripedList()),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: _MenuBar(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerInfoDisplayer extends StatelessWidget {
  final String playerName;
  final String playerSide;
  final bool isPlayerOne;
  final double pieceSize;

  const _PlayerInfoDisplayer({
    required this.playerName,
    required this.playerSide,
    required this.isPlayerOne,
    required this.pieceSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(playerName),
              Consumer<MatchViewmodel>(
                builder: (context, viewmodel, child) {
                  final List<PieceTypes> piecesCaptured = isPlayerOne
                      ? viewmodel.playerOnePieceCaptured
                      : viewmodel.playerTwoPieceCaptured;
                  if (piecesCaptured.isEmpty) {
                    return SizedBox(height: pieceSize, width: pieceSize);
                  }
                  return Expanded(
                    child: _CapturedPiecesDisplayer(
                      side: playerSide,
                      piecesCaptured: piecesCaptured,
                      pieceSize: pieceSize,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Selector<TimerViewmodel, String>(
          selector: (context, timerViewmodel) => timerViewmodel.playerTwoTime,
          builder: (context, timeString, child) {
            return Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                border: BoxBorder.all(width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(timeString, style: TextStyle(fontSize: 25)),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CapturedPiecesDisplayer extends StatelessWidget {
  final String side;
  final List<PieceTypes> piecesCaptured;
  final double pieceSize;

  const _CapturedPiecesDisplayer({
    required this.side,
    required this.piecesCaptured,
    required this.pieceSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: piecesCaptured.asMap().entries.map((entry) {
        final int index = entry.key;
        final PieceTypes piece = entry.value;
        final double pieceOffset = (pieceSize * (index) / 2) - 3;
        return Positioned(
          left: pieceOffset,
          child: SvgPicture.asset(
            "assets/images/chess_pieces/$side/${piece.name}.svg",
            width: pieceSize,
          ),
        );
      }).toList(),
    );
  }
}

class _MatchStateDisplayer extends StatelessWidget {
  const _MatchStateDisplayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 25, 0, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 2),
          left: BorderSide(width: 2),
        ),
        borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Selector<MatchViewmodel, String>(
            selector: (context, matchViewmodel) => matchViewmodel.sideToMove,
            builder: (context, sideToMove, child) {
              return Text("${sideToMove.toCaptialized()}'s Turn");
            },
          ),
          Selector<MatchViewmodel, int>(
            selector: (context, matchViewmodel) => matchViewmodel.halfMoveClock,
            builder: (context, halfMoveClock, child) {
              return Text("Halfmove Clock: $halfMoveClock move(s)");
            },
          ),
          Selector<MatchViewmodel, int>(
            selector: (context, matchViewmodel) => matchViewmodel.fullMoveCount,
            builder: (context, fullMoveCount, child) {
              return Text("Number of Full Move: $fullMoveCount move(s)");
            },
          ),
        ],
      ),
    );
  }
}

class _ZebraStripedList extends StatelessWidget {
  // Define the alternating colors
  static const Color primaryColor = Color.fromRGBO(183, 192, 216, 1);
  static const Color alternateColor = Color.fromRGBO(
    211,
    216,
    229,
    1,
  ); // Slightly darker Periwinkle

  const _ZebraStripedList();

  @override
  Widget build(BuildContext context) {
    return Selector<MatchViewmodel, List<String>>(
      selector: (context, matchViewmodel) => matchViewmodel.algebraicHistory,
      builder: (context, algebraicHistory, child) {
        final List<String> data = algebraicHistory;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5,
          ),
          itemCount: algebraicHistory.length,
          itemBuilder: (context, index) {
            // Determine the background color based on the index (even or odd)
            final int rowIndex = index ~/ 2;
            final Color rowColor = rowIndex.isEven
                ? primaryColor
                : alternateColor;
            final String notation = data[index];

            return Container(
              // Set the calculated alternating color as the row background
              color: rowColor,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),

              child: Text(
                "$index. $notation",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MenuBar extends StatelessWidget {
  final Color buttonBackgroundColor = Color.fromRGBO(183, 192, 216, 1);
  final Color iconColor = Color.fromRGBO(52, 54, 76, 1);

  _MenuBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InMatchIconButton(
              onPressed: () {},
              svgIconPath: "assets/icons/resign.svg",
              tooltip: "Resign",
              borderRadius: 10,
              backgroundColor: buttonBackgroundColor,
              iconColor: iconColor,
            ),
            SizedBox(width: 25),
            InMatchIconButton(
              onPressed: () {},
              svgIconPath: "assets/icons/redo.svg",
              tooltip: "Redo",
              borderRadius: 10,
              backgroundColor: buttonBackgroundColor,
              iconColor: iconColor,
            ),
          ],
        ),
        InMatchIconButton(
          onPressed: () {
            context.go("/");
          },
          svgIconPath: "assets/icons/home.svg",
          tooltip: "Home",
          borderRadius: 10,
          backgroundColor: buttonBackgroundColor,
          iconColor: iconColor,
        ),
      ],
    );
  }
}
