import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: mainColor,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: darkgrayColor,
  ),
);
