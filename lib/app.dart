import 'package:chess_app/core/widgets/background/background_match.dart';
import 'package:chess_app/core/widgets/background/background_menu.dart';
import 'package:chess_app/features/main_menu/view/game_mode_menu.dart';
import 'package:chess_app/features/main_menu/view/main_menu.dart';
import 'package:chess_app/features/match/view/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: "/",
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return BackgroundMenu(child: child);
          },
          routes: [
            GoRoute(path: "/", builder: (context, state) => MainMenu()),
            GoRoute(
              path: "/gamemode",
              builder: (context, state) => GameModeMenu(),
            ),
            ShellRoute(
              builder: (context, state, child) {
                return BackgroundMatch(child: child);
              },
              routes: [
                GoRoute(
                  path: "/pvp/match",
                  builder: (context, state) => Loading(),
                ),
                GoRoute(
                  path: "/pve/match",
                  builder: (context, state) => Loading(enableBot: true),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'Chess Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: "Roboto",
      ),
    );
  }
}
