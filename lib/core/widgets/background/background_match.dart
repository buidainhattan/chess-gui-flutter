import 'package:flutter/material.dart';

class BackgroundMatch extends StatelessWidget {
  final Widget child;

  const BackgroundMatch({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.1,
                colors: [Colors.white, Colors.grey.shade400],
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
