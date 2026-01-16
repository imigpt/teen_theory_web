import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

enum toastType { success, error, info }

Future<void> showToast(String message, {required toastType type}) async {
  try {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: type == toastType.error 
          ? Colors.red 
          : type == toastType.success 
              ? Colors.green 
              : Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } catch (e) {
    debugPrint('Toast error: $e');
  }
}