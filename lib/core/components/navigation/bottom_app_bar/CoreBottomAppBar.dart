import 'package:flutter/material.dart';

class CoreBottomAppBar extends BottomAppBar {
  const CoreBottomAppBar({
    Key? key,

    Color? color,
    double? elevation,
    NotchedShape? shape,
    Clip clipBehavior = Clip.none,
    double notchMargin = 4.0,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? surfaceTintColor,
    Color? shadowColor,
    double? height,
  }) : super (
      key: key,
      color: color,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      notchMargin: notchMargin,
      child: child,
      padding: padding,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      height: height
  );
}
