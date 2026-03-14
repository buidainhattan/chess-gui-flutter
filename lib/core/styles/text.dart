import 'package:chess_app/core/styles/theme.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const String _fontFamily = "Roboto";

  // This is the "Master Setting" for all text in your app
  static TextStyle _base({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
    List<FontFeature>? fontFeature,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      fontFeatures: fontFeature,
      letterSpacing: letterSpacing ?? 0.2,
    );
  }
}

extension AppTextContext on BuildContext {
  TextStyle menuText({Color color = AppCustomColors.purple}) {
    return AppTextStyles._base(
      size: responsive(s: 16, l: 24, xxl: 32),
      weight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle get bodyText {
    return AppTextStyles._base(
      size: responsive(s: 14, l: 18),
      weight: FontWeight.normal,
    );
  }

  TextStyle playerNameText(Color? color) {
    return AppTextStyles._base(
      size: 18,
      weight: FontWeight.w600,
      color: color,
    );
  }

  TextStyle timerText(Color? color) {
    return AppTextStyles._base(
      size: 22,
      weight: FontWeight.w600,
      color: color,
      fontFeature: const [FontFeature.tabularFigures()],
    );
  }

  TextStyle turnStripText({Color? color = AppCustomColors.textMid}) {
    return AppTextStyles._base(
      size: responsive(s: 6, l: 8, xxl: 10),
      weight: FontWeight.w600,
      color: color,
      letterSpacing: 1.1,
    );
  }
}
