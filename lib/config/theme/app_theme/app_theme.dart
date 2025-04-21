import 'package:flutter/material.dart';
import '../../../bloc/theme_bloc/theme_bloc.dart';
import '../color/colors.dart';

class AppTheme {
  ThemeData getTheme({required ThemeNames theme}) {
    switch (theme) {
      case ThemeNames.dracula:
        return _buildTheme(AppColors.dracula);
      case ThemeNames.monokai:
        return _buildTheme(AppColors.monokai);
      case ThemeNames.solarized:
        return _buildTheme(AppColors.solarized);
      case ThemeNames.gruvbox:
        return _buildTheme(AppColors.gruvbox);
      case ThemeNames.nord:
        return _buildTheme(AppColors.nord);
    }
  }

  ThemeData _buildTheme(dynamic colors) {
    return ThemeData(
      scaffoldBackgroundColor: colors.background,
      primaryColor: colors.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBar,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light, // Ignored in your case
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        background: colors.background,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: colors.textPrimary,
        onBackground: colors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: colors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: colors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.secondary),
        ),
        labelStyle: TextStyle(color: colors.textSecondary),
        hintStyle: TextStyle(color: colors.textSecondary),
      ),
    );
  }
}
