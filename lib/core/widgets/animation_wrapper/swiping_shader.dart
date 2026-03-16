import 'package:flutter/material.dart';

class SwipingShaderWrapper extends StatefulWidget {
  final Widget child;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  const SwipingShaderWrapper({
    super.key,
    required this.child,
    this.activeColor = Colors.blue,
    this.inactiveColor = const Color(0x33FFFFFF),
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<SwipingShaderWrapper> createState() => _SwipingShaderWrapperState();
}

class _SwipingShaderWrapperState extends State<SwipingShaderWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _tailAnimation;
  late final Animation<double> _headAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _tailAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
      ),
    );
    _headAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void didUpdateWidget(SwipingShaderWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double tail = _tailAnimation.value;
        double head = _headAnimation.value;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.inactiveColor,
                widget.activeColor,
                widget.activeColor,
                widget.inactiveColor,
              ],
              stops: [tail, tail, head, head],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}