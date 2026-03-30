import 'dart:io';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/session_data.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameModeMenu extends StatelessWidget {
  final ConnectionMode connectionMode;

  const GameModeMenu({super.key, required this.connectionMode});

  List<Widget> _buildOnlineButtons(
    BuildContext context,
    SessionDataService service,
  ) {
    return [
      MenuNavButton(
        label: "ONLINE MATCH MAKING",
        onPressed: () {
          service.updateGameMode("pvp");
          context.push("/pvp");
        },
      ),
      MenuNavButton(
        label: "CREATE / JOIN ROOM",
        onPressed: () {
          service.updateGameMode("pvp");
          context.push("/pvp");
        },
      ),
      MenuNavButton(
        label: "LAN CONNECTION",
        onPressed: () {
          service.updateGameMode("pvp");
          context.push("/pvp");
        },
      ),
    ];
  }

  List<Widget> _buildOfflineButtons(
    BuildContext context,
    SessionDataService service,
  ) {
    return [
      MenuNavButton(
        label: "PASS & PLAY",
        onPressed: () {
          service.updateGameMode("pve");
          context.push("/pve");
        },
      ),
      MenuNavButton(
        label: "SOLO PLAY",
        onPressed: () {
          service.updateGameMode("pve");
          context.push("/pve");
        },
      ),
      MenuNavButton(label: "LOAD")
    ];
  }

  @override
  Widget build(BuildContext context) {
    final SessionDataService sessionDataService =
        Provider.of<SessionDataService>(context);

    return Column(
      mainAxisAlignment: (context.isMobile && context.isLandscape)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      spacing: context.isMobile ? 0 : AppTheme.spaceM,
      children: [
        if (connectionMode == ConnectionMode.online)
          ..._buildOnlineButtons(context, sessionDataService)
        else
          ..._buildOfflineButtons(context, sessionDataService),

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
