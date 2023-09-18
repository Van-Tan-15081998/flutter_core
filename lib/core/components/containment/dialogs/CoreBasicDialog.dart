import 'package:flutter/material.dart';

class CoreBasicDialog extends Dialog {

  const CoreBasicDialog({
    Key? key,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Duration insetAnimationDuration = const Duration(milliseconds: 100),
    Curve insetAnimationCurve = Curves.decelerate,
    EdgeInsets insetPadding =
    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    Clip clipBehavior = Clip.none,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    Widget? child,
  }) :
        super(
        key: key,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        insetAnimationDuration: insetAnimationDuration,
        insetAnimationCurve: insetAnimationCurve,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior,
        shape: shape,
        alignment: alignment,
        child: child,
      );
}