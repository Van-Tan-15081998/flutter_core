import 'package:flutter/material.dart';

enum CoreStyle {
  elevated,
  filled,
  filledTonal,
  outlined,
  text
}
enum CoreRadius {radius_0, radius_2, radius_6, radius_24}
enum CoreColor {
  turtles,
  stormi,
  slate,
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
  link
}

enum CoreFixedSizeButton {
  squareIcon2020,
  squareIcon2030,
  squareIcon2040,

  squareIcon3030,
  squareIcon3040,
  squareIcon3050,

  squareIcon4040,
  squareIcon4050,
  squareIcon4060,

  squareIcon5050,
  squareIcon5060,
  squareIcon5070,

  squareIcon6060,
  squareIcon6070,
  squareIcon6080,

  small_32,
  small_40,
  medium_40,
  medium_48,
  large_52,
  large_56
}




class CoreButtonStyle {
  late Color? kitForegroundColor;
  late Color  kitBorderColor = const Color(0xff333333);
  late Color? kitOverlayColor;
  late Color? kitBackgroundColor;
  late Color? kitShadowColor;

  late double? kitElevation;

  late double? kitFontSize;

  late double  kitRadius = 0;

  // For fixed size
  late double kitWidth = 0;
  late double kitHeight = 0;
  late double kitGap = 0;
  late EdgeInsets kitPaddingLTRB = const EdgeInsets.all(0);

  late Size kitMinimumSize = const Size(0.0, 0.0);

  CoreButtonStyle({
    this.kitForegroundColor = Colors.black,
    this.kitBorderColor = Colors.black,
    this.kitOverlayColor = Colors.black45,
    this.kitBackgroundColor = Colors.white,
    this.kitShadowColor = Colors.black,

    this.kitElevation = 0,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,

    this.kitMinimumSize = const Size(0.0, 0.0)
});

  CoreButtonStyle.styleStandard({
    this.kitForegroundColor = const Color(0xff000000),
    this.kitBorderColor = const Color(0xff333333),
    this.kitOverlayColor = const Color(0xff5B8291),
    this.kitBackgroundColor = const Color(0xffffffff),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 5,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });

  CoreButtonStyle.options({
    required CoreStyle coreStyle,
    required CoreColor coreColor,

    CoreRadius? coreRadius,
    CoreFixedSizeButton? coreFixedSizeButton,

    Color? kitForegroundColorOption,
    Color? kitBorderColorOption,
    Color? kitOverlayColorOption,
    Color? kitBackgroundColorOption,
    Color? kitShadowColorOption,

    double? kitElevationOption,

    double? kitFontSizeOption,

    double? kitRadiusOption,

    // For fixed size
    double? kitHeightOption,
    double? kitWidthOption,
    double? kitGapOption,
    EdgeInsets? kitPaddingLTRBOption,

    Size? kitMinimumSizeOption,
  }) {

    CoreButtonStyle coreButtonStyle = CoreButtonStyle();

    switch (coreColor) {
      case CoreColor.turtles : {
        coreButtonStyle = CoreButtonStyle.turtles();
        break;
      }
      case CoreColor.stormi : {
        coreButtonStyle = CoreButtonStyle.stormi();
        break;
      }
      case CoreColor.slate : {
        coreButtonStyle = CoreButtonStyle.slate();
        break;
      }
      case CoreColor.primary : {
        coreButtonStyle = CoreButtonStyle.primary();
        break;
      }
      case CoreColor.secondary : {
        coreButtonStyle = CoreButtonStyle.secondary();
        break;
      }
      case CoreColor.success : {
        coreButtonStyle = CoreButtonStyle.success();
        break;
      }
      case CoreColor.danger : {
        coreButtonStyle = CoreButtonStyle.danger();
        break;
      }
      case CoreColor.warning : {
        coreButtonStyle = CoreButtonStyle.warning();
        break;
      }case CoreColor.info : {
      coreButtonStyle = CoreButtonStyle.info();
      break;
    }
    case CoreColor.light : {
      coreButtonStyle = CoreButtonStyle.light();
    break;
    }
    case CoreColor.dark : {
      coreButtonStyle = CoreButtonStyle.dark();
    break;
    }
    case CoreColor.link : {
      coreButtonStyle = CoreButtonStyle.link();
    break;
    }

      default: {
        //statements;
      }
    }

    _getAttributesFromStyle(coreButtonStyle);

    switch (coreStyle) {
      case CoreStyle.elevated : {
        _setColorFromStyle(CoreStyle.elevated);
        break;
      }
      case CoreStyle.filled : {
        _setColorFromStyle(CoreStyle.filled);
        break;
      }
      case CoreStyle.filledTonal : {
        _setColorFromStyle(CoreStyle.filledTonal);
        break;
      }
      case CoreStyle.outlined : {
        _setColorFromStyle(CoreStyle.outlined);
        break;
      }
      case CoreStyle.text : {
        _setColorFromStyle(CoreStyle.text);
        break;
      }

      default: {
        //statements;
      }
    }

    switch (coreRadius) {
      case CoreRadius.radius_0 : {
        kitRadius = 0;
        break;
      }
      case CoreRadius.radius_2 : {
        kitRadius = 2;
        break;
      }
      case CoreRadius.radius_6 : {
        kitRadius = 6;
        break;
      }
      case CoreRadius.radius_24 : {
        kitRadius = 24;
        break;
      }

      default: {
        //statements;
      }
    }

    switch (coreFixedSizeButton) {
      case CoreFixedSizeButton.squareIcon2020 : {
        kitHeight = 20;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(20, 20);
        break;
      }
      case CoreFixedSizeButton.squareIcon2030 : {
        kitHeight = 20;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(30, 20);
        break;
      }
      case CoreFixedSizeButton.squareIcon2040 : {
        kitHeight = 20;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(40, 20);
        break;
      }

      case CoreFixedSizeButton.squareIcon3030 : {
        kitHeight = 30;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(30, 30);
        break;
      }
      case CoreFixedSizeButton.squareIcon3040 : {
        kitHeight = 30;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(40, 30);
        break;
      }
      case CoreFixedSizeButton.squareIcon3050 : {
        kitHeight = 30;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(50, 30);
        break;
      }

      case CoreFixedSizeButton.squareIcon4040 : {
        kitHeight = 40;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(40, 40);
        break;
      }
      case CoreFixedSizeButton.squareIcon4050 : {
        kitHeight = 40;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(50, 40);
        break;
      }
      case CoreFixedSizeButton.squareIcon4060 : {
        kitHeight = 40;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(60, 40);
        break;
      }

      case CoreFixedSizeButton.squareIcon5050 : {
        kitHeight = 50;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(50, 50);
        break;
      }
      case CoreFixedSizeButton.squareIcon5060 : {
        kitHeight = 50;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(60, 50);
        break;
      }
      case CoreFixedSizeButton.squareIcon5070 : {
        kitHeight = 50;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(70, 50);
        break;
      }

      case CoreFixedSizeButton.squareIcon6060 : {
        kitHeight = 60;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(60, 60);
        break;
      }
      case CoreFixedSizeButton.squareIcon6070 : {
        kitHeight = 60;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(70, 60);
        break;
      }
      case CoreFixedSizeButton.squareIcon6080 : {
        kitHeight = 60;
        kitPaddingLTRB = const EdgeInsets.all(0);
        kitMinimumSizeOption = const Size(80, 60);
        break;
      }

      case CoreFixedSizeButton.small_32 : {
        kitHeight = 30;
        kitGap = 4;
        kitFontSize = 12;
        kitPaddingLTRB = const EdgeInsets.fromLTRB(14, 6, 14, 6);
        break;
      }
      case CoreFixedSizeButton.small_40 : {
        kitHeight = 40;
        kitGap = 4;
        kitFontSize = 12;
        kitPaddingLTRB = const EdgeInsets.fromLTRB(14, 6, 14, 6);
        break;
      }
      case CoreFixedSizeButton.medium_40 : {
        kitHeight = 40;
        kitGap = 8;
        kitFontSize = 14;
        kitPaddingLTRB = const EdgeInsets.fromLTRB(16, 10, 16, 10);
        break;
      }
      case CoreFixedSizeButton.medium_48 : {
        kitHeight = 48;
        kitGap = 8;
        kitFontSize = 14;
        kitPaddingLTRB = const EdgeInsets.fromLTRB(16, 10, 16, 10);
        break;
      }
      case CoreFixedSizeButton.large_52 : {
        kitHeight = 52;
        kitGap = 8;
        kitFontSize = 16;
        kitPaddingLTRB = const EdgeInsets.fromLTRB(24, 16, 24, 16);
        break;
      }
      case CoreFixedSizeButton.large_56 : {
        kitHeight = 56;
        kitGap = 8;
        kitFontSize = 16;
        kitPaddingLTRB = const EdgeInsets.fromLTRB(24, 16, 24, 16);
        break;
      }

      default: {
        //statements;
      }
    }

    kitForegroundColor = kitForegroundColorOption ?? kitForegroundColor;
    kitBorderColor = kitBorderColorOption ?? kitBorderColor;
    kitOverlayColor = kitOverlayColorOption ?? kitOverlayColor;
    kitBackgroundColor = kitBackgroundColorOption ?? kitBackgroundColor;
    kitShadowColor = kitShadowColorOption ?? kitShadowColor;

    kitElevation = kitElevationOption ?? kitElevation;
    kitPaddingLTRB = kitPaddingLTRBOption ?? kitPaddingLTRB;

    kitFontSize = kitFontSizeOption ?? kitFontSize;

    kitRadius = kitRadiusOption ?? kitRadius;

    kitWidth = kitWidthOption ?? kitWidth;

    if(kitMinimumSizeOption != const Size(0.0, 0.0)) {
      kitMinimumSize = kitMinimumSizeOption ?? kitMinimumSize;
    }

  }

  _getAttributesFromStyle(CoreButtonStyle coreButtonStyle) {
    kitForegroundColor = coreButtonStyle.kitForegroundColor;
    kitBorderColor = coreButtonStyle.kitBorderColor;
    kitOverlayColor = coreButtonStyle.kitOverlayColor;
    kitBackgroundColor = coreButtonStyle.kitBackgroundColor;
    kitShadowColor = coreButtonStyle.kitShadowColor;

    kitElevation = coreButtonStyle.kitElevation;
    kitPaddingLTRB = coreButtonStyle.kitPaddingLTRB;

    kitFontSize = coreButtonStyle.kitFontSize;

    kitRadius = coreButtonStyle.kitRadius;
  }

  _setColorFromStyle(CoreStyle coreStyle) {
    switch (coreStyle) {
      case CoreStyle.elevated : {
        kitForegroundColor = null;
        kitBorderColor = Colors.transparent;
        kitOverlayColor = null;
        kitBackgroundColor = null;
        kitShadowColor = null;
        break;
      }
      case CoreStyle.filled : {
        kitForegroundColor = kitForegroundColor;
        kitBorderColor = kitBorderColor;
        kitOverlayColor = kitOverlayColor;
        kitBackgroundColor = kitBackgroundColor;
        kitShadowColor = kitShadowColor;
        break;
      }
      case CoreStyle.filledTonal : {
        kitForegroundColor = kitForegroundColor;
        kitBorderColor = kitBorderColor;
        kitOverlayColor = kitOverlayColor;
        kitBackgroundColor = kitOverlayColor;
        kitShadowColor = kitShadowColor;
        break;
      }
      case CoreStyle.outlined : {
        kitForegroundColor = kitBorderColor;
        kitBorderColor = kitBorderColor;
        kitOverlayColor = kitOverlayColor;
        kitBackgroundColor = const Color(0xffffffff);
        kitShadowColor = kitShadowColor;
        break;
      }
      case CoreStyle.text : {
        kitForegroundColor = kitForegroundColor;
        kitBorderColor = kitBorderColor;
        kitOverlayColor = kitOverlayColor;
        kitBackgroundColor = kitBackgroundColor;
        kitShadowColor = kitShadowColor;
        break;
      }

      default: {
        //statements;
      }
    }
  }

  CoreButtonStyle.turtles({
    this.kitForegroundColor = const Color(0xffffffff),
    this.kitBorderColor = const Color(0xff46A094),
    this.kitOverlayColor = const Color(0xff9bc1bc),
    this.kitBackgroundColor = const Color(0xff46A094),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 2,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });

  CoreButtonStyle.stormi({
    this.kitForegroundColor = const Color(0xffffffff),
    this.kitBorderColor = const Color(0xff3B7197),
    this.kitOverlayColor = const Color(0xff97adbd),
    this.kitBackgroundColor = const Color(0xff3B7197),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 2,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });
  //
  CoreButtonStyle.slate({
    this.kitForegroundColor = const Color(0xffffffff),
    this.kitBorderColor = const Color(0xff2E424D),
    this.kitOverlayColor = const Color(0xff919a9e),
    this.kitBackgroundColor = const Color(0xff2E424D),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 2,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });

  CoreButtonStyle.primary({
    this.kitForegroundColor = const Color(0xffffffff),
    this.kitBorderColor = const Color(0xff007bff),
    this.kitOverlayColor = const Color(0xff7eb1e8),
    this.kitBackgroundColor = const Color(0xff007bff),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 2,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });

  CoreButtonStyle.secondary({
    this.kitForegroundColor = const Color(0xffffffff),
    this.kitBorderColor = const Color(0xff6c757d),
    this.kitOverlayColor = const Color(0xffabafb2),
    this.kitBackgroundColor = const Color(0xff6c757d),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 2,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });

  CoreButtonStyle.success({
    this.kitForegroundColor = const Color(0xffffffff),
    this.kitBorderColor = const Color(0xff28a745), // 40 167 69
    this.kitOverlayColor = const Color(0xff8fc49b),
    this.kitBackgroundColor = const Color(0xff28a745),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 2,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });

  CoreButtonStyle.danger({
    this.kitForegroundColor = const Color(0xffffffff),
    this.kitBorderColor = const Color(0xffdc3545), // 220 53 69
    this.kitOverlayColor = const Color(0xffda949b),
    this.kitBackgroundColor = const Color(0xffdc3545),
    this.kitShadowColor = const Color(0xff191919),

    this.kitElevation = 2,
    this.kitPaddingLTRB = const EdgeInsets.all(10),

    this.kitFontSize = 14,

    this.kitRadius = 0,
  });

CoreButtonStyle.warning({
  this.kitForegroundColor = const Color(0xffffffff),
  this.kitBorderColor = const Color(0xffffc107),
  this.kitOverlayColor = const Color(0xffe8ce81), // 76.5
  this.kitBackgroundColor = const Color(0xffffc107),
  this.kitShadowColor = const Color(0xff191919),

  this.kitElevation = 2,
  this.kitPaddingLTRB = const EdgeInsets.all(10),

  this.kitFontSize = 14,

  this.kitRadius = 0,
});

CoreButtonStyle.info({
  this.kitForegroundColor = const Color(0xffffffff),
  this.kitBorderColor = const Color(0xff17a2b8),
  this.kitOverlayColor = const Color(0xff88c2cb), // 6.9
  this.kitBackgroundColor = const Color(0xff17a2b8),
  this.kitShadowColor = const Color(0xff191919),

  this.kitElevation = 2,
  this.kitPaddingLTRB = const EdgeInsets.all(10),

  this.kitFontSize = 14,

  this.kitRadius = 0,
});

CoreButtonStyle.light({
  this.kitForegroundColor = const Color(0xff3F345F),
  this.kitBorderColor = const Color(0xfff8f9fa),
  this.kitOverlayColor = const Color(0xffe5e6e6),
  this.kitBackgroundColor = const Color(0xfff8f9fa),
  this.kitShadowColor = const Color(0xff191919),

  this.kitElevation = 2,
  this.kitPaddingLTRB = const EdgeInsets.all(10),

  this.kitFontSize = 14,

  this.kitRadius = 0,
});

CoreButtonStyle.dark({
  this.kitForegroundColor = const Color(0xffffffff),
  this.kitBorderColor = const Color(0xff343a40),
  this.kitOverlayColor = const Color(0xff949699),
  this.kitBackgroundColor = const Color(0xff343a40),
  this.kitShadowColor = const Color(0xff191919),

  this.kitElevation = 2,
  this.kitPaddingLTRB = const EdgeInsets.all(10),

  this.kitFontSize = 14,

  this.kitRadius = 0,
});

CoreButtonStyle.link({
  this.kitForegroundColor = const Color(0xff007BFF),
  this.kitBorderColor = const Color(0xffffffff),
  this.kitOverlayColor = const Color(0xffe5e6e6),
  this.kitBackgroundColor = const Color(0xffffffff),
  this.kitShadowColor = const Color(0xff191919),

  this.kitElevation = 2,
  this.kitPaddingLTRB = const EdgeInsets.all(10),

  this.kitFontSize = 14,

  this.kitRadius = 0,
});
}