import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Background colors - Pure black like Instagram dark mode
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFF1C1C1E);
  static const Color surfaceElevated = Color(0xFF262626);

  // Primary accent - Instagram blue only
  static const Color primary = Color(0xFF0095F6);           // Instagram blue
  
  // Keep these for backwards compatibility but use sparingly
  static const Color secondary = Color(0xFF0095F6);         // Same as primary (blue)
  static const Color accent = Color(0xFF0095F6);            // Same as primary (blue)
  static const Color accentYellow = Color(0xFF0095F6);      // Same as primary (blue)
  static const Color accentGold = Color(0xFF0095F6);        // Same as primary (blue)

  // Status colors - muted versions for subtle indication
  static const Color success = Color(0xFF4CAF50);           // Muted green
  static const Color warning = Color(0xFFFFA726);           // Muted orange
  static const Color error = Color(0xFFEF5350);             // Muted red
  static const Color info = Color(0xFF0095F6);              // Instagram blue

  // Text colors - Instagram style grays
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E8E);     // Instagram gray
  static const Color textTertiary = Color(0xFF555555);      // Darker gray
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border colors
  static const Color border = Color(0xFF262626);
  static const Color borderLight = Color(0xFF363636);
  static const Color divider = Color(0xFF262626);

  // Simple avatar border - gray instead of colorful gradient
  static const Color avatarBorder = Color(0xFF363636);
  
  // Gradients - simplified, using the same subtle gray
  static const LinearGradient instagramGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF363636),
      Color(0xFF262626),
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primary],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1C1C1E),
      Color(0xFF121212),
    ],
  );
}

class AppTheme {
  static TextStyle _sfPro({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      letterSpacing: letterSpacing ?? -0.02 * fontSize,
      height: height,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.primary,
        onSecondary: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _sfPro(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: _sfPro(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: _sfPro(fontSize: 10, fontWeight: FontWeight.w500),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _sfPro(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _sfPro(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: _sfPro(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: _sfPro(fontSize: 15, color: AppColors.textTertiary),
        labelStyle: _sfPro(fontSize: 15, color: AppColors.textSecondary),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
        space: 0.5,
      ),

      // Icon - use secondary gray by default
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        textColor: AppColors.textPrimary,
        iconColor: AppColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: _sfPro(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: _sfPro(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
          height: 1.15,
        ),
        displaySmall: _sfPro(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineLarge: _sfPro(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          height: 1.25,
        ),
        headlineMedium: _sfPro(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        headlineSmall: _sfPro(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.35,
        ),
        titleLarge: _sfPro(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: _sfPro(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: _sfPro(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: _sfPro(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: _sfPro(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodySmall: _sfPro(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        labelLarge: _sfPro(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: _sfPro(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: _sfPro(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
