import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/fonts.dart';

SizedBox hSpace({double height = 10}) {
  return SizedBox(height: height);
}

SizedBox wSpace({double width = 10}) {
  return SizedBox(width: width);
}

TextStyle textStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  String fontFamily = AppFonts.interRegular,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontFamily: fontFamily,
  );
}