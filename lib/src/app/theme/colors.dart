import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryColorBackground = Color(0xFFFFFFFF);

  //Text Colors
  static const Color textColor = Color(0xFF000000);
  static const Color darkTextColor = Color(0xFF121212);
  static const Color lightTextColor = Color(0xFF8e8e8e);
  static const Color lightTextColor2 = Color(0xFFcacaca);
  static const Color lightTextColor3 = Color(0xFF4b4b4b);
  static const Color containerColor =  Color(0xFFFFFFFF);

  //Action Colors
  static const Color disabledColor = Color(0xFFe1e1e1);
  static const Color accentColor = Color(0xFFF3AE3D);
  static Color borderColor = Color(0xFFe1e1e1);

  static const Color circleBorderColor = Color(0xFFe1e1e1);
  static Color textBorderColor = Color(0xFFFFFFFF);
  static const Color textFieldColorOld = Color(0xFFFFFFFF);
  static const Color textFieldColor = Color(0xFFFFFFFF);
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

  static const int _primaryColorValue = 0xFF194128;

static const MaterialColor primaryColor = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFFE8F0EC),   // Lightest shade
    100: Color(0xFFC8DDD6),  // Light shade
    200: Color(0xFFA5CBBC),  // Lighter shade
    300: Color(0xFF7FB5A0),  // Mid-light shade
    400: Color(0xFF62A38C),  // Mid shade
    500: Color(_primaryColorValue), // Base color
    600: Color(0xFF143A24),  // Darker shade
    700: Color(0xFF12321F),  // Even darker
    800: Color(0xFF0F2A19),  // Darker still
    900: Color(0xFF0A1A10),  // Darkest shade
  },
);

}
