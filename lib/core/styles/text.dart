import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Shared Content
// Styles proven to appear across multiple screens.
// Do not add speculatively — promote from screen-specific
// extensions only when actual reuse is confirmed.
// ─────────────────────────────────────────────

extension ContentTextStyles on BuildContext {
  // Big title at the top of any screen (Settings, Profile, About, ...)
  TextStyle screenTitle({Color? color}) =>
      Theme.of(this).textTheme.titleLarge!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      );

  // Header of a panel treated as a content page (e.g. "MOVE HISTORY")
  TextStyle panelTitle({Color? color}) =>
      Theme.of(this).textTheme.labelLarge!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  // Body content inside a panel (e.g. "No moves yet")
  TextStyle panelBodyText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        height: 1.6,
      );

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
  // All button types (filled, outlined, text) and chip labels
  TextStyle menuButtonLabel({Color? color}) =>
      Theme.of(this).textTheme.titleMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  // The broader context switcher above the chip group (dropdown)
  TextStyle menuDropdownLabel({Color? color}) => Theme.of(this)
      .textTheme
      .titleMedium!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);
}

// ─────────────────────────────────────────────
// Settings Screen
// ─────────────────────────────────────────────

extension SettingsTextStyles on BuildContext {
  // Grouped section labels ("Appearance", "Game", ...)
  TextStyle settingsSectionHeader({Color? color}) =>
      Theme.of(this).textTheme.labelLarge!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  // Primary label of each settings row
  TextStyle settingsRowLabel({Color? color}) => Theme.of(this)
      .textTheme
      .titleMedium!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);

  // Secondary descriptive text beneath a settings row label
  TextStyle settingsRowSublabel({Color? color}) => Theme.of(this)
      .textTheme
      .bodySmall!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);

  // Current value displayed in the trailing of a settings row (e.g. "Dark", "Tân")
  TextStyle settingsRowValue({Color? color}) => Theme.of(this)
      .textTheme
      .bodyMedium!
      .copyWith(color: color ?? Theme.of(this).colorScheme.primary);

  // Chip group labels within the settings screen — more compact than menu chips
  TextStyle settingsChipLabel({Color? color}) =>
      Theme.of(this).textTheme.labelMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
}

// ─────────────────────────────────────────────
// Match Screen
// ─────────────────────────────────────────────

// Game Board
extension BoardTextStyles on BuildContext {
  TextStyle coordinateLabel({double? size, Color? color}) =>
      Theme.of(this).textTheme.labelSmall!.copyWith(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
        letterSpacing: 0,
      );

  // Algebraic notation in move list (e.g. Nf3, O-O)
  TextStyle moveNotationText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w500,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0.5,
      );

  // Move number in the move list (1. 2. 3.)
  TextStyle moveNumberText({Color? color}) =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(
        color: color ?? Theme.of(this).colorScheme.onSurfaceVariant,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0.5,
      );

  // "Check", "Checkmate", "Stalemate" announcements
  TextStyle gameEventText({Color? color}) =>
      Theme.of(this).textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(this).colorScheme.error,
        letterSpacing: 1,
      );
}

// Match state info
extension MatchStateTextStyles on BuildContext {
  // Player display name
  TextStyle playerNameText({Color? color}) => Theme.of(this)
      .textTheme
      .bodyMedium!
      .copyWith(fontWeight: FontWeight.bold, color: color, letterSpacing: 0.5);

  // Clock / countdown timer
  TextStyle timerText({Color? color}) =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0.5,
      );

  // Low-time warning state — same shape as timerText, distinct semantic role
  TextStyle timerLowText({Color? color}) =>
      Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(this).colorScheme.error,
        fontFeatures: const [FontFeature.tabularFigures()],
        letterSpacing: 0.5,
      );

  // "White to move" / turn strip banner
  TextStyle turnStripText({Color? color}) =>
      Theme.of(this).textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: color ?? Theme.of(this).colorScheme.onPrimary,
        letterSpacing: 1,
      );
}
