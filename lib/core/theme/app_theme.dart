import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color charcoal = Color(0xFF121212); // Deep Charcoal
  static const Color slate = Color(0xFF1E1E1E);    // Slate Grey
  static const Color neonCyan = Color(0xFF00E5FF); // Neon Cyan
  static const Color electricGreen = Color(0xFF00E676); // Electric Green
  static const Color textColor = Color(0xFFE0E0E0); // Light Grey Text

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: charcoal,
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: electricGreen,
        surface: slate,
        background: charcoal,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        bodyMedium: const TextStyle(color: textColor),
      ),
      cardTheme: CardTheme(
        color: slate,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: slate,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: neonCyan, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: neonCyan,
        foregroundColor: charcoal,
        elevation: 10,
        shape: CircleBorder(),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
