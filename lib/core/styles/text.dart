import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Navigation & Menus
// ─────────────────────────────────────────────

extension NavigationTextStyles on BuildContext {
  /// Menu navigation items
  TextStyle menuButtonText({Color? color}) =>
      Theme.of(this).textTheme.titleMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
      );

  /// Radio selection items
  TextStyle radioButtonText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(color: color);

  /// Tooltip / contextual hints in menus
  TextStyle menuHintText({Color? color}) =>
      Theme.of(this).textTheme.labelMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
        letterSpacing: 0.2,
      );
}

// ─────────────────────────────────────────────
// Game Board
// ─────────────────────────────────────────────

extension BoardTextStyles on BuildContext {
  /// Rank/file coordinate labels (a–h, 1–8)
  /// [size] should be passed as a fraction of square size (e.g. squareSize * 0.2)
  /// rather than a responsive viewport value, so labels scale with the board.
  TextStyle coordinateLabel({double? size, Color? color}) =>
      Theme.of(this).textTheme.labelSmall!.copyWith(
        fontSize: size, // override only when board-relative size is known
        fontWeight: FontWeight.w500,
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
        letterSpacing: 0,
      );

  /// Algebraic notation in move list (e.g. Nf3, O-O)
  TextStyle moveNotationText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w500,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0.2,
      );

  /// Move number in the move list (1. 2. 3.)
  TextStyle moveNumberText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0.2,
      );

  /// "Check", "Checkmate", "Stalemate" announcements
  TextStyle gameEventText({Color? color}) =>
      Theme.of(this).textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(this).colorScheme.error,
        letterSpacing: 0.5,
      );
}

// ─────────────────────────────────────────────
// Player & Match Info
// ─────────────────────────────────────────────

extension PlayerTextStyles on BuildContext {
  /// Player display name
  TextStyle playerNameText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(color: color);

  /// Captured material count / advantage (+3, +P)
  TextStyle materialAdvantageText({Color? color}) =>
      Theme.of(this).textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
        letterSpacing: 0.3,
      );

  /// Clock / countdown timer
  TextStyle timerText({Color? color}) =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0,
      );

  /// Low-time warning state — same shape as timerText, distinct semantic role
  TextStyle timerLowText({Color? color}) =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(this).colorScheme.error,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0,
      );

  /// "White to move" / turn strip banner
  TextStyle turnStripText({Color? color}) =>
      Theme.of(this).textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: color ?? Theme.of(this).colorScheme.onPrimary,
        letterSpacing: 0.5,
      );
}

// ─────────────────────────────────────────────
// General Content
// ─────────────────────────────────────────────

extension ContentTextStyles on BuildContext {
  TextStyle screenTitle({Color? color}) =>
      Theme.of(this).textTheme.titleLarge!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      );

  TextStyle screenSubtitle({Color? color}) =>
      Theme.of(this).textTheme.titleMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  TextStyle itemLevelOne({
    Color? color,
    FontWeight? fontWeight,
    double? alpha,
  }) => Theme.of(this).textTheme.bodyLarge!.copyWith(
    color: color ?? Theme.of(this).colorScheme.primary.withValues(alpha: alpha),
    fontWeight: fontWeight,
  );

  TextStyle itemLevelTwo({
    Color? color,
    FontWeight? fontWeight,
    double? alpha,
  }) => Theme.of(this).textTheme.bodyMedium!.copyWith(
    color: color ?? Theme.of(this).colorScheme.primary.withValues(alpha: alpha),
    fontWeight: fontWeight,
  );

  TextStyle itemLevelThree({
    Color? color,
    FontWeight? fontWeight,
    double? alpha,
  }) => Theme.of(this).textTheme.bodySmall!.copyWith(
    color: color ?? Theme.of(this).colorScheme.primary.withValues(alpha: alpha),
    fontWeight: fontWeight,
  );

  /// Button labels
  TextStyle buttonText({Color? color}) => Theme.of(this).textTheme.labelLarge!
      .copyWith(fontWeight: FontWeight.w600, color: color, letterSpacing: 0.5);

  /// Chip / badge labels
  TextStyle badgeText({Color? color}) => Theme.of(this).textTheme.labelSmall!
      .copyWith(fontWeight: FontWeight.w600, color: color, letterSpacing: 0.4);

  /// Empty state messages ("No games yet")
  TextStyle emptyStateText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
        height: 1.6,
        letterSpacing: 0.2,
      );
}
