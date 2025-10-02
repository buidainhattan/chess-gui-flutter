import 'package:flutter/widgets.dart';

class AppTextStyles {
  static TextStyle menu({Color? color, double? screenWidth}) => TextStyle(
    fontSize: screenWidth != null ? screenWidth > 1472 ? 36 : 24 : 36,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w500,
    color: color,
  );
}
