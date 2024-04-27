import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonStyles {

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
