import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoreStoreFonts {
  static List<CoreFontFamily> fontFamilies = [
    /// Các font phổ biến và hỗ trợ nhiều ngôn ngữ
    CoreFontFamily(name: 'GoogleFonts.notoSans'),
    CoreFontFamily(name: 'GoogleFonts.roboto'),
    CoreFontFamily(name: 'GoogleFonts.openSans'),

    CoreFontFamily(name: 'GoogleFonts.robotoCondensed'),
    CoreFontFamily(name: 'GoogleFonts.croissantOne'),
    CoreFontFamily(name: 'GoogleFonts.merriweather'),
    CoreFontFamily(name: 'GoogleFonts.anton'),
    CoreFontFamily(name: 'GoogleFonts.dancingScript'),
    CoreFontFamily(name: 'GoogleFonts.caveat'),
    CoreFontFamily(name: 'GoogleFonts.caveatBrush'),
    CoreFontFamily(name: 'GoogleFonts.shadowsIntoLight'),
    CoreFontFamily(name: 'GoogleFonts.alfaSlabOne'),
    CoreFontFamily(name: 'GoogleFonts.greatVibes'),
    CoreFontFamily(name: 'GoogleFonts.yellowtail'),
    CoreFontFamily(name: 'GoogleFonts.kaushanScript'),
    CoreFontFamily(name: 'GoogleFonts.sacramento'),
    CoreFontFamily(name: 'GoogleFonts.concertOne'),
    CoreFontFamily(name: 'GoogleFonts.parisienne'),
    CoreFontFamily(name: 'GoogleFonts.leckerliOne'),
    CoreFontFamily(name: 'GoogleFonts.blackHanSans'),
    CoreFontFamily(name: 'GoogleFonts.justAnotherHand'),
    CoreFontFamily(name: 'GoogleFonts.monteCarlo'),
    CoreFontFamily(name: 'GoogleFonts.lora'),
    CoreFontFamily(name: 'GoogleFonts.frederickaTheGreat'),
    CoreFontFamily(name: 'GoogleFonts.rubikMoonrocks'),
    CoreFontFamily(name: 'GoogleFonts.creepster'),
    CoreFontFamily(name: 'GoogleFonts.rye'),
    CoreFontFamily(name: 'GoogleFonts.grandstander'),
    CoreFontFamily(name: 'GoogleFonts.blackAndWhitePicture'),
    CoreFontFamily(name: 'GoogleFonts.hennyPenny'),
    CoreFontFamily(name: 'GoogleFonts.sail'),
    CoreFontFamily(name: 'GoogleFonts.shantellSans'),
  ];

  static List<CoreFontStyle> fontStyles = [
    CoreFontStyle(
        name: 'NORMAL',
        fontWeight: FontWeight.normal,
        textDecoration: TextDecoration.none,
        fontStyle: FontStyle.normal),
    CoreFontStyle(
        name: 'BOLD',
        fontWeight: FontWeight.bold,
        textDecoration: TextDecoration.none,
        fontStyle: FontStyle.normal),
    CoreFontStyle(
      name: 'BOLD_ITALIC',
      fontWeight: FontWeight.bold,
      textDecoration: TextDecoration.none,
      fontStyle: FontStyle.italic,
    ),
    CoreFontStyle(
        name: 'BOLD_ITALIC_UNDERLINE',
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        textDecoration: TextDecoration.underline),
    CoreFontStyle(
      name: 'ITALIC',
      fontWeight: FontWeight.normal,
      textDecoration: TextDecoration.none,
      fontStyle: FontStyle.italic,
    ),
    CoreFontStyle(
        name: 'ITALIC_UNDERLINE',
        fontWeight: FontWeight.normal,
        textDecoration: TextDecoration.underline,
        fontStyle: FontStyle.italic),
    CoreFontStyle(
        name: 'UNDERLINE',
        fontWeight: FontWeight.normal,
        textDecoration: TextDecoration.underline,
        fontStyle: FontStyle.normal),
    CoreFontStyle(
        name: 'UNDERLINE_BOLD',
        textDecoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal),
  ];

  static TextStyle parseTextStyleFromCoreFontStyle({ required CoreFontStyle coreFontStyle}) {
    return TextStyle(
      fontStyle: coreFontStyle.fontStyle,
      fontWeight: coreFontStyle.fontWeight,
      decoration: coreFontStyle.textDecoration
    );
  }

  static List<CoreFontSize> fontSizes = [
    CoreFontSize(name: '12', size: 12.0),
    CoreFontSize(name: '14', size: 14.0),
    CoreFontSize(name: '16', size: 16.0),
    CoreFontSize(name: '18', size: 18.0),
    CoreFontSize(name: '20', size: 20.0),
    CoreFontSize(name: '24', size: 24.0),
    CoreFontSize(name: '30', size: 30.0),
    CoreFontSize(name: '36', size: 36.0),
    CoreFontSize(name: '40', size: 40.0),
  ];

  // static List<Map<String, Color>> fontColors = [
  //   {'dark': const Color(0xff343a40)},
  //   {'turtles': const Color(0xff46A094)},
  //   {'stormi': const Color(0xff3B7197)},
  //   {'slate': const Color(0xff2E424D)},
  //   {'primary': const Color(0xff007bff)},
  //   {'secondary': const Color(0xff6c757d)},
  //   {'success': const Color(0xff28a745)},
  //   {'danger': const Color(0xffdc3545)},
  //   {'warning': const Color(0xffffc107)},
  //   {'info': const Color(0xff17a2b8)},
  // ];

  static List<CoreFontColor> fontColors = [
    CoreFontColor(name: 'dark', color: const Color(0xff343a40)),
    CoreFontColor(name: 'turtles', color: const Color(0xff46A094)),
    CoreFontColor(name: 'stormi', color: const Color(0xff3B7197)),
    CoreFontColor(name: 'slate', color: const Color(0xff2E424D)),
    CoreFontColor(name: 'primary', color: const Color(0xff007bff)),
    CoreFontColor(name: 'secondary', color: const Color(0xff6c757d)),
    CoreFontColor(name: 'success', color: const Color(0xff28a745)),
    CoreFontColor(name: 'danger', color: const Color(0xffdc3545)),
    CoreFontColor(name: 'warning', color: const Color(0xffffc107)),
    CoreFontColor(name: 'info', color: const Color(0xff17a2b8)),
  ];

  static List listFontFamiliesParsed() {
    List<TextStyle> textStyles = [];

    for (var element in fontFamilies) {
      TextStyle style = parseGoogleFontStyle(element.name);
      textStyles.add(style);
    }

    return textStyles;
  }

  static TextStyle parseGoogleFontStyle(String name) {
    TextStyle style;

    switch (name) {
      case 'GoogleFonts.notoSans':
        {
          style = GoogleFonts.notoSans(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.roboto':
        {
          style = GoogleFonts.roboto(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.openSans':
        {
          style = GoogleFonts.openSans(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.robotoCondensed':
        {
          style = GoogleFonts.robotoCondensed(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.croissantOne':
        {
          style = GoogleFonts.croissantOne(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.merriweather':
        {
          style = GoogleFonts.merriweather(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.anton':
        {
          style = GoogleFonts.anton(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.dancingScript':
        {
          style = GoogleFonts.dancingScript(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.caveat':
        {
          style = GoogleFonts.caveat(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.caveatBrush':
        {
          style = GoogleFonts.caveatBrush(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.shadowsIntoLight':
        {
          style = GoogleFonts.shadowsIntoLight(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.alfaSlabOne':
        {
          style = GoogleFonts.alfaSlabOne(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.greatVibes':
        {
          style = GoogleFonts.greatVibes(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.yellowtail':
        {
          style = GoogleFonts.yellowtail(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.kaushanScript':
        {
          style = GoogleFonts.kaushanScript(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.sacramento':
        {
          style = GoogleFonts.sacramento(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.concertOne':
        {
          style = GoogleFonts.concertOne(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.parisienne':
        {
          style = GoogleFonts.parisienne(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.leckerliOne':
        {
          style = GoogleFonts.leckerliOne(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.blackHanSans':
        {
          style = GoogleFonts.blackHanSans(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.justAnotherHand':
        {
          style = GoogleFonts.justAnotherHand(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.monteCarlo':
        {
          style = GoogleFonts.monteCarlo(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.lora':
        {
          style = GoogleFonts.lora(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.frederickaTheGreat':
        {
          style = GoogleFonts.frederickaTheGreat(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.rubikMoonrocks':
        {
          style = GoogleFonts.rubikMoonrocks(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.creepster':
        {
          style = GoogleFonts.creepster(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.rye':
        {
          style = GoogleFonts.rye(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.grandstander':
        {
          style = GoogleFonts.grandstander(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.blackAndWhitePicture':
        {
          style = GoogleFonts.blackAndWhitePicture(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.hennyPenny':
        {
          style = GoogleFonts.hennyPenny(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.sail':
        {
          style = GoogleFonts.sail(
              fontSize: 18);

          break;
        }
      case 'GoogleFonts.shantellSans':
        {
          style = GoogleFonts.shantellSans(
              fontSize: 18);

          break;
        }
      default: {
        style = GoogleFonts.notoSans(
            fontSize: 18);
      }
    }

    return style;
  }

  static TextStyle parseTextStyle(
      {required CoreFontColor coreFontColor,
      required CoreFontSize coreFontSize,
      required CoreFontStyle coreFontStyle,
      required CoreFontFamily coreFontFamily}) {
    /// Font Color
    CoreFontColor fontColor;
    if (coreFontColor.name.isNotEmpty) {
      fontColor = fontColors
          .firstWhere((element) => element.name == coreFontColor.name);
    } else {
      fontColor = fontColors.firstWhere((element) => element.name == 'dark');
    }

    /// Font Size
    CoreFontSize fontSize;
    if (coreFontSize.name.isNotEmpty) {
      fontSize =
          fontSizes.firstWhere((element) => element.name == coreFontSize.name);
    } else {
      fontSize = fontSizes.firstWhere((element) => element.name == '16');
    }

    /// Font Style
    CoreFontStyle fontStyle;
    if (coreFontStyle.name.isNotEmpty) {
      fontStyle = fontStyles
          .firstWhere((element) => element.name == coreFontStyle.name);
    } else {
      fontStyle = fontStyles.firstWhere((element) => element.name == 'NORMAL');
    }

    TextStyle style = GoogleFonts.notoSans(
        fontStyle: fontStyle.fontStyle,
        decoration: fontStyle.textDecoration,
        fontWeight: fontStyle.fontWeight,
        fontSize: fontSize.size,
        color: fontColor.color);

    CoreFontFamily fontFamily;
    if (coreFontFamily.name.isNotEmpty) {
      switch (coreFontFamily.name) {
        case 'GoogleFonts.notoSans':
          {
            style = GoogleFonts.notoSans(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.roboto':
          {
            style = GoogleFonts.roboto(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.openSans':
          {
            style = GoogleFonts.openSans(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.robotoCondensed':
          {
            style = GoogleFonts.robotoCondensed(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.croissantOne':
          {
            style = GoogleFonts.croissantOne(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.merriweather':
          {
            style = GoogleFonts.merriweather(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.anton':
          {
            style = GoogleFonts.anton(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.dancingScript':
          {
            style = GoogleFonts.dancingScript(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.caveat':
          {
            style = GoogleFonts.caveat(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.caveatBrush':
          {
            style = GoogleFonts.caveatBrush(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.shadowsIntoLight':
          {
            style = GoogleFonts.shadowsIntoLight(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.alfaSlabOne':
          {
            style = GoogleFonts.alfaSlabOne(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.greatVibes':
          {
            style = GoogleFonts.greatVibes(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.yellowtail':
          {
            style = GoogleFonts.yellowtail(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.kaushanScript':
          {
            style = GoogleFonts.kaushanScript(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.sacramento':
          {
            style = GoogleFonts.sacramento(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.concertOne':
          {
            style = GoogleFonts.concertOne(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.parisienne':
          {
            style = GoogleFonts.parisienne(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.leckerliOne':
          {
            style = GoogleFonts.leckerliOne(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.blackHanSans':
          {
            style = GoogleFonts.blackHanSans(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.justAnotherHand':
          {
            style = GoogleFonts.justAnotherHand(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.monteCarlo':
          {
            style = GoogleFonts.monteCarlo(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.lora':
          {
            style = GoogleFonts.lora(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.frederickaTheGreat':
          {
            style = GoogleFonts.frederickaTheGreat(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.rubikMoonrocks':
          {
            style = GoogleFonts.rubikMoonrocks(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.creepster':
          {
            style = GoogleFonts.creepster(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.rye':
          {
            style = GoogleFonts.rye(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.grandstander':
          {
            style = GoogleFonts.grandstander(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.blackAndWhitePicture':
          {
            style = GoogleFonts.blackAndWhitePicture(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.hennyPenny':
          {
            style = GoogleFonts.hennyPenny(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.sail':
          {
            style = GoogleFonts.sail(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
        case 'GoogleFonts.shantellSans':
          {
            style = GoogleFonts.shantellSans(
                fontStyle: fontStyle.fontStyle,
                decoration: fontStyle.textDecoration,
                fontWeight: fontStyle.fontWeight,
                fontSize: fontSize.size,
                color: fontColor.color);

            break;
          }
      }
    }

    return style;
  }
}

class CoreFontColor {
  final String name;
  final Color color;

  CoreFontColor({required this.name, required this.color});
}

class CoreFontSize {
  final String name;
  final double size;

  CoreFontSize({required this.name, required this.size});
}

class CoreFontStyle {
  final String name;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;

  CoreFontStyle(
      {required this.name,
      required this.fontWeight,
      required this.fontStyle,
      required this.textDecoration});
}

class CoreFontFamily {
  final String name;

  CoreFontFamily({required this.name});
}
