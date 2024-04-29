import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonStyles {

  /*
  CommonStyles.backgroundImageSourceStringList()
   */
  static List<String> backgroundImageSourceStringList() {
    List<String> imageSourceStringList = [
      'assets/images/background-image-01.jpg',
      'assets/images/background-image-02.jpg',
      'assets/images/background-image-03.jpg',
      'assets/images/background-image-04.jpg',
      'assets/images/background-image-05.jpg',
      'assets/images/background-image-06.jpg',
      'assets/images/background-image-07.jpg',
      'assets/images/background-image-08.jpg',
      'assets/images/background-image-09.jpg',
    ];

    return imageSourceStringList;
  }

  /*
  CommonStyles.backgroundImageSourceStringDefault()
   */
  static String backgroundImageSourceStringDefault() {
    String imageSourceString = 'assets/images/background-image-01.jpg';
    return imageSourceString;
  }

  /*
  CommonStyles.dateTimeTextStyle(color: ThemeDataCenter.getTopCardLabelStyle(context))
   */
  static TextStyle dateTimeTextStyle({FontStyle? fontStyle, double? fontSize, Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.montserrat(
        fontStyle: fontStyle ?? FontStyle.italic,
        fontSize: fontSize ?? 14.0,
        color: color ?? const Color(0xFF1f1f1f),
        fontWeight: fontWeight ?? FontWeight.w500);
  }

  /*
  CommonStyles.screenTitleTextStyle(color: ThemeDataCenter.getScreenTitleTextColor(context))
   */
  static TextStyle screenTitleTextStyle({FontStyle? fontStyle, double? fontSize, Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.montserrat(
        fontStyle: fontStyle ?? FontStyle.italic,
        fontSize: fontSize ?? 28.0,
        color: color ?? const Color(0xFF1f1f1f),
        fontWeight: fontWeight ?? FontWeight.bold);
  }

  /*
  CommonStyles.appbarLeadingBackButtonStyle(whiteBlur:)
   */
  static ButtonStyle appbarLeadingBackButtonStyle({required bool whiteBlur}) {
    return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color?>(whiteBlur ? Colors.white.withOpacity(0.65) : Colors.transparent)
    );
  }

  static TextStyle buttonTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.italic,
      fontSize: 16,
      color: const Color(0xFF404040),
      fontWeight: FontWeight.w600);

  static TextStyle labelTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.italic,
      fontSize: 16,
      color: const Color(0xFF404040),
      fontWeight: FontWeight.w600);

  static TextStyle settingLabelTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: const Color(0xFF404040),
      fontWeight: FontWeight.w500);

  static TextStyle dateTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.normal,
      fontSize: 14,
      color: const Color(0xFF404040),
      fontWeight: FontWeight.w500);
}
