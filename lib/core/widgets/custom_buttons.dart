import 'package:chess_app/core/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

/// The main navigation target
class PrimaryNavButton extends StatelessWidget {
  final String label;
  final String? route;
  final VoidCallback? onPressed;

  const PrimaryNavButton({
    super.key,
    required this.label,
    this.route,
    this.onPressed,
  }) : assert(
         route == null || onPressed == null,
         "Only either route or onPressed can be provided!",
       );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 250,
      height: 50,
      child: FilledButton(
        onPressed: route != null ? () => context.push(route!) : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: const StadiumBorder(),
        ),
        child: Text(
          label,
          style: context.menuText(color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}

/// Important but alternative navigation
class SecondaryNavButton extends StatelessWidget {
  final String label;
  final String? route;
  final VoidCallback? onPressed;

  const SecondaryNavButton({
    super.key,
    required this.label,
    this.route,
    this.onPressed,
  }) : assert(
         route == null || onPressed == null,
         "Only either route or onPressed can be provided!",
       );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 250,
      height: 50,
      child: OutlinedButton(
        onPressed: route != null ? () => context.push(route!) : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary, width: 2),
          shape: const StadiumBorder(),
        ),
        child: Text(label, style: context.menuText(color: colorScheme.primary)),
      ),
    );
  }
}

/// Utility navigation
class TertiaryNavButton extends StatelessWidget {
  final String label;
  final Color? color;
  final String? route;
  final VoidCallback? onPressed;

  const TertiaryNavButton({
    super.key,
    required this.label,
    this.color,
    this.route,
    this.onPressed,
  }) : assert(
         route == null || onPressed == null,
         "Only either route or onPressed can be provided!",
       );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: route != null ? () => context.push(route!) : onPressed,
      child: Text(
        label,
        style: context.menuText(color: color ?? colorScheme.primary),
      ),
    );
  }
}

/// Destructive (such as exit or delete actions)
class DestructiveButton extends StatelessWidget {
  final String label;
  final String? route;
  final VoidCallback? onPressed;

  const DestructiveButton({
    super.key,
    required this.label,
    this.route,
    this.onPressed,
  }) : assert(
         route == null || onPressed == null,
         "Only either route or onPressed can be provided!",
       );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: route != null ? () => context.push(route!) : onPressed,
      child: Text(label, style: context.menuText(color: colorScheme.error)),
    );
  }
}

class SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const SelectableButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return isSelected
        ? FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: const StadiumBorder(),
            ),
            child: Text(label, style: context.selectionText()),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.primary),
              shape: const StadiumBorder(),
            ),
            child: Text(
              label,
              style: context.selectionText(color: colorScheme.primary),
            ),
          );
  }
}

class BarButton extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final String label;
  final String tooltip;
  final Decoration? decoration;
  final VoidCallback onPressed;

  const BarButton({
    super.key,
    this.icon,
    this.svgPath,
    required this.label,
    this.tooltip = "",
    this.decoration,
    required this.onPressed,
  }) : assert(
         (icon == null) != (svgPath == null),
         "Only either icon or svgPath can be provided!",
       );

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: decoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null
                    ? Icon(icon)
                    : SvgPicture.asset(svgPath!, width: 15, height: 15),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
