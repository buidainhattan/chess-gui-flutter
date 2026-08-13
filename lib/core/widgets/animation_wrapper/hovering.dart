import 'package:flutter/material.dart';

class HoveringWrapper extends StatefulWidget {
  final Widget child;
  final bool isPersisted;
  final bool enabled;
  final Color? color;
  final BorderRadius? borderRadius;

  const HoveringWrapper({
    super.key,
    required this.child,
    this.isPersisted = false,
    this.enabled = true,
    this.color,
    this.borderRadius,
  });

  @override
  State<HoveringWrapper> createState() => _HoveringWrapperState();
}

class _HoveringWrapperState extends State<HoveringWrapper> {
  bool isHovering = false;

  @override
  void didUpdateWidget(HoveringWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled && !widget.enabled && isHovering) {
      setState(() {
        isHovering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color hoveringColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.08);

    return MouseRegion(
      onEnter: (event) {
        if (!widget.enabled) return;
        setState(() {
          isHovering = true;
        });
      },
      onExit: (event) {
        if (!widget.enabled) return;
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
                  color: widget.enabled && (isHovering || widget.isPersisted)
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
