import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Shared Content
// Styles proven to appear across multiple screens.
// Do not add speculatively — promote from screen-specific
// extensions only when actual reuse is confirmed.
// ─────────────────────────────────────────────

extension ContentTextStyles on BuildContext {
  // Big title describing a screen
  TextStyle screenTitle({Color? color}) =>
      Theme.of(this).textTheme.titleLarge!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      );

  // Header of a panel
  TextStyle panelTitle({Color? color}) =>
      Theme.of(this).textTheme.labelLarge!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  // Body content inside a panel
  TextStyle panelBodyText({Color? color}) => Theme.of(this)
      .textTheme
      .bodyMedium!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);

  // Small badge text
  TextStyle badgeText({Color? color}) =>
      Theme.of(this).textTheme.labelSmall!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
}

// ─────────────────────────────────────────────
// Menu & Navigation
// ─────────────────────────────────────────────

extension MenuTextStyles on BuildContext {
  // Consistent menu level text style
  TextStyle menuLabel({Color? color}) =>
      Theme.of(this).textTheme.titleMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );
}

// ─────────────────────────────────────────────
// Settings Screen
// ─────────────────────────────────────────────

extension SettingTextStyles on BuildContext {
  // Section grouping text
  TextStyle settingSectionHeader({Color? color}) =>
      Theme.of(this).textTheme.labelLarge!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  // Main label
  TextStyle settingRowLabel({Color? color}) => Theme.of(this)
      .textTheme
      .titleMedium!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);

  // Descriptive label
  TextStyle settingowSublabel({Color? color}) => Theme.of(this)
      .textTheme
      .bodySmall!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);

  // Raw value
  TextStyle settingRowValue({Color? color}) => Theme.of(this)
      .textTheme
      .bodyMedium!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);

  // Chip group label
  TextStyle settingChipLabel({Color? color}) =>
      Theme.of(this).textTheme.labelMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
}

// ─────────────────────────────────────────────
// Match Screen
// ─────────────────────────────────────────────

extension MatchTextStyles on BuildContext {
  TextStyle matchCoordinateLabel({double? size, Color? color}) =>
      Theme.of(this).textTheme.labelSmall!.copyWith(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
      );

  // Algebraic notation in move list (e.g. Nf3, O-O)
  TextStyle matchMoveDisplayText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w500,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0.5,
      );

  // "Check", "Checkmate", "Stalemate" announcements
  TextStyle matchEventText({Color? color}) =>
      Theme.of(this).textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(this).colorScheme.error,
        letterSpacing: 1,
      );

  // Player display name
  TextStyle matchPlayerNameText({Color? color}) => Theme.of(this)
      .textTheme
      .bodyMedium!
      .copyWith(fontWeight: FontWeight.bold, color: color, letterSpacing: 0.5);

  // Clock / countdown timer
  TextStyle matchTimerText({Color? color}) =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // "White to move" / turn strip banner
  TextStyle matchTurnStripText({Color? color}) =>
      Theme.of(this).textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: color ?? Theme.of(this).colorScheme.onPrimary,
        letterSpacing: 1,
      );
}
