import 'dart:io';

import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: (context.isMobile && context.isLandscape)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      spacing: context.isMobile ? 0 : AppTheme.spaceM,
      children: [
        MenuNavButton(label: "PLAY ONLINE", route: "/online"),
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
