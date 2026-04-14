import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/controllers/audio_controller.dart';
import 'package:chess_app/core/session_manager.dart';
import 'package:chess_app/core/widgets/background/background_match.dart';
import 'package:chess_app/core/widgets/background/background_menu.dart';
import 'package:chess_app/features/main_menu/view/game_mode_menu.dart';
import 'package:chess_app/features/main_menu/view/main_menu.dart';
import 'package:chess_app/features/main_menu/view/time_mode_menu.dart';
import 'package:chess_app/features/match/view/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioController().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SessionManagerService sessionManagerService = context
        .read<SessionManagerService>();

    final GoRouter router = GoRouter(
      initialLocation: "/",
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return BackgroundMenu(child: child);
          },
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) {
                if (sessionManagerService.isOnline) {
                  sessionManagerService.disconnectSocket();
                }

                return MainMenu();
              },
            ),
            GoRoute(
              path: "/online",
              builder: (context, state) =>
                  GameModeMenu(connectionMode: ConnectionMode.online),
            ),
            GoRoute(
              path: "/offline",
              builder: (context, state) =>
                  GameModeMenu(connectionMode: ConnectionMode.offline),
            ),
            GoRoute(
              path: "/:gamemode(pvp|pve)",
              builder: (context, state) {
                return TimeModeMenu();
              },
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) {
            return BackgroundMatch(child: child);
          },
          routes: [
            GoRoute(
              path: "/pvp/:timemode(blitz|rapid|normal)/match",
              builder: (context, state) {
                return Loading();
              },
              onExit: (context, state) {
                sessionManagerService.leaveMatch();
                return true;
              },
            ),
            GoRoute(
              path: "/pve/:timemode(blitz|rapid|normal)/match",
              builder: (context, state) {
                return Loading(enableBot: true);
              },
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'Chess Game',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff7B61FF),
          brightness: Brightness.light,
        ),
        fontFamily: "Roboto",
      ),
    );
  }
}
