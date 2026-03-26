import 'dart:math' as math;

import 'package:chess_app/core/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundMenu extends StatelessWidget {
  final Widget child;

  const BackgroundMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.1,
            colors: [Colors.white, Colors.grey.shade400],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double size =
                math.min(constraints.maxWidth, constraints.maxHeight) * 0.15;

            return Column(
              children: [
                Expanded(
                  flex: (context.isMobile && context.isLandscape) ? 2 : 1,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildIcon(
                              const Alignment(0, 0),
                              'assets/images/backgrounds/pieces/pawn.svg',
                              size,
                            ),
                            Text(
                              "Chess",
                              style: TextStyle(
                                height: 0.9,
                                fontSize: size,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF32343D),
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
                            color: const Color(0xFF8B7EFE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: (context.isMobile && context.isLandscape) ? 3 : 1,
                  child: child,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildIcon(Alignment alignment, String asset, double size) {
  return Align(
    alignment: alignment,
    child: SvgPicture.asset(asset, width: size),
  );
}
