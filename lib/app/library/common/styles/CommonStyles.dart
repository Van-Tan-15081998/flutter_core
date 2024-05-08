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
      'assets/images/background-image-10.jpg',
      'assets/images/background-image-11.jpg',
      'assets/images/background-image-12.jpg',
      'assets/images/background-image-13.jpg',
      'assets/images/background-image-14.jpg',
      'assets/images/background-image-15.jpg',
      'assets/images/background-image-16.jpg',
      'assets/images/background-image-17.jpg',
      'assets/images/background-image-18.jpg',
      'assets/images/background-image-19.jpg',
      'assets/images/background-image-20.jpg',
      'assets/images/background-image-21.jpg',
    ];

    return imageSourceStringList;
  }

  /*
  CommonStyles.adImageSourceStringList()
   */
  static List<String> adImageSourceStringList() {
    List<String> imageSourceStringList = [
      'assets/images/ad/ad_01.jpg',
      'assets/images/ad/ad_02.jpg',
      'assets/images/ad/ad_03.jpg',
      'assets/images/ad/ad_04.jpg',
      'assets/images/ad/ad_05.jpg',
      'assets/images/ad/ad_06.jpg',
      'assets/images/ad/ad_07.jpg',
      'assets/images/ad/ad_08.jpg',
      'assets/images/ad/ad_09.jpg',
    ];

    return imageSourceStringList;
  }

  static String avatarImageSourceString() {
    return 'assets/images/avatars/app_avatar.png';
  }

  /*
  CommonStyles.commonSubjectColorStringList()
   */
  static List<String> commonSubjectColorStringList() {
    List<String> commonSubjectColorStringList = [
      '399CFF',
      '000000',
      'F40C00',
      'FEFF02',
      'BFBFBF',
      'FEFEFE',
      'C9EDCF',
      '9ACB2E',
      '2A8F23',
      '55FAF9',
      'C0D8DA',
      '3895CD',
      '322DDB',
      'F67F02',
      'A77D3F',
      'F89D96',
      'F51BB0',
      'DA6EDA',
      '9833CB',
//
      'B5DDD1',
      'D7E7A9',
      'D3C0F9',
      'F99A9C',
      'FDBCCF',
      '84D9BA',
      'A0B4F2',
      'F0C5D5',
      'F29BD4',
      '8AC0DE',
      '99D9F2',
      'E3BAA8',
      '909090',
      '89AEB2',
      '59D9CC',
    ];

    return commonSubjectColorStringList;
  }

  /*
  CommonStyles.backgroundImageSourceStringDefault()
   */
  static String backgroundImageSourceStringDefault() {
    String imageSourceString = 'assets/images/background-image-01.jpg';
    return imageSourceString;
  }

  /*
  CommonStyles.titleScreenDecorationStyle()
   */
  static BoxDecoration titleScreenDecorationStyle(bool? isSetBackgroundImage) {
    return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: isSetBackgroundImage == true
            ? Colors.white.withOpacity(0.45)
            : Colors.transparent);
  }

  /*
  CommonStyles.dateTimeTextStyle(color: ThemeDataCenter.getTopCardLabelStyle(context))
   */
  static TextStyle dateTimeTextStyle(
      {FontStyle? fontStyle,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight}) {
    return GoogleFonts.montserrat(
        fontStyle: fontStyle ?? FontStyle.italic,
        fontSize: fontSize ?? 14.0,
        color: color ?? const Color(0xFF1f1f1f),
        fontWeight: fontWeight ?? FontWeight.w500);
  }

  /*
  CommonStyles.screenTitleTextStyle(color: ThemeDataCenter.getScreenTitleTextColor(context))
   */
  static TextStyle screenTitleTextStyle(
      {FontStyle? fontStyle,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight}) {
    return GoogleFonts.montserrat(
        fontStyle: fontStyle ?? FontStyle.italic,
        fontSize: fontSize ?? 22.0,
        color: color ?? const Color(0xFF1f1f1f),
        fontWeight: fontWeight ?? FontWeight.w600);
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
        backgroundColor: MaterialStateProperty.all<Color?>(
            whiteBlur ? Colors.white.withOpacity(0.65) : Colors.transparent));
  }

  static TextStyle buttonTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.italic,
      fontSize: 16,
      color: const Color(0xFF404040),
      fontWeight: FontWeight.w600);

  static TextStyle labelFilterTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.normal,
      fontSize: 16,
      color: const Color(0xFF1f1f1f),
      fontWeight: FontWeight.w500);

  static TextStyle labelTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.italic,
      fontSize: 14,
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
