import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    if (isEmpty) {
      return Colors.black;
    }
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

extension CutString on String {
  cutString(int lengthToCut) {
    return substring(0, length - lengthToCut);
  }
}

extension AddColon on String {
  addColon() {
    return "$this:";
  }
}
