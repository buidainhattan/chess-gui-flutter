import 'package:chess_app/core/styles/theme.dart';
import 'package:flutter/material.dart';

class MenuLayout extends StatelessWidget {
  final List<Widget> children;

  const MenuLayout({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppTheme.spaceM,
      children: children,
    );
  }
}
