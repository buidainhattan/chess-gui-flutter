import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InMatchIconButton extends StatelessWidget {
  // Change the type to String for the SVG asset path
  final String svgIconPath;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double buttonSize;
  final double iconToButtonScale;
  final double borderRadius;
  final String? tooltip;

  const InMatchIconButton({
    super.key,
    required this.svgIconPath, // The path to your SVG file (e.g., 'assets/icons/flag_icon.svg')
    required this.onPressed,
    this.backgroundColor = const Color(0xFFD0D0E8),
    this.iconColor = const Color(0xFF3E4158),
    this.buttonSize = 56.0,
    this.iconToButtonScale = 0.5,
    this.borderRadius = 12.0,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: Material(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Center(
              // Use SvgPicture.asset instead of Icon
              child: SvgPicture.asset(
                svgIconPath,
                // Set the color and size for the SVG
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                width: buttonSize * iconToButtonScale,
                height: buttonSize * iconToButtonScale,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
