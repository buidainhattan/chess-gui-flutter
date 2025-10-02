import 'dart:io';

import 'package:chess_app/core/styles/color.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

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
                  context.push("/gamemode");
                },
                child: Text(
                  "START",
                  style: AppTextStyles.menu(
                    color: AppCustomColors.purple,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "LOAD",
                  style: AppTextStyles.menu(
                    color: Colors.black,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "SETTINGS",
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
