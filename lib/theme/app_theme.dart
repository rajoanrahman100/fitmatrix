import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Creates the global visual theme for FitMatrix.
ThemeData buildAppTheme() {
  final baseTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF56C6FF),
      secondary: Color(0xFFFFC36A),
      surface: Color(0xFF0F1825),
      surfaceContainerHighest: Color(0xFF152033),
      onPrimary: Color(0xFF07121C),
      onSurface: Color(0xFFEAF2FF),
    ),
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.soraTextTheme(baseTheme.textTheme),
    scaffoldBackgroundColor: const Color(0xFF0B111B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
