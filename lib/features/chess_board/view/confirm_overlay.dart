import 'dart:async';

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
            ),
          ),
          Positioned.fill(
            child: ConfirmOverlay(
              squareIndex: squareIndex,
              boardSize: size,
              confirmCompleter: Completer(),
              // Pass the piece here to be highlighted above the dim overlay
              pieceWidget: const Center(
                child: Text("♞", style: TextStyle(fontSize: 24)),
              ),
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
  final Widget pieceWidget;

  const ConfirmOverlay({
    super.key,
    required this.squareIndex,
    required this.boardSize,
    required this.confirmCompleter,
    required this.pieceWidget,
  });

  @override
  Widget build(BuildContext context) {
    final double squareSize = boardSize / 8;

    final int file = squareIndex % 8;
    final int rank = squareIndex ~/ 8;

    final double left = file * squareSize;
    final double squareTop = boardSize - ((rank + 1) * squareSize);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color textColor = colorScheme.onPrimary;

    return Stack(
      children: [
        // 1. Clickable Dim Blocker
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => confirmCompleter.complete(false),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
        ),

        // 2. The Highlighted Piece (Placed EXACTLY over the board square)
        Positioned(
          left: left,
          top: squareTop,
          width: squareSize,
          height: squareSize,
          child: Center(child: pieceWidget),
        ),

        // 3. UI Prompts (Positioned relative to the square to avoid shifting the piece)
        Positioned(
          left: left,
          top: squareTop - 24, // Placed strictly above the square
          width: squareSize,
          child: Center(
            child: Text(
              "Move?",
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
              ),
            ),
          ),
        ),

        Positioned(
          left: left,
          top: squareTop + squareSize + 4, // Placed strictly below the square
          width: squareSize,
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
    );
  }
}
