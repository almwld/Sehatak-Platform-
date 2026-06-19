import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppTheme {
  // ==============================================
  // ☀️ الثيم الفاتح - Light Theme
  // ==============================================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Cairo',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: 'Cairo',
      ),
    ),
  );

  // ==============================================
  // 🌙 الثيم الداكن - Dark Theme
  // ==============================================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textLight,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Cairo',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: 'Cairo',
      ),
    ),
  );
}
