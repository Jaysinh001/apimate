import 'package:flutter/material.dart';
import '../color/colors.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.neutral100,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryBlueColor,
      surface: AppColors.surfaceColor,
      error: AppColors.mainRed,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.neutral100,
      onError: AppColors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: AppColors.neutral100),
      displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.neutral100),
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.neutral90),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.neutral70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.neutral50)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryBlueColor)),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.neutral100,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.neutral80,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryBlueColor,
      surface: AppColors.neutral80,
      error: AppColors.mainRed,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
      onError: AppColors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 64, fontWeight: FontWeight.bold, color: AppColors.white),
      displayMedium: TextStyle(
          fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.white),
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.neutral40),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.neutral50),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.neutral70)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryBlueColor)),
    ),
  );
}
