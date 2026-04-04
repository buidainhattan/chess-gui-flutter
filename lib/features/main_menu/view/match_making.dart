import 'package:chess_app/core/constants/all_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MatchMakingDialog extends StatelessWidget {
  static Future<MatchMakingStatus?> show(BuildContext context) async {
    return showDialog<MatchMakingStatus>(
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
            context.pop(MatchMakingStatus.cancelled);
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
