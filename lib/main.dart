import 'package:chess_app/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setAspectRatio(16 / 9);
    await windowManager.setSize(const Size(1024, 600));
    await windowManager.setMinimumSize(const Size(1024, 600));
    await windowManager.center();
  });

  runApp(const MyApp());
}
