import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFF4F4F4),
    surface: Color(0xFFFFFFFF),
    primary: Color(0xFF0F99F0),
    secondary: Color(0xFF6F6F6F),
    tertiary: Color(0xFF1AC281),
    shadow: Color(0xFFABABAB),
    error: Color(0xFFC40606),
    onBackground: Color(0xFF0F90F0),
    onSurface: Color(0xFF393939),
  ),
  primaryColor: const Color(0xFF369EFF),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF333333),
    primary: Color(0xFF0050A0),
    surface: Color(0xFF505050),
    secondary: Color(0xFF0C0C0C),
    shadow: Color(0xFFFFFFFF),
    error: Color(0xFFC40606),
    onBackground: Color(0xFFEEEEEE),
    onSurface: Color(0xFFEEEEEE),
  ),
  primaryColor: const Color(0xFF1B4F7F),
);
