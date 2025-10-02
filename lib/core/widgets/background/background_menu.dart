import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundMenu extends StatelessWidget {
  final Widget child;

  const BackgroundMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/backgrounds/main_menu_bg.svg",
            fit: BoxFit.fill,
          ),
          child,
        ],
      ),
    );
  }
}
