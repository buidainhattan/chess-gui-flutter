import 'dart:io';

import 'package:chess_app/core/services/session_service.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/core/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionService sessionService = Provider.of<SessionService>(context);

    return MenuLayout(
      children: [
        PrimaryNavButton(
          label: "PLAY ONLINE",
          onPressed: () {
            sessionService.connectSocket();
            context.push("/online");
          },
        ),
        SecondaryNavButton(label: "PLAY OFFLINE", route: "/offline"),
        TertiaryNavButton(label: "SETTINGS", route: "/settings"),
        DestructiveButton(label: "QUIT", onPressed: () => exit(0)),
      ],
    );
  }
}
