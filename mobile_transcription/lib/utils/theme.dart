import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGradientStart = Color(0xFFEC4899); // Pink-500
  static const Color primaryGradientEnd = Color(0xFFEAB308);   // Yellow-500
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceLight = Color(0xFF1F2937);
  
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primaryGradientStart,
    colorScheme: const ColorScheme.dark(
      primary: primaryGradientStart,
      secondary: primaryGradientEnd,
      surface: surface,
      background: background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF9CA3AF),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF374151)),
      ),
    ),
  );
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    stops: [0.0, 1.0],
  );
}
