import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundMenu extends StatelessWidget {
  final Widget child;

  const BackgroundMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size =
            math.min(constraints.maxWidth, constraints.maxHeight) * 0.15;

        final ColorScheme colorScheme = Theme.of(context).colorScheme;

        return Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment(0, 0),
                          child: FutureBuilder<String>(
                            future: _applyPieceColors(
                              "assets/images/backgrounds/pieces/pawn.svg",
                              fill: colorScheme.primary,
                              outline: colorScheme.onPrimaryContainer,
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox(width: size, height: size);
                              }
                              return SvgPicture.string(
                                snapshot.data!,
                                width: size,
                              );
                            },
                          ),
                        ),
                        Text(
                          "Chess",
                          style: TextStyle(
                            height: 0.9,
                            fontSize: size,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Games",
                      style: TextStyle(
                        height: 0.9,
                        fontSize: size,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<String> _applyPieceColors(
  String svgPath, {
  required Color fill,
  required Color outline,
}) async {
  String toHex(Color c) {
    final r = (c.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (c.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (c.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }

  final String svgRaw = await rootBundle.loadString(svgPath);

  return svgRaw
      .replaceAll('var(--piece-fill)', toHex(fill))
      .replaceAll('var(--piece-outline)', toHex(outline));
}
