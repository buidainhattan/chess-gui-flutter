import 'dart:io';

import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: AppTheme.spaceS,
      children: [
        MenuNavButton(label: "NEW GAME", route: "/gamemode"),
        MenuNavButton(label: "LOAD"),
        MenuNavButton(label: "SETTINGS", textColor: Colors.black),
        MenuNavButton(
          label: "QUIT",
          onPressed: () {
            exit(0);
          },
          textColor: Colors.red,
        ),
      ],
    );
  }
}
