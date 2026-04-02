import 'dart:io';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/session_manager.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/features/main_menu/view/match_making.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameModeMenu extends StatefulWidget {
  final ConnectionMode connectionMode;

  const GameModeMenu({super.key, required this.connectionMode});

  @override
  State<GameModeMenu> createState() => _GameModeMenuState();
}

class _GameModeMenuState extends State<GameModeMenu> {
  late SessionManagerService sessionManagerService;

  bool isDialogOpen = false;

  List<Widget> _buildOnlineButtons(
    BuildContext context,
    SessionManagerService service,
  ) {
    return [
      MenuNavButton(
        label: "ONLINE MATCH MAKING",
        onPressed: () {
          service.joinMatchMaking();
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
    SessionManagerService service,
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
      MenuNavButton(label: "LOAD"),
    ];
  }

  void _onSessionChanged() {
    final isWaiting = context.read<SessionManagerService>().isQueuing;

    if (isWaiting) {
      isDialogOpen = true;
      MatchMakingDialog.show(context).then((_) {
        isDialogOpen = false;
        if (isWaiting) {
          sessionManagerService.leaveMatchMaking();
        }
      });
    } else if (isDialogOpen) {
      isDialogOpen = false;
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    sessionManagerService = context.read<SessionManagerService>();
    context.read<SessionManagerService>().addListener(_onSessionChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: (context.isMobile && context.isLandscape)
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        spacing: context.isMobile ? 0 : AppTheme.spaceM,
        children: [
          if (widget.connectionMode == ConnectionMode.online)
            ..._buildOnlineButtons(context, sessionManagerService)
          else
            ..._buildOfflineButtons(context, sessionManagerService),

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
      ),
    );
  }

  @override
  void dispose() {
    context.read<SessionManagerService>().removeListener(_onSessionChanged);
    super.dispose();
  }
}
