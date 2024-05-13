import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../screens/setting/providers/setting_notifier.dart';

class ThemeDataCenter {
  /*
  Change when choose a theme
  getBackgroundColor
  getTopBannerCardBackgroundColor
  getBottomBannerCardBackgroundColor
  getNoteTopBannerCardBackgroundColor
  getUpdateButtonStyle
  getViewButtonStyle
  getCoreScreenButtonStyle
  getCreateSubSubjectButtonStyle
   */

  static Color getBackgroundColor(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault') {
      return const Color(0xFF202124);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return Colors.white;
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xfffed766);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xffb3cde0);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return Colors.white;
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xffe7eff6);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xffa2dcd7);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xfffdf498);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xfffdf5e6);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xffd0e1f9);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xffffeead);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xfffff4e6);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xfff8f8fa);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xffffc425);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      // return const Color(0xffffbbee);
      return const Color(0xffffffd8);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xffeeeeee);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff00a0b0);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getTopBannerCardBackgroundColor(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.lightGreen.withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return Colors.white.withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff2ab7ca)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff6497b1)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xfff6cd61)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff63ace5)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff65c3ba)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff7bc043)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      // return const Color(0xfffff5ee);
      return const Color(0xffFFFFD1)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff4d648d)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff96ceb4)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff4b3832)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xffe5e6eb)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff00b159)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xffff77aa)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xffcccccc)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      // return const Color(0xff4f372d);
      return const Color(0xffFDCF76)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    }
    return const Color(0xff1f1f1f)
        .withOpacity(settingNotifier.opacityNumber ?? 1);
  }

  static Color getBottomBannerCardBackgroundColor(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.white10.withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return Colors.white.withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xfff4f4f8)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xfff4f4f8)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      // return const Color(0xff3da4ab);
      return const Color(0xffFFFFCF)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xfff4f4f8)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xffe0f3f2)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xfff4f4f8)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xfff4f4f8)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xfff4f4f8)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xffffcc5c)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xffbe9b7b)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xffd2d4dc)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xfff4f4f8)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      // return const Color(0xffff99cc);
      return const Color(0xffE0FEFE)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xffdddddd)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xffFCF0CF)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    }
    return const Color(0xff1f1f1f)
        .withOpacity(settingNotifier.opacityNumber ?? 1);
  }

  static Color getTableCalendarBackgroundColor(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return Colors.white;
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xfffed766);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xffb3cde0);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return Colors.white;
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xffe7eff6);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xffa2dcd7);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xfffdf498);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xfffdf5e6);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xffd0e1f9);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xffffeead);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xfffff4e6);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xfff8f8fa);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xffffc425);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      // return const Color(0xffffbbee);
      return const Color(0xffffffd8);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xffeeeeee);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff00a0b0);
    }
    return const Color(0xffffffff);
  }

  /*
  SCREENS
   */
  static Color getScreenTitleTextColor(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.white;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xFF1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xFF1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  /*
  FOR NOTE ONLY
   */
  static Color getNoteTopBannerCardBackgroundColor(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.lightGreen.withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return Colors.white10.withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff2ab7ca)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff6497b1)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xfff6cd61)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff63ace5)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff65c3ba)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff7bc043)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      // return const Color(0xfffff5ee);
      return const Color(0xffFFFFD1)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff4d648d)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff96ceb4)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xffbe9b7b)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xffe5e6eb)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff00b159)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xffff77aa)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xffcccccc)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xffedc951)
          .withOpacity(settingNotifier.opacityNumber ?? 1);
    }
    return const Color(0xff1f1f1f)
        .withOpacity(settingNotifier.opacityNumber ?? 1);
  }

  static Color getNoteBorderCardColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.transparent;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  /*
  FOR NOTE & SUBJECT & LABEL & TEMPLATE
   */
  static CoreButtonStyle getUpdateButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff011f4b),
        kitOverlayColor: const Color(0xff426b91), // 76.5
        kitBackgroundColor: const Color(0xff03396c),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfffea795), // 76.5
        kitBackgroundColor: const Color(0xfffe8a71),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff78a4c7), // 76.5
        kitBackgroundColor: const Color(0xff4b86b4),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff68bdb5), // 76.5
        kitBackgroundColor: const Color(0xff35a79c),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfff27068), // 76.5
        kitBackgroundColor: const Color(0xffee4035),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff191919),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfffbf0e1), // 76.5
        kitBackgroundColor: const Color(0xfffaebd7),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xffffffff),
        kitOverlayColor: const Color(0xff56575c), // 76.5
        kitBackgroundColor: const Color(0xff1e1f26),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffff938f), // 76.5
        kitBackgroundColor: const Color(0xffff6f69),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff3c2f2f),
        kitOverlayColor: const Color(0xffa47a71), // 76.5
        kitBackgroundColor: const Color(0xff854442),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffc3c3c3), // 76.5
        kitBackgroundColor: const Color(0xff4a4e4d),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff40c2e4), // 76.5
        kitBackgroundColor: const Color(0xff00aedb),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffff6699), // 76.5
        kitBackgroundColor: const Color(0xffff3377),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfff08e71), // 76.5
        kitBackgroundColor: const Color(0xffeb6841),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xff949699), // 76.5
      kitBackgroundColor: const Color(0xff343a40),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 0,
    );
  }

  static CoreButtonStyle getViewButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff011f4b),
        kitOverlayColor: const Color(0xff426b91), // 76.5
        kitBackgroundColor: const Color(0xff03396c),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfffea795), // 76.5
        kitBackgroundColor: const Color(0xfffe8a71),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff78a4c7), // 76.5
        kitBackgroundColor: const Color(0xff4b86b4),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff68bdb5), // 76.5
        kitBackgroundColor: const Color(0xff35a79c),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfff27068), // 76.5
        kitBackgroundColor: const Color(0xffee4035),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff191919),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfffbf0e1), // 76.5
        kitBackgroundColor: const Color(0xfffaebd7),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xffffffff),
        kitOverlayColor: const Color(0xff56575c), // 76.5
        kitBackgroundColor: const Color(0xff1e1f26),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffff938f), // 76.5
        kitBackgroundColor: const Color(0xffff6f69),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xffa47a71), // 76.5
        kitBackgroundColor: const Color(0xff854442),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffc3c3c3), // 76.5
        kitBackgroundColor: const Color(0xff4a4e4d),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff40c2e4), // 76.5
        kitBackgroundColor: const Color(0xff00aedb),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffff6699), // 76.5
        kitBackgroundColor: const Color(0xffff3377),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfff08e71), // 76.5
        kitBackgroundColor: const Color(0xffeb6841),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xff949699), // 76.5
      kitBackgroundColor: const Color(0xff343a40),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 0,
    );
  }

  static CoreButtonStyle getRestoreButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff9cd072), // 76.5
        kitBackgroundColor: const Color(0xff7bc043),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xff9cd072), // 76.5
      kitBackgroundColor: const Color(0xff7bc043),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 6,
    );
  }

  static CoreButtonStyle getDeleteForeverButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff191919),
      kitOverlayColor: const Color(0xfffe8686), // 76.5
      kitBackgroundColor: const Color(0xfffe4a49),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 6,
    );
  }

  static CoreButtonStyle getCoreScreenButtonStyle(
      {required BuildContext context,
      double? customPadding,
      double? customRadius}) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xff95dbe5), // 76.5
        kitBackgroundColor: const Color(0xff2ab7ca),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff011f4b),
        kitOverlayColor: const Color(0xff4484b0), // 76.5
        kitBackgroundColor: const Color(0xff055b96),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff777a7a), // 76.5
        kitBackgroundColor: const Color(0xff4a4e4b),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff1f1f1f),
        kitOverlayColor: const Color(0xff5f7a8f), // 76.5
        kitBackgroundColor: const Color(0xff2a4d69),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff40b0a6), // 76.5
        kitBackgroundColor: const Color(0xff009688),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfff69968), // 76.5
        kitBackgroundColor: const Color(0xfff37736),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff191919),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfffbf4ec), // 76.5
        kitBackgroundColor: const Color(0xfffaf0e6),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xffffffff),
        kitOverlayColor: const Color(0xff56575c), // 76.5
        kitBackgroundColor: const Color(0xff1e1f26),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffffd985), // 76.5
        kitBackgroundColor: const Color(0xffffcc5c),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff6d6d63), // 76.5
        kitBackgroundColor: const Color(0xff3c2f2f),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffd0d1da), // 76.5
        kitBackgroundColor: const Color(0xff4a4e4d),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffdd4d71), // 76.5
        kitBackgroundColor: const Color(0xffd11141),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffff80a6), // 76.5
        kitBackgroundColor: const Color(0xffff5588),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffd95f68), // 76.5
        kitBackgroundColor: const Color(0xffcc2a36),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
        kitFontSize: 14,
        kitRadius: customRadius ?? 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xff949699), // 76.5
      kitBackgroundColor: const Color(0xff343a40),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: EdgeInsets.all(customPadding ?? 10),
      kitFontSize: 14,
      kitRadius: customRadius ?? 6,
    );
  }

  static BoxDecoration getFilteringLabelStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return BoxDecoration(
          color: const Color(0xff343a40).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return BoxDecoration(
          color: const Color(0xffffffff).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return BoxDecoration(
          color: const Color(0xff2ab7ca).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff191919).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return BoxDecoration(
          color: const Color(0xff055b96).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff011f4b).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return BoxDecoration(
          color: const Color(0xff4a4e4b).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return BoxDecoration(
          color: const Color(0xff2a4d69).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff1f1f1f).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return BoxDecoration(
          color: const Color(0xff009688).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return BoxDecoration(
          color: const Color(0xfff37736).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return BoxDecoration(
          color: const Color(0xfffaf0e6).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return BoxDecoration(
          color: const Color(0xff1e1f26).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xffffffff).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return BoxDecoration(
          color: const Color(0xffffcc5c).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return BoxDecoration(
          color: const Color(0xff3c2f2f).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return BoxDecoration(
          color: const Color(0xff4a4e4d).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return BoxDecoration(
          color: const Color(0xffd11141).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return BoxDecoration(
          color: const Color(0xffff5588).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return BoxDecoration(
          color: const Color(0xff29a8ab).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return BoxDecoration(
          color: const Color(0xffcc2a36).withOpacity(0.3),
          border: Border.all(
              width: 1.0, color: const Color(0xff343a40).withOpacity(0.3)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(21.0),
              bottomRight: Radius.circular(21.0)));
    }
    return BoxDecoration(
        color: Colors.green.withOpacity(0.3),
        border: Border.all(
            width: 1.0, color: const Color(0xff1f1f1f).withOpacity(0.3)),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(21.0),
            bottomRight: Radius.circular(21.0)));
  }

  static Color getFilteringTextColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getAloneTextColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault') {
      return Colors.white54;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getActiveBackgroundColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault') {
      return Colors.yellowAccent;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xffffffff);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xffffffff);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getTextOnActiveBackgroundColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getTopCardLabelStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.white54;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getBorderCardColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.transparent;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getLockSlidableActionColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xffff793b);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff29a8ab);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xffff793b);
    }
    return const Color(0xffff793b);
  }

  static Color getPinSlidableActionColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xffF54C65);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff29a8ab);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xffF54C65);
    }
    return const Color(0xffF54C65);
  }

  static Color getViewSlidableActionColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff30A03E);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff29a8ab);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff30A03E);
    }
    return const Color(0xff30A03E);
  }

  static Color getFavouriteSlidableActionColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xfffe4a49);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff29a8ab);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xfffe4a49);
    }
    return const Color(0xfffe4a49);
  }

  static Color getDeleteSlidableActionColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return const Color(0xffffb90f);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1e1f26);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff29a8ab);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1e1f26);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getMoreSlidableActionColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return const Color(0xff8fc49b);
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff29a8ab);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  static Color getFormFieldLabelColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.white54;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  /*
  FOR SUBJECT & TEMPLATE
   */
  static CoreButtonStyle getCreateNoteButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xff42addb), // 76.5
      kitBackgroundColor: const Color(0xff0392cf),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 6,
    );
  }

  /*
  FOR SUBJECT ONLY
   */
  static Color getSubjectBorderCardColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.transparent;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  static CoreButtonStyle getCreateSubSubjectButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff191919),
        kitOverlayColor: const Color(0xfffe8686), // 76.5
        kitBackgroundColor: const Color(0xfffe4a49),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff011f4b),
        kitOverlayColor: const Color(0xff426b91), // 76.5
        kitBackgroundColor: const Color(0xff03396c),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfffea795), // 76.5
        kitBackgroundColor: const Color(0xfffe8a71),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff78a4c7), // 76.5
        kitBackgroundColor: const Color(0xff4b86b4),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff68bdb5), // 76.5
        kitBackgroundColor: const Color(0xff35a79c),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfff27068), // 76.5
        kitBackgroundColor: const Color(0xffee4035),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff191919),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfffbf0e1), // 76.5
        kitBackgroundColor: const Color(0xfffaebd7),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xffffffff),
        kitOverlayColor: const Color(0xff56575c), // 76.5
        kitBackgroundColor: const Color(0xff1e1f26),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffff938f), // 76.5
        kitBackgroundColor: const Color(0xffff6f69),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff3c2f2f),
        kitOverlayColor: const Color(0xffa47a71), // 76.5
        kitBackgroundColor: const Color(0xff854442),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffc3c3c3), // 76.5
        kitBackgroundColor: const Color(0xff4a4e4d),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff40c2e4), // 76.5
        kitBackgroundColor: const Color(0xff00aedb),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffff6699), // 76.5
        kitBackgroundColor: const Color(0xffff3377),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xfff08e71), // 76.5
        kitBackgroundColor: const Color(0xffeb6841),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xff949699), // 76.5
      kitBackgroundColor: const Color(0xff343a40),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 0,
    );
  }

  static CoreButtonStyle getViewNotesButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff42addb), // 76.5
        kitBackgroundColor: const Color(0xff0392cf),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xff42addb), // 76.5
      kitBackgroundColor: const Color(0xff0392cf),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 6,
    );
  }

  static CoreButtonStyle getFilterParentSubjectButtonStyle(
      BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xffa6e2c4), // 76.5
      kitBackgroundColor: const Color(0xff88d8b0),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 6,
    );
  }

  static CoreButtonStyle getFilterSubSubjectButtonStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xff343a40),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xff343a40),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff949699), // 76.5
        kitBackgroundColor: const Color(0xffffffff),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xff5fbec0), // 76.5
        kitBackgroundColor: const Color(0xff29a8ab),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return CoreButtonStyle(
        kitForegroundColor: const Color(0xffffffff),
        kitBorderColor: const Color(0xff343a40),
        kitOverlayColor: const Color(0xffa6e2c4), // 76.5
        kitBackgroundColor: const Color(0xff88d8b0),
        kitShadowColor: const Color(0xff191919),
        kitElevation: 2,
        kitPaddingLTRB: const EdgeInsets.all(10),
        kitFontSize: 14,
        kitRadius: 6,
      );
    }
    return CoreButtonStyle(
      kitForegroundColor: const Color(0xffffffff),
      kitBorderColor: const Color(0xff343a40),
      kitOverlayColor: const Color(0xffa6e2c4), // 76.5
      kitBackgroundColor: const Color(0xff88d8b0),
      kitShadowColor: const Color(0xff191919),
      kitElevation: 2,
      kitPaddingLTRB: const EdgeInsets.all(10),
      kitFontSize: 14,
      kitRadius: 6,
    );
  }

  static Color getBottomCardLabelStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.white54;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

  /*
  FOR LABEL ONLY
   */
  static Color getLabelBorderCardColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.transparent;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }

/*
FOR TEMPLATE ONLY
 */
  static Color getTemplateBorderCardColorStyle(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    if (settingNotifier.themeString == 'isSetThemeDefault' ||
        settingNotifier.themeString == null) {
      return Colors.transparent;
    } else if (settingNotifier.themeString == 'isSetThemeBlackAndWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeachTowels') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeautifulBlues') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMoonlightBytes') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNumber3') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeAndroidLollipop') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeRainbowDash') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeShadesOfWhite') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBlueberryBasket') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeBeach') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeCappuccino') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeGreyLavenderColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeMetroUIColors') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemePinks') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeNeverDoubt') {
      return const Color(0xff1f1f1f);
    } else if (settingNotifier.themeString == 'isSetThemeProgramCatalog') {
      return const Color(0xff1f1f1f);
    }
    return const Color(0xff1f1f1f);
  }
}
