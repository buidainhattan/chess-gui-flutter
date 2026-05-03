import 'package:flutter/material.dart';

class SlidingWrapper extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final AxisDirection direction;
  final Curve curve;

  const SlidingWrapper({
    super.key,
    required this.child,
    required this.controller,
    this.direction = AxisDirection.up,
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: controller, curve: curve);
    final isHorizontal =
        direction == AxisDirection.left || direction == AxisDirection.right;

    final slideAnimation = Tween<Offset>(
      begin: _getSlideOffset(),
      end: Offset.zero,
    ).animate(animation);

    return ClipRect(
      child: SizeTransition(
        sizeFactor: animation,
        axis: isHorizontal ? Axis.horizontal : Axis.vertical,
        axisAlignment: _getAxisAlignment(),
        child: SlideTransition(position: slideAnimation, child: child),
      ),
    );
  }

  Offset _getSlideOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1); // Slide from bottom
      case AxisDirection.down:
        return const Offset(0, -1); // Slide from top
      case AxisDirection.left:
        return const Offset(1, 0); // Slide from right
      case AxisDirection.right:
        return const Offset(-1, 0); // Slide from left
    }
  }

  double _getAxisAlignment() {
    switch (direction) {
      case AxisDirection.up:
        return 1.0;
      case AxisDirection.down:
        return -1.0;
      case AxisDirection.left:
        return 1.0;
      case AxisDirection.right:
        return -1.0;
    }
  }
}
