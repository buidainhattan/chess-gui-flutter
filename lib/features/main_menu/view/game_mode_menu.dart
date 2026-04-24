import 'dart:io';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/services/session_service.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/core/widgets/custom_layouts.dart';
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
      PrimaryNavButton(
        label: "MATCH MAKING",
        onPressed: () {
          sessionService.joinMatchMaking();
        },
      ),
      // TODO
      // PrimaryNavButton(
      //   label: "CREATE / JOIN ROOM",
      //   onPressed: () {
      //     sessionService.updateGameMode("pvp");
      //     context.push("/pvp");
      //   },
      // ),
      // SecondaryNavButton(
      //   label: "LAN CONNECTION",
      //   onPressed: () {
      //     sessionService.updateGameMode("pvp");
      //     context.push("/pvp");
      //   },
      // ),
    ];
  }

  List<Widget> _buildOfflineButtons() {
    return [
      PrimaryNavButton(
        label: "PASS & PLAY",
        onPressed: () {
          sessionService.updateGameMode("pvp");
          context.push("/pvp");
        },
      ),
      PrimaryNavButton(
        label: "SOLO PLAY",
        onPressed: () {
          sessionService.updateGameMode("pve");
          context.push("/pve");
        },
      ),
      // TODO
      // SecondaryNavButton(label: "LOAD", onPressed: () {}),
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
      child: MenuLayout(
        children: [
          if (widget.connectionMode == ConnectionMode.online)
            ..._buildOnlineButtons()
          else
            ..._buildOfflineButtons(),

          TertiaryNavButton(label: "BACK", onPressed: () => context.pop()),
          DestructiveButton(label: "QUIT", onPressed: () => exit(0)),
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
