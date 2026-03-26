import 'dart:io';

import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: context.isLandscape
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        MenuNavButton(label: "NEW GAME", route: "/gamemode"),
        MenuNavButton(label: "LOAD"),
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
