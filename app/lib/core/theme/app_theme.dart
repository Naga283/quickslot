import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFCC), // Teal Accent
        secondary: Color(0xFF38BDF8), // Sky Blue
        surface: Color(0xFF1E293B), // Slate 800
        error: Color(0xFFF87171),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF94A3B8), // Slate 400
          fontSize: 15,
        ),
      ),
      // cardTheme: CardTheme(
      //   color: const Color(0xFF1E293B),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16),
      //   ),
      // ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0F766E), // Dark Teal
        secondary: Color(0xFF0284C7), // Light Blue
        surface: Colors.white,
        error: Color(0xFFDC2626),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF0F172A),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF475569), // Slate 600
          fontSize: 15,
        ),
      ),
      // cardTheme: CardTheme(
      //   color: Colors.white,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // ),
    );
  }
}
