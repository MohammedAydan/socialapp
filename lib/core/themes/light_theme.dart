import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xfff2f2f2),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xffb72121),
    secondary: Color(0xffb5b5b5),
    surface: Color(0xffe7e7e7),
    tertiary: Colors.white,
  ),
);
