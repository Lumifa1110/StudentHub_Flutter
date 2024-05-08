import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F90F0),
    foregroundColor: Colors.blue,
  ),
  colorScheme: const ColorScheme.light(
    background: Color(0xFFF3F3F3),
    primary: Color(0xFF0F90F0),
    secondary: Color(0xFF424242),
    onSecondary: Color(0xFF636363),
    error: Color(0xFFC40606),
  ),
  primaryColor: const Color(0xFF0F90F0),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.black,
  ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF636363),
    primary: Color(0xFF424242),
    secondary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFCECECE),
    error: Color(0xFFFF4242),
  ),
  primaryColor: const Color(0xFFFFFFFF),
);
