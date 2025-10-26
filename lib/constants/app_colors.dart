import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFE8E8E8);
  static const Color darkGrey = Color(0xFF374151);
  static const Color successGreen = Color(0xFF5C7600);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  // Extended Color Palette
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color cardBackground = Color(0xFFF9FAFB);
  static const Color borderColor = Color(0xFFE5E7EB);

  // Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: black,
    onPrimary: white,
    secondary: grey,
    onSecondary: white,
    surface: surfaceLight,
    onSurface: black,
    background: white,
    onBackground: black,
    error: errorRed,
    onError: white,
    outline: borderColor,
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: black,
    onPrimary: black,
    secondary: white,
    onSecondary: black,
    surface: surfaceDark,
    onSurface: white,
    background: black,
    onBackground: white,
    error: errorRed,
    onError: white,
    outline: darkGrey,
  );

  // Helper methods for responsive design
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color getOnSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
}
