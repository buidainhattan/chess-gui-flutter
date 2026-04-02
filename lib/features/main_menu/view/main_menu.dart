import 'dart:io';

import 'package:chess_app/core/session_manager.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionManagerService sessionDataService =
        Provider.of<SessionManagerService>(context);

    return Column(
      mainAxisAlignment: (context.isMobile && context.isLandscape)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      spacing: context.isMobile ? 0 : AppTheme.spaceM,
      children: [
        MenuNavButton(
          label: "PLAY ONLINE",
          onPressed: () {
            sessionDataService.connectSocket();
            context.push("/online");
          },
        ),
        MenuNavButton(label: "PLAY OFFLINE", route: "/offline"),
        MenuNavButton(label: "SETTINGS", textColor: Colors.black),
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
