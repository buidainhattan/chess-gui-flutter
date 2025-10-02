import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:chess_app/features/chess_board/viewmodel/chess_board_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Match extends StatelessWidget {
  const Match({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChessBoard(),
        Consumer<ChessBoardViewmodel>(
          builder: (context, viewmodel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    viewmodel.openPromotionDialog();
                  },
                  child: Text("TEST PROMOTION"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text("BACK"),
                ),
              ],
            );
          }
        ),
      ],
    );
  }
}
