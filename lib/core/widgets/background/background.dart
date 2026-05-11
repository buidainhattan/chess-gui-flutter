import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1,
            colors: [
              colorScheme.inversePrimary,
              colorScheme.inversePrimary,
              colorScheme.primary,
            ],
            stops: const [0, 0.2, 1],
          ),
        ),
        child: child,
      ),
    );
  }
}
