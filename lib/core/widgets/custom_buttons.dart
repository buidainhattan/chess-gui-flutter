import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MenuNavButton extends StatelessWidget {
  final String label;
  final String route;
  final VoidCallback? onPressed;
  final Color? textColor;

  const MenuNavButton({
    super.key,
    required this.label,
    this.route = "",
    this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:
          onPressed ??
          () {
            if (route.isNotEmpty) {
              context.push(route);
            }
          },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spaceS,
          vertical: AppTheme.spaceS,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: context.menuText(color: textColor)),
    );
  }
}

class BarButton extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isDanger;

  const BarButton({
    super.key,
    this.icon,
    this.svgPath,
    required this.label,
    this.tooltip = "",
    required this.onPressed,
    this.isDanger = false,
  }) : assert(
         (icon == null) != (svgPath == null),
         "Only either icon or svgPath can be provided!",
       );

  @override
  Widget build(BuildContext context) {
    final Color fg = isDanger
        ? const Color(0xFFC0392B)
        : AppCustomColors.textMid;
    final Color hoverBg = isDanger
        ? const Color(0xFFFDF1F0)
        : AppCustomColors.activeBg;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        hoverColor: hoverBg,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppCustomColors.border),
            borderRadius: BorderRadius.circular(4),
            color: AppCustomColors.surface,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon != null
                  ? Icon(icon)
                  : SvgPicture.asset(
                      svgPath!,
                      width: 15,
                      height: 15,
                      colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
                    ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
