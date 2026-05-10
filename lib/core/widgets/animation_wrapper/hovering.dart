import 'package:flutter/material.dart';

class HoveringWrapper extends StatefulWidget {
  final Widget child;
  final bool isPersisted;
  final Color? color;
  final BorderRadius? borderRadius;

  const HoveringWrapper({
    super.key,
    required this.child,
    this.isPersisted = false,
    this.color,
    this.borderRadius,
  });

  @override
  State<HoveringWrapper> createState() => _HoveringWrapperState();
}

class _HoveringWrapperState extends State<HoveringWrapper> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color hoveringColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.08);

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: isHovering || widget.isPersisted
                      ? widget.color ?? hoveringColor
                      : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
