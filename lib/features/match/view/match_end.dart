import 'package:chess_app/core/basics/string_extensions.dart';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MatchEndDialog extends StatelessWidget {
  final GameResultType result;

  static Future<void> show(BuildContext context, GameResultType result) {
    return showDialog(
      context: context,
      builder: (_) => MatchEndDialog._(result : result),
    );
  }

  const MatchEndDialog._({required this.result});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${result.name.toCaptialized()}!"),
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
