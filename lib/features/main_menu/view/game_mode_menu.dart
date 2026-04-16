import 'dart:io';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/session_service.dart';
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
  late SessionService sessionService;

  bool isDialogOpen = false;

  List<Widget> _buildOnlineButtons() {
    return [
      MenuNavButton(
        label: "ONLINE MATCH MAKING",
        onPressed: () {
          sessionService.joinMatchMaking();
        },
      ),
      MenuNavButton(
        label: "CREATE / JOIN ROOM",
        onPressed: () {
          sessionService.updateGameMode("pvp");
          context.push("/pvp");
        },
      ),
      MenuNavButton(
        label: "LAN CONNECTION",
        onPressed: () {
          sessionService.updateGameMode("pvp");
          context.push("/pvp");
        },
      ),
    ];
  }

  List<Widget> _buildOfflineButtons() {
    return [
      MenuNavButton(
        label: "PASS & PLAY",
        onPressed: () {
          sessionService.updateGameMode("pvp");
          context.push("/pvp");
        },
      ),
      MenuNavButton(
        label: "SOLO PLAY",
        onPressed: () {
          sessionService.updateGameMode("pve");
          context.push("/pve");
        },
      ),
      MenuNavButton(label: "LOAD"),
    ];
  }

  void _onMatchMakingStatusChanges() {
    final MatchMakingStatus? status = sessionService.matchMakingStatus;

    if (status == MatchMakingStatus.pending) {
      isDialogOpen = true;
      MatchMakingDialog.show(context).then((result) {
        isDialogOpen = false;
        if (result == MatchMakingStatus.cancelled || result == null) {
          sessionService.leaveMatchMaking();
        }
      });
    } else if (status == MatchMakingStatus.matchFound) {
      if (isDialogOpen) {
        isDialogOpen = false;
        context.pop(status);
      }

      context.go("/pvp/normal/match");
    }
  }

  @override
  void initState() {
    super.initState();
    sessionService = context.read<SessionService>();
    sessionService.addListener(_onMatchMakingStatusChanges);
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
            ..._buildOnlineButtons()
          else
            ..._buildOfflineButtons(),

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
    sessionService.removeListener(_onMatchMakingStatusChanges);
    super.dispose();
  }
}
