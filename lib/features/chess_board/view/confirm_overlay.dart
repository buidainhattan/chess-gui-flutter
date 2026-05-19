import 'dart:async';

import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/animation_wrapper/hovering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: "move confirm overlay")
Widget confirmPreview() {
  const int squareIndex = 44;
  const double size = 350;
  return Center(
    child: SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: (squareIndex % 8) * (size / 8),
            top: (size - (((squareIndex ~/ 8) + 1) * (size / 8))),
            child: Container(
              width: size / 8,
              height: size / 8,
              color: Colors.brown.shade400,
              child: const Center(
                child: Text("♞", style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
          Positioned.fill(
            child: ConfirmOverlay(
              squareIndex: squareIndex,
              boardSize: size,
              confirmCompleter: Completer(),
            ),
          ),
        ],
      ),
    ),
  );
}

class ConfirmOverlay extends StatelessWidget {
  final int squareIndex;
  final double boardSize;
  final Completer<bool> confirmCompleter;

  const ConfirmOverlay({
    super.key,
    required this.squareIndex,
    required this.boardSize,
    required this.confirmCompleter,
  });

  @override
  Widget build(BuildContext context) {
    final double squareSize = boardSize / 8;

    final int file = squareIndex % 8;
    final int rank = squareIndex ~/ 8;

    final double left = file * squareSize;
    final double squareTop = boardSize - ((rank + 1) * squareSize);

    final double top = squareTop - 20;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color textColor = colorScheme.onSurfaceVariant;

    return Stack(
      children: [
        // Clickable Dim Blocker
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => confirmCompleter.complete(false),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
        ),

        // Floating Action Framework (Hollow center)
        Positioned(
          left: left,
          top: top,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Move?",
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
              const SizedBox(height: 4),

              SizedBox(
                width: squareSize,
                height: squareSize + AppTheme.spaceXS,
              ),

              Container(
                width: squareSize,
                color: Colors.transparent,
                child: Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: HoveringWrapper(
                        child: Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => confirmCompleter.complete(false),
                            child: SizedBox(
                              height: squareSize * 0.5,
                              child: Icon(
                                Icons.close,
                                color: colorScheme.error,
                                size: squareSize * 0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Confirm Button
                    Expanded(
                      child: HoveringWrapper(
                        child: Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => confirmCompleter.complete(true),
                            child: SizedBox(
                              height: squareSize * 0.5,
                              child: Icon(
                                Icons.check,
                                color: Colors.lightGreen,
                                size: squareSize * 0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
