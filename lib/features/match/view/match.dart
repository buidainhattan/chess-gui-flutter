import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Match extends StatelessWidget {
  const Match({super.key, this.enableBot = false});

  final bool enableBot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChessBoard(enableBot: enableBot,),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: () {}, child: Text("TEST BUTTON")),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text("BACK"),
            ),
          ],
        ),
      ],
    );
  }
}
