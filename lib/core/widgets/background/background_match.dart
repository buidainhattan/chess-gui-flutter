import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundMatch extends StatelessWidget {
  final Widget child;

  const BackgroundMatch({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/backgrounds/match_bg.svg",
            fit: BoxFit.fill,
          ),
          child,
        ],
      ),
    );
  }
}
