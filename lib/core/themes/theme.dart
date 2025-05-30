import 'package:flutter/material.dart';
import 'package:laferia/core/constants/app_colors.dart';
import 'package:laferia/core/constants/app_defaults.dart';

import 'constants.dart';

class AppTheme {
  // Colores base para ambos temas
  static const Color primaryColor = Color(0xFF0BBFDF);
  static const Color secondaryColor = Color(0xFF09173D);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color grayWhiteColor = Color(0xFFF3F2FB);
  static const Color grayColor = Color(0xFFDEDEE2);
  static const Color geraintBlueColor = Color(0xFF9b98A9);
  static const Color bluishGrayColor = Color(0xFF676475);
  static const Color bluishBlackColor = Color(0xFF21223B);
  static const Color blueColor = Color(0xFF226AFE);
  static const Color blueBlackColor = Color(0xFF07051C);

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: grayWhiteColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: Colors.white,
        background: Color(0xFFF5F5F5),
      ),
      indicatorColor: secondaryColor,
      fontFamily: 'Kodchasan',
      appBarTheme: const AppBarTheme(
        backgroundColor: grayWhiteColor,
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
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: kTextColor),
        bodyMedium: TextStyle(color: kTextColor),
        bodySmall: TextStyle(color: kTextColor),
        titleLarge: TextStyle(
          fontSize: AppDefaults.fontSizeTitleLarge,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        titleMedium: TextStyle(
          fontSize: AppDefaults.fontSizeTitleMedium,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        titleSmall: TextStyle(
          fontSize: AppDefaults.fontSizeTitleSmall,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        labelMedium: TextStyle(
          color: AppColors.black,
          fontSize: AppDefaults.fontSizeLabelMedium,
          fontFamily: 'Kodchasan',
        ),
        labelLarge: TextStyle(
          color: AppColors.black,
          fontSize: AppDefaults.fontSizeSubTitle,
          fontFamily: 'Kodchasan',
        ),
        displayLarge: TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kodchasan',
        ),
        displayMedium: TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kodchasan',
        ),
        displaySmall: TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineLarge: TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineMedium: TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
        headlineSmall: TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Kodchasan',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
        labelStyle: const TextStyle(color: secondaryColor),
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
