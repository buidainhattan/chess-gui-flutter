import 'package:chess_app/core/styles/theme.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const String _fontFamily = "Roboto";

  // This is the "Master Setting" for all text in your app
  static TextStyle _base({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
    List<FontFeature>? fontFeature,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      fontFeatures: fontFeature,
      letterSpacing: letterSpacing ?? 0.2,
    );
  }
}

extension AppTextContext on BuildContext {
  TextStyle menuText({Color? color}) {
    return AppTextStyles._base(
      size: responsive(s: 18, l: 24, xxl: 30),
      weight: FontWeight.w600,
      color: color ?? Theme.of(this).colorScheme.onPrimaryContainer,
      height: 0.9,
    );
  }

  TextStyle playerNameText(Color? color) {
    return AppTextStyles._base(size: 18, weight: FontWeight.w600, color: color);
  }

  TextStyle timerText(Color? color) {
    return AppTextStyles._base(
      size: 22,
      weight: FontWeight.w600,
      color: color,
      fontFeature: const [FontFeature.tabularFigures()],
    );
  }

  TextStyle turnStripText({Color? color}) {
    return AppTextStyles._base(
      size: 14,
      weight: FontWeight.w600,
      color: color ?? Theme.of(this).colorScheme.onPrimary,
      letterSpacing: 1.1,
    );
  }
}
