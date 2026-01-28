import 'package:flutter/material.dart';

class AppFonts {
  static const String interRegular = "inter-regular";
  static const String interMedium = "inter-medium";
  static const String interBold = "inter-bold";
  static const String interSemiBold = "inter-semibold";

  // TextStyle getters
  static TextStyle get regular => const TextStyle(fontFamily: interRegular);
  static TextStyle get medium => const TextStyle(fontFamily: interMedium);
  static TextStyle get bold => const TextStyle(fontFamily: interBold);
  static TextStyle get semiBold => const TextStyle(fontFamily: interSemiBold);
}
