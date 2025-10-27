import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MatchEndDialog extends StatelessWidget {
  final bool isWinner;

  static Future<void> show(BuildContext context, bool isWinner) {
    return showDialog(
      context: context,
      builder: (_) => MatchEndDialog._(isWinner: isWinner),
    );
  }

  const MatchEndDialog._({required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: isWinner ? const Text("YOU WIN!") : const Text("YOU LOSE!"),
      content: const Text("Do you want to return to main menu?"),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.go("/");
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text("No"),
        ),
      ],
    );
  }
}
