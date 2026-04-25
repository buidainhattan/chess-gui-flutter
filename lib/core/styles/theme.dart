import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ScreenSize { s, m, l, xl, xxl }

class AppTheme {
  const AppTheme._();

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
}

extension ResponsiveScaling on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Returns a percentage of the width
  double w(double percent) => screenWidth * percent;

  // Returns a percentage of the height
  double h(double percent) => screenHeight * percent;

  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

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

/// Built-in presets. Expose these as the user-selectable options.
class BoardThemes {
  const BoardThemes._();

  static const classic = BoardTheme(
    name: 'Classic',
    lightSquare: Color(0xFFF0D9B5),
    darkSquare: Color(0xFFB58863),
  );

  static const green = BoardTheme(
    name: 'Green',
    lightSquare: Color(0xFFEEEED2),
    darkSquare: Color(0xFF769656),
  );

  static const blue = BoardTheme(
    name: 'Blue',
    lightSquare: Color(0xFFDEE3E6),
    darkSquare: Color(0xFF8CA2AD),
  );

  static const walnut = BoardTheme(
    name: 'Walnut',
    lightSquare: Color(0xFFE8C89A),
    darkSquare: Color(0xFF8B5E3C),
  );

  static const highContrast = BoardTheme(
    name: 'High Contrast',
    lightSquare: Color(0xFFFFFFFF),
    darkSquare: Color(0xFF404040),
  );

  static const List<BoardTheme> all = [
    classic,
    green,
    blue,
    walnut,
    highContrast,
  ];
}

@immutable
class BoardTheme {
  final String name;
  final Color lightSquare;
  final Color darkSquare;

  // Overlay alphas — ColorScheme supplies the actual color at render time
  final double selectedAlpha;
  final double lastMoveAlpha;
  final double checkAlpha;
  final double validMoveAlpha;

  const BoardTheme({
    required this.name,
    required this.lightSquare,
    required this.darkSquare,
    this.selectedAlpha = 0.45,
    this.lastMoveAlpha = 0.35,
    this.checkAlpha = 0.55,
    this.validMoveAlpha = 0.30,
  });

  /// Returns the base square color for a given [isLight] square.
  Color squareColor(bool isLight) => isLight ? lightSquare : darkSquare;

  /// Selected square overlay — uses ColorScheme.primary
  Color selectedOverlay(ColorScheme cs) =>
      cs.primary.withValues(alpha: selectedAlpha);

  /// Last move highlight — uses ColorScheme.tertiary
  Color lastMoveOverlay(ColorScheme cs) =>
      cs.tertiary.withValues(alpha: lastMoveAlpha);

  /// King in check — uses ColorScheme.error
  Color checkOverlay(ColorScheme cs) => cs.error.withValues(alpha: checkAlpha);

  /// Valid move dot/ring — uses ColorScheme.secondary
  Color validMoveOverlay(ColorScheme cs) =>
      cs.secondary.withValues(alpha: validMoveAlpha);

  BoardTheme copyWith({
    String? name,
    Color? lightSquare,
    Color? darkSquare,
    double? selectedAlpha,
    double? lastMoveAlpha,
    double? checkAlpha,
    double? validMoveAlpha,
  }) {
    return BoardTheme(
      name: name ?? this.name,
      lightSquare: lightSquare ?? this.lightSquare,
      darkSquare: darkSquare ?? this.darkSquare,
      selectedAlpha: selectedAlpha ?? this.selectedAlpha,
      lastMoveAlpha: lastMoveAlpha ?? this.lastMoveAlpha,
      checkAlpha: checkAlpha ?? this.checkAlpha,
      validMoveAlpha: validMoveAlpha ?? this.validMoveAlpha,
    );
  }
}
