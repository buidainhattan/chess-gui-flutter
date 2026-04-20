import 'dart:io' show Platform;
import 'package:chess_app/app_viewmodel.dart';
import 'package:chess_app/core/session_service.dart';
import 'package:chess_app/core/settings_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:chess_app/app.dart';
import 'package:chess_app/core/controllers/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AudioController().initialize();

  final SettingsService settingsService = SettingsService();
  await settingsService.init();

  // Check for Desktop Platform (Windows, macOS, Linux)
  bool isDesktop;
  if (kIsWeb) {
    isDesktop = false;
  } else {
    isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  if (isDesktop) {
    await windowManager.ensureInitialized();

    // Set up Window Manager Listeners for Dispose
    WindowManager.instance.addListener(_AudioDisposeListener());

    // Configure Window Settings
    await windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setAspectRatio(16 / 9);
      await windowManager.setSize(const Size(1024, 600));
      await windowManager.setMinimumSize(const Size(1024, 600));
      await windowManager.center();
    });
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: settingsService),
        ChangeNotifierProvider(create: (_) => SessionService()),
        ChangeNotifierProvider(create: (_) => AppViewmodel(settingsService))
      ],
      child: const MyApp(),
    ),
  );
}

class _AudioDisposeListener extends WindowListener {
  _AudioDisposeListener();

  @override
  void onWindowClose() {
    AudioController().dispose();
  }
}
