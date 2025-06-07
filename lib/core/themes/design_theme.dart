import 'package:flutter/material.dart';

class DesignTheme {
  // Colores principales inspirados en Tasty! app
  static const Color primaryColor = Color(0xFFFF6B35); // Naranja principal
  static const Color primaryLightColor = Color(0xFFFF8A5B); // Naranja claro
  static const Color primaryDarkColor = Color(0xFFE55100); // Naranja oscuro
  static const Color secondaryColor = Color(0xFF2E2E2E); // Gris oscuro
  static const Color accentColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(
    0xFFFFFBF8,
  ); // Fondo ligeramente cálido
  static const Color cardColor = Colors.white;
  static const Color grayLightColor = Color(0xFFE0E0E0);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      fontFamily: 'Kodchasan',
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: cardColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
        onBackground: textPrimaryColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryColor),
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimaryColor, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimaryColor, fontSize: 14),
        bodySmall: TextStyle(color: textSecondaryColor, fontSize: 12),
        titleLarge: TextStyle(
          fontSize: 24,
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kodchasan',
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        labelMedium: TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
          fontFamily: 'Kodchasan',
        ),
        labelLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Kodchasan',
        ),
        displayLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kodchasan',
        ),
        displayMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kodchasan',
        ),
        displaySmall: TextStyle(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineSmall: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: grayLightColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: grayLightColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 16),
        labelStyle: const TextStyle(color: textSecondaryColor, fontSize: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Kodchasan',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Kodchasan',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Kodchasan',
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        disabledColor: Colors.grey.shade300,
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(color: textPrimaryColor),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
