import 'package:flutter/material.dart';
import 'package:laferia/core/constants/app_colors.dart';
import 'package:laferia/core/constants/app_defaults.dart';

import 'constants.dart';

class AppTheme {
  // Colores base para ambos temas (inspirados en Tasty! app)
  static const Color primaryColor = Color(0xFFFF6B35); // Naranja principal
  static const Color primaryLightColor = Color(0xFFFF8A5B); // Naranja claro
  static const Color primaryDarkColor = Color(0xFFE55100); // Naranja oscuro
  static const Color secondaryColor = Color(0xFF2E2E2E); // Gris oscuro
  static const Color accentColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color grayWhiteColor = Color(0xFFFAFAFA);
  static const Color grayColor = Color(0xFFF5F5F5);
  static const Color grayLightColor = Color(0xFFE0E0E0);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color backgroundColor = Color(
    0xFFFFFBF8,
  ); // Fondo ligeramente cálido
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
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
      indicatorColor: secondaryColor,
      fontFamily: 'Kodchasan',
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
      textTheme: TextTheme(
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
        hintStyle: TextStyle(color: textSecondaryColor, fontSize: 16),
        labelStyle: TextStyle(color: textSecondaryColor, fontSize: 16),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Kodchasan',
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Kodchasan',
          ),
        ),
        iconTheme: MaterialStateProperty.all(
          const IconThemeData(color: secondaryColor, size: 24),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        disabledColor: Colors.grey.shade300,
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(color: secondaryColor),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: Color(
          0xFF90CAF9,
        ), // Versión más clara de azul para dark theme
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
      ),
      indicatorColor: Colors.white,
      fontFamily: 'Kodchasan',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.white),
        bodyMedium: TextStyle(color: AppColors.white),
        bodySmall: TextStyle(color: AppColors.white),
        titleLarge: TextStyle(
          fontSize: AppDefaults.fontSizeTitleLarge,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        titleMedium: TextStyle(
          fontSize: AppDefaults.fontSizeTitleMedium,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        titleSmall: TextStyle(
          fontSize: AppDefaults.fontSizeTitleSmall,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        labelMedium: TextStyle(
          color: AppColors.white,
          fontSize: AppDefaults.fontSizeLabelMedium,
          fontFamily: 'Kodchasan',
        ),
        labelLarge: TextStyle(
          color: AppColors.white,
          fontSize: AppDefaults.fontSizeSubTitle,
          fontFamily: 'Kodchasan',
        ),
        displayLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kodchasan',
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kodchasan',
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3E3E3E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3E3E3E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Kodchasan',
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: primaryColor.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Kodchasan',
          ),
        ),
        iconTheme: MaterialStateProperty.all(
          const IconThemeData(color: Colors.white70, size: 24),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        disabledColor: const Color(0xFF3E3E3E),
        selectedColor: primaryColor.withOpacity(0.3),
        secondarySelectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(color: Colors.white70),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(28)),
  borderSide: BorderSide(color: kTextColor),
  gapPadding: 10,
);
