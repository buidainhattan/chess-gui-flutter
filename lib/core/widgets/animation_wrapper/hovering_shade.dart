import 'package:flutter/material.dart';

class HoveringWrapper extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final bool isPersisted;

  const HoveringWrapper({
    super.key,
    required this.child,
    this.borderRadius,
    this.isPersisted = false,
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
            Center(child: widget.child),
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: isHovering || widget.isPersisted
                      ? hoveringColor
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
