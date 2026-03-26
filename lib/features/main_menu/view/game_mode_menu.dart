import 'dart:io';

import 'package:chess_app/core/session_data.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameModeMenu extends StatelessWidget {
  const GameModeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionDataService sessionDataService =
        Provider.of<SessionDataService>(context);

    return Column(
      mainAxisAlignment: context.isLandscape
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        MenuNavButton(
          label: "PVP",
          onPressed: () {
            sessionDataService.updateGameMode("pvp");
            context.push("/pvp");
          },
        ),
        MenuNavButton(
          label: "PVE",
          onPressed: () {
            sessionDataService.updateGameMode("pve");
            context.push("/pve");
          },
        ),
        MenuNavButton(
          label: "BACK",
          onPressed: () => context.pop(),
          textColor: Colors.black,
        ),
        SizedBox(height: AppTheme.spaceM),
        MenuNavButton(
          label: "QUIT",
          onPressed: () => exit(0),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
