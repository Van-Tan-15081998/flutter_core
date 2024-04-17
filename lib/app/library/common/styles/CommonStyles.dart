import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonStyles {
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
}
