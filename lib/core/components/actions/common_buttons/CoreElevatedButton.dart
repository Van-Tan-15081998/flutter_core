import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreButtonStyle.dart';

import '../../../../app/library/common/utils/CommonAudioOnPressButton.dart';

class CoreElevatedButton extends ElevatedButton {

  ButtonStyle? style;

  CoreElevatedButton({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    MaterialStatesController? statesController,
    required Widget child,

    required CoreButtonStyle coreButtonStyle,
  })
      : style = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitForegroundColor),
      backgroundColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitBackgroundColor),
      overlayColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitOverlayColor),
      shadowColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitShadowColor),
      elevation: MaterialStateProperty.all(coreButtonStyle.kitElevation),
      padding: MaterialStateProperty.all(coreButtonStyle.kitPaddingLTRB),
      textStyle: MaterialStateProperty.all(
        TextStyle(fontSize: coreButtonStyle.kitFontSize),
      ),
      fixedSize: MaterialStateProperty.all(Size.fromHeight(coreButtonStyle.kitHeight)),
      
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(coreButtonStyle.kitRadius)),
          side: BorderSide(color: coreButtonStyle.kitBorderColor))
      )
  ),
        super(
        key: key,
        onPressed: () {
          CommonAudioOnPressButton audio = CommonAudioOnPressButton();
          audio.playAudioOnPress().then((value) {
            if(value) {
              onPressed!();
            }
          });
        },
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: child,
      );

  CoreElevatedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    MaterialStatesController? statesController,

    required Widget icon,
    required Widget label,

    Color kitForegroundColor = Colors.black,
    Color kitBorderColor = Colors.black,
    Color kitOverlayColor = Colors.black45,
    Color kitBackgroundColor = Colors.white,
    Color kitShadowColor = Colors.black,

    required CoreButtonStyle coreButtonStyle,
  })
      : style = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitForegroundColor),
      backgroundColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitBackgroundColor),
      overlayColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitOverlayColor),
      shadowColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitShadowColor),
      elevation: MaterialStateProperty.all(coreButtonStyle.kitElevation),
      padding: MaterialStateProperty.all(coreButtonStyle.kitPaddingLTRB),
      textStyle: MaterialStateProperty.all(
        TextStyle(fontSize: coreButtonStyle.kitFontSize),
      ),
      fixedSize: MaterialStateProperty.all(Size.fromHeight(coreButtonStyle.kitHeight)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(coreButtonStyle.kitRadius)),
          side: BorderSide(color: coreButtonStyle.kitBorderColor ?? kitBorderColor)))),
        super(
        key: key,
        onPressed: () {
          CommonAudioOnPressButton audio = CommonAudioOnPressButton();
          audio.playAudioOnPress().then((value) {
            if(value) {
              onPressed!();
            }
          });
        },
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: _ElevatedButtonWithIconChild(icon: icon, label: label, kitGap: coreButtonStyle.kitGap,),
      );

  ButtonStyle _buttonStyle(Color kitForegroundColor,
      Color kitBorderColor,
      Color kitOverlayColor,
      Color kitBackgroundColor,
      Color kitShadowColor,
      double kitElevation,
      double kitPadding,
      double kitRadius) {
    return ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color?>(kitForegroundColor),
        backgroundColor: MaterialStateProperty.all<Color?>(kitBackgroundColor),
        overlayColor: MaterialStateProperty.all<Color?>(kitOverlayColor),
        shadowColor: MaterialStateProperty.all<Color?>(kitShadowColor),
        elevation: MaterialStateProperty.all(kitElevation),
        padding: MaterialStateProperty.all(EdgeInsets.all(kitPadding)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kitRadius)),
            side: BorderSide(color: kitBorderColor))));
  }

  CoreElevatedButton.iconOnly({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    MaterialStatesController? statesController,

    required Widget icon,

    Color kitForegroundColor = Colors.black,
    Color kitBorderColor = Colors.black,
    Color kitOverlayColor = Colors.black45,
    Color kitBackgroundColor = Colors.white,
    Color kitShadowColor = Colors.black,

    required CoreButtonStyle coreButtonStyle,
  })
      : style = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitForegroundColor),
      backgroundColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitBackgroundColor),
      overlayColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitOverlayColor),
      shadowColor: MaterialStateProperty.all<Color?>(coreButtonStyle.kitShadowColor),
      elevation: MaterialStateProperty.all(coreButtonStyle.kitElevation),
      padding: MaterialStateProperty.all(coreButtonStyle.kitPaddingLTRB),
      textStyle: MaterialStateProperty.all(
        TextStyle(fontSize: coreButtonStyle.kitFontSize),
      ),
      // fixedSize: MaterialStateProperty.all(Size.fromHeight(coreButtonStyle.kitHeight)),
      minimumSize: coreButtonStyle.kitMinimumSize != const Size(0.0, 0.0) ? MaterialStateProperty.all<Size>(
        coreButtonStyle.kitMinimumSize, // Đặt kích thước tối thiểu cho nút
      ) : null,
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(coreButtonStyle.kitRadius)),
          side: BorderSide(color: coreButtonStyle.kitBorderColor ?? kitBorderColor)))),
        super(
        key: key,
        onPressed: () {
          CommonAudioOnPressButton audio = CommonAudioOnPressButton();
          audio.playAudioOnPress().then((value) {
            if(value) {
              onPressed!();
            }
          });
        },
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: _ElevatedButtonWithIconChildOnly(icon: icon),
      );
}

class _ElevatedButtonWithIconChild extends StatelessWidget {
  const _ElevatedButtonWithIconChild({ required this.label, required this.icon, required this.kitGap });

  final Widget label;
  final Widget icon;
  final double kitGap;

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.textScaleFactorOf(context);
    /**
     * MediaQuery.textScaleFactorOf(context) được sử dụng để lấy tỷ lệ hiện tại của văn bản trong thiết bị của bạn.
     * Điều này quan trọng để điều chỉnh khoảng cách giữa các thành phần dựa trên tỷ lệ văn bản.
     */

    /**
     * scale lưu trữ tỷ lệ văn bản, và gap là khoảng cách mong muốn giữa biểu tượng và văn bản.
     * Nếu tỷ lệ văn bản là 1 hoặc nhỏ hơn (hoặc nếu không thể lerpDouble), thì gap sẽ là 8, ngược lại, nó sẽ là một giá trị được tính toán dựa trên tỷ lệ.
     */

    // final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, SizedBox(width: kitGap), Flexible(child: label)],
    );
    /**
     * mainAxisSize: MainAxisSize.min cho biết rằng chiều dài của Row sẽ được thu nhỏ xuống tối thiểu để vừa với nội dung của nó.
     * */
  }
}

class _ElevatedButtonWithIconChildOnly extends StatelessWidget {
  const _ElevatedButtonWithIconChildOnly({ required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {

    // final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
    return icon;
    /**
     * mainAxisSize: MainAxisSize.min cho biết rằng chiều dài của Row sẽ được thu nhỏ xuống tối thiểu để vừa với nội dung của nó.
     * */
  }
}
