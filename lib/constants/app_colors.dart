import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: black,
    onPrimary: white,
    secondary: black,
    onSecondary: white,
    surface: white,
    onSurface: black,
    error: Colors.red,
    onError: white,
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: white,
    onPrimary: black,
    secondary: white,
    onSecondary: black,
    surface: black,
    onSurface: white,
    error: Colors.red,
    onError: white,
  );
}
