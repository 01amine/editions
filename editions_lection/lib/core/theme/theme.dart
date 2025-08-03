import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors - Based on new color palette
  static const Color primaryColor =
      Color(0xFF188762); // Main green from palette
  static const Color secondaryColor = Color(0xFF289180); // Teal from palette
  static const Color accentColor = Color(0xFF2a2a2a); // Dark gray from palette

  // Background Colors
  static const Color backgroundColor =
      Color(0xFFd8e1dd); // Light gray from palette
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white surfaces
  static const Color cardColor = Color(0xFFFFFFFF); // White cards

  // Text Colors - Academic and readable
  static const Color primaryTextColor =
      Color(0xFF2a2a2a); // Dark gray from palette
  static const Color secondaryTextColor = Color(0xFF5A5A5A); // Medium gray
  static const Color hintTextColor = Color(0xFF9E9E9E); // Light gray hints

  // Interactive Colors
  static const Color buttonColor =
      Color(0xFF188762); // Primary green for buttons
  static const Color selectedColor = Color(0xFFd8e1dd); // Light gray selection
  static const Color borderColor = Color(0xFFE0E0E0); // Subtle borders

  // Status Colors
  static const Color successColor = Color(0xFF188762); // Green success
  static const Color errorColor = Color(0xFFD32F2F); // Red error
  static const Color warningColor = Color(0xFFFF9800); // Orange warning
  static const Color infoColor = Color(0xFF289180); // Teal info

  // Reading-focused Colors
  static const Color readingBackgroundColor =
      Color(0xFFFFFDF7); // Warm white for reading
  static const Color highlightColor = Color(0xFFFFEB3B); // Yellow highlight
  static const Color bookmarkColor = Color(0xFF188762); // Green bookmark

  // Social Colors
  static const Color googleColor = Color(0xFF4285F4);
  static const Color facebookColor = Color(0xFF1877F2);
<<<<<<< Updated upstream

=======
  
backend  editions_lection
>>>>>>> Stashed changes
  // Transparent Colors
  static const Color overlayColor = Color(0x80000000);
  static const Color shimmerColor = Color(0xFFd8e1dd);

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryTextColor,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: TextTheme(
        // Display styles - For major headings
        displayLarge: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),

        // Headline styles - For section headings
        headlineLarge: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),

        // Title styles - For UI elements
        titleLarge: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: GoogleFonts.raleway(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),

        // Body styles - For reading content
        bodyLarge: GoogleFonts.montserrat(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1.6, // Better reading line height
        ),
        bodyMedium: GoogleFonts.montserrat(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.raleway(
          color: secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),

        // Label styles - For buttons and small UI elements
        labelLarge: GoogleFonts.raleway(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.raleway(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.raleway(
          color: hintTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: surfaceColor,
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Dark theme variant for reading in low light
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: secondaryColor,
      scaffoldBackgroundColor: accentColor,
      cardColor: const Color(0xFF1E1E1E),
      colorScheme: ColorScheme.dark(
        primary: secondaryColor,
        secondary: primaryColor,
        surface: const Color(0xFF1E1E1E),
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleLarge: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: GoogleFonts.raleway(
          color: const Color(0xFFB0B0B0),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.montserrat(
          color: const Color(0xFFE0E0E0),
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.montserrat(
          color: const Color(0xFFE0E0E0),
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.raleway(
          color: const Color(0xFFB0B0B0),
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.raleway(
          color: const Color(0xFFB0B0B0),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.raleway(
          color: const Color(0xFF666666),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
