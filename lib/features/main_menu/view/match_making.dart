import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MatchMakingDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => MatchMakingDialog._(),
    );
  }

  const MatchMakingDialog._();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Match Making"),
      content: const Text("Match making in progress..."),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
