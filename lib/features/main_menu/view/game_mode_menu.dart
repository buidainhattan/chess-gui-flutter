import 'dart:io';

import 'package:chess_app/core/styles/color.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameModeMenu extends StatelessWidget {
  const GameModeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          top: (screenHeight / 1.7),
          width: (6 / 11 * screenWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.push("/pvp/match");
                },
                child: Text(
                  "PVP",
                  style: AppTextStyles.menu(
                    color: AppCustomColors.purple,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push("/pve/match");
                },
                child: Text(
                  "PVE",
                  style: AppTextStyles.menu(
                    color: Colors.black,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  "BACK",
                  style: AppTextStyles.menu(
                    color: AppCustomColors.purple,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
              SizedBox(height: (screenHeight / 19.2)),
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: Text(
                  "QUIT",
                  style: AppTextStyles.menu(
                    color: AppCustomColors.red,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
