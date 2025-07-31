import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors - Based on Lectio branding
  static const Color primaryColor = Color(0xFF2E7D32); // Deep green from logo
  static const Color secondaryColor = Color(0xFF1B5E20); // Darker green
  static const Color accentColor = Color(0xFF4CAF50); // Bright green accent
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFFAFAFA); // Clean light background
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white surfaces
  static const Color cardColor = Color(0xFFFFFFFF); // White cards
  
  // Text Colors - Academic and readable
  static const Color primaryTextColor = Color(0xFF2C2C2C); // Dark charcoal for readability
  static const Color secondaryTextColor = Color(0xFF5A5A5A); // Medium gray
  static const Color hintTextColor = Color(0xFF9E9E9E); // Light gray hints
  
  // Interactive Colors
  static const Color buttonColor = Color(0xFF2E7D32); // Primary green for buttons
  static const Color selectedColor = Color(0xFFE8F5E8); // Light green selection
  static const Color borderColor = Color(0xFFE0E0E0); // Subtle borders
  
  // Status Colors
  static const Color successColor = Color(0xFF4CAF50); // Green success
  static const Color errorColor = Color(0xFFD32F2F); // Red error
  static const Color warningColor = Color(0xFFFF9800); // Orange warning
  static const Color infoColor = Color(0xFF1976D2); // Blue info
  
  // Reading-focused Colors
  static const Color readingBackgroundColor = Color(0xFFFFFDF7); // Warm white for reading
  static const Color highlightColor = Color(0xFFFFEB3B); // Yellow highlight
  static const Color bookmarkColor = Color(0xFF2E7D32); // Green bookmark
  
  // Social Colors
  static const Color googleColor = Color(0xFF4285F4);
  static const Color facebookColor = Color(0xFF1877F2);
  
  // Transparent Colors
  static const Color overlayColor = Color(0x80000000);
  static const Color shimmerColor = Color(0xFFF5F5F5);
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryTextColor,
        onBackground: primaryTextColor,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.libreBaskerville(
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
        displayLarge: GoogleFonts.libreBaskerville(
          color: primaryTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.libreBaskerville(
          color: primaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.libreBaskerville(
          color: primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        
        // Headline styles - For section headings
        headlineLarge: GoogleFonts.libreBaskerville(
          color: primaryTextColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.libreBaskerville(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.libreBaskerville(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        
        // Title styles - For UI elements
        titleLarge: GoogleFonts.inter(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.inter(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: GoogleFonts.inter(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        
        // Body styles - For reading content
        bodyLarge: GoogleFonts.crimsonText(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1.6, // Better reading line height
        ),
        bodyMedium: GoogleFonts.crimsonText(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          color: secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),
        
        // Label styles - For buttons and small UI elements
        labelLarge: GoogleFonts.inter(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.inter(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.inter(
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
      primaryColor: accentColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: primaryColor,
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: errorColor,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.libreBaskerville(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.libreBaskerville(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.libreBaskerville(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.libreBaskerville(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.libreBaskerville(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.libreBaskerville(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleLarge: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: GoogleFonts.inter(
          color: const Color(0xFFB0B0B0),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.crimsonText(
          color: const Color(0xFFE0E0E0),
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.crimsonText(
          color: const Color(0xFFE0E0E0),
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          color: const Color(0xFFB0B0B0),
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.inter(
          color: const Color(0xFFB0B0B0),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.inter(
          color: const Color(0xFF666666),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}