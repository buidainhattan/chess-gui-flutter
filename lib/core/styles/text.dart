import 'package:chess_app/core/styles/theme.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Core
// ─────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = "Roboto";

  static TextStyle _base({
    required double size,
    FontWeight? weight,
    Color? color,
    double? height,
    List<FontFeature>? fontFeatures,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: size,
      fontWeight: weight ?? FontWeight.normal,
      color: color,
      height: height ?? 1,
      fontFeatures: fontFeatures,
      letterSpacing: letterSpacing ?? 1,
    );
  }
}

// ─────────────────────────────────────────────
// Navigation & Menus
// ─────────────────────────────────────────────

extension NavigationTextStyles on BuildContext {
  /// Top-level menu items, nav rail labels
  TextStyle menuText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 16, l: 18, xxl: 24),
    weight: FontWeight.w600,
    color: color ?? Theme.of(this).colorScheme.primary,
    letterSpacing: 1.2,
  );

  /// Dropdown/selection items
  TextStyle selectionText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 14, l: 16, xxl: 18),
    weight: FontWeight.w600,
    color: color,
    letterSpacing: 1.2,
  );

  /// Tab labels, bottom nav
  TextStyle tabLabelText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 11, l: 12, xxl: 14),
    weight: FontWeight.w500,
    color: color,
    letterSpacing: 0.8,
  );

  /// Tooltip / contextual hints in menus
  TextStyle menuHintText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 12, l: 13, xxl: 15),
    weight: FontWeight.normal,
    color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
    letterSpacing: 0.4,
  );
}

// ─────────────────────────────────────────────
// Game Board
// ─────────────────────────────────────────────

extension BoardTextStyles on BuildContext {
  /// Rank/file coordinate labels (a–h, 1–8)
  TextStyle coordinateLabel({Color? color}) => AppTextStyles._base(
    size: responsive(s: 10, l: 11, xxl: 13),
    weight: FontWeight.w500,
    color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
    letterSpacing: 0,
  );

  /// Algebraic notation in move list (e.g. Nf3, O-O)
  TextStyle moveNotationText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 13, l: 14, xxl: 16),
    weight: FontWeight.w500,
    color: color,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0.5,
  );

  /// Move number in the move list (1. 2. 3.)
  TextStyle moveNumberText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 13, l: 14, xxl: 16),
    weight: FontWeight.normal,
    color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0.5,
  );

  /// Evaluation bar score (+1.4, M5, etc.)
  TextStyle evalScoreText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 11, l: 12, xxl: 14),
    weight: FontWeight.w700,
    color: color,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0,
  );

  /// "Check", "Checkmate", "Stalemate" announcements
  TextStyle gameEventText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 16, l: 18, xxl: 22),
    weight: FontWeight.w700,
    color: color ?? Theme.of(this).colorScheme.error,
    letterSpacing: 1.5,
    height: 1.2,
  );
}

// ─────────────────────────────────────────────
// Player & Match Info
// ─────────────────────────────────────────────

extension PlayerTextStyles on BuildContext {
  /// Player display name
  TextStyle playerNameText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 16, l: 18, xxl: 22),
    weight: FontWeight.w600,
    color: color,
  );

  /// Elo / rating number
  TextStyle playerRatingText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 13, l: 14, xxl: 16),
    weight: FontWeight.w500,
    color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0.3,
  );

  /// Captured material count / advantage (+3, +P)
  TextStyle materialAdvantageText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 11, l: 12, xxl: 14),
    weight: FontWeight.w600,
    color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
    letterSpacing: 0.5,
  );

  /// Clock / countdown timer
  TextStyle timerText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 20, l: 22, xxl: 28),
    weight: FontWeight.w600,
    color: color,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0,
  );

  /// Low-time warning state (same shape, distinct usage)
  TextStyle timerLowText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 20, l: 22, xxl: 28),
    weight: FontWeight.w700,
    color: color ?? Theme.of(this).colorScheme.error,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0,
  );

  /// "White to move" / turn strip banner
  TextStyle turnStripText({Color? color}) => AppTextStyles._base(
    size: 14,
    weight: FontWeight.w600,
    color: color ?? Theme.of(this).colorScheme.onPrimary,
    letterSpacing: 1.1,
  );
}

// ─────────────────────────────────────────────
// General Content
// ─────────────────────────────────────────────

extension ContentTextStyles on BuildContext {
  /// Body / paragraph text
  TextStyle mainTextStyle({Color? color}) => AppTextStyles._base(
    size: responsive(s: 14, l: 16, xxl: 18),
    weight: FontWeight.normal,
    color: color,
    height: 1.5,
  );

  /// Section headings inside screens
  TextStyle sectionHeading({Color? color}) => AppTextStyles._base(
    size: responsive(s: 16, l: 18, xxl: 22),
    weight: FontWeight.w700,
    color: color,
    letterSpacing: 0.5,
    height: 1.3,
  );

  /// Captions, timestamps, secondary metadata
  TextStyle captionText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 11, l: 12, xxl: 13),
    weight: FontWeight.normal,
    color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
    height: 1.4,
    letterSpacing: 0.3,
  );

  /// Button labels
  TextStyle buttonText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 14, l: 15, xxl: 17),
    weight: FontWeight.w600,
    color: color,
    letterSpacing: 1.1,
  );

  /// Chip / badge labels
  TextStyle badgeText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 11, l: 12, xxl: 13),
    weight: FontWeight.w600,
    color: color,
    letterSpacing: 0.8,
  );

  /// Empty state messages ("No games yet")
  TextStyle emptyStateText({Color? color}) => AppTextStyles._base(
    size: responsive(s: 14, l: 15, xxl: 17),
    weight: FontWeight.normal,
    color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
    height: 1.6,
    letterSpacing: 0.3,
  );
}
