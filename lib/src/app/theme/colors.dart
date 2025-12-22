import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryColorBackground = Color(0xFF000000);

  //Text Colors
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color darkTextColor = Color(0xFF121212);
  static Color lightTextColor = const Color(0xFFDDDDDD);
  static Color lightTextColor2 = const Color(0xFF646464);
  static const Color containerColor =  Color(0xFF17181A);

  //Action Colors
  static const Color disabledColor = Color(0xFF999999);
  static const Color accentColor = Color(0xFFF37D43);
  static Color borderColor = Color(0xFF808080).withOpacity(0.55);

  static const Color circleBorderColor = Color(0xFFD9D9D9);
  static Color textBorderColor = Color(0xFFE5F2FF).withOpacity(0.1);
  static const Color textFieldColorOld = Color(0xFFFFF5F9);
  static const Color textFieldColor = Color(0xFFFFF5F9);
  // static const Color textFieldColor = Color(0xFFFCFAFF);
  static const Color searchIconColor = Color(0xFFC4C4C4);
  static const Color searchTextColor = Color(0xFFA0A0A0);

  //Other Colors
  static const Color red = Color(0xFFFF272B);
  static const Color green = Color(0xFF1FFF1F);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color transparent = Colors.transparent;

  static const int _primaryColorValue = 0xFF007AFF;

static const MaterialColor primaryColor = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFFE0E7FF),  // Lightest shade
    100: Color(0xFFB3C8FF), // Light shade
    200: Color(0xFF80A9FF), // Lighter shade
    300: Color(0xFF4D8CFF), // Mid-light shade
    400: Color(0xFF2678FF), // Mid shade
    500: Color(_primaryColorValue), // Base color #007AFF
    600: Color(0xFF0065D9), // Darker shade
    700: Color(0xFF0052B8), // Even darker
    800: Color(0xFF004098), // Darker still
    900: Color(0xFF00356F), // Darkest shade
  },
);

}
