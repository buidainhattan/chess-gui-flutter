import 'package:flutter/material.dart';

class BackgroundMatch extends StatelessWidget {
  final Widget child;

  const BackgroundMatch({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
        ],
      ),
    );
  }
}
