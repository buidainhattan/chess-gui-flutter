import 'dart:io' show Platform;

import 'package:flutter/material.dart';

enum ScreenSize { s, m, l, xl, xxl }

class AppTheme {
  // 1. Breakpoints - Essential for Windows/Desktop resizing
  static const double sBreakPoint = 576;
  static const double mBreakpoint = 768;
  static const double lBreakpoint = 992;
  static const double xlBreakpoint = 1200;
  static const double xxlBreakPoint = 1400;

  // 3. Scaling Spacing Units
  // Instead of hardcoding 8.0 everywhere, use these.
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 32.0;

  // 4. The Master Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppCustomColors.background,
      scaffoldBackgroundColor: const Color(0xFF121212),
      // Define a standard text theme that scales well
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: AppCustomColors.textDim),
      ),
    );
  }
}

extension ResponsiveScaling on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Returns a percentage of the width
  double w(double percent) => screenWidth * percent;

  // Returns a percentage of the height
  double h(double percent) => screenHeight * percent;

  bool get isMobile => Platform.isAndroid || Platform.isIOS;

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}

extension ScreenSizeExtension on BuildContext {
  ScreenSize get screenSize {
    if (screenWidth > AppTheme.xxlBreakPoint) return ScreenSize.xxl;
    if (screenWidth > AppTheme.xlBreakpoint) return ScreenSize.xl;
    if (screenWidth > AppTheme.lBreakpoint) return ScreenSize.l;
    if (screenWidth > AppTheme.mBreakpoint) return ScreenSize.m;
    return ScreenSize.s;
  }
}

extension ResponsivePicker on BuildContext {
  // A generic picker that works for any type (double, color, int, etc.)
  T responsive<T>({required T s, T? m, T? l, T? xl, T? xxl}) {
    switch (screenSize) {
      case ScreenSize.xxl:
        return xxl ?? xl ?? l ?? m ?? s;
      case ScreenSize.xl:
        return xl ?? l ?? m ?? s;
      case ScreenSize.l:
        return l ?? m ?? s;
      case ScreenSize.m:
        return m ?? s;
      default:
        return s;
    }
  }
}

class AppCustomColors {
  static const Color purple = Color.fromRGBO(123, 97, 255, 1);
  static const Color red = Color.fromRGBO(220, 54, 46, 1);
  static const Color background = Color(0xFFF4F7FA);
  static const Color surface = Color(0xFFE8EDF9);
  static const Color border = Color(0xFFB7C0D8);
  static const Color dark = Color(0xFF34364C);
  static const Color textDim = Color(0x8834364C);
  static const Color textMid = Color(0xBB34364C);
  static const Color activeBg = Color(0x1234364C);
}
