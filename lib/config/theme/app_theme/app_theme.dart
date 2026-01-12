import 'package:apimate/main.dart';
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
      useMaterial3: true,

      // =====================================================
      // CORE
      // =====================================================
      scaffoldBackgroundColor: colors.background,
      primaryColor: colors.primary,
      dividerColor: colors.divider,

      // =====================================================
      // COLOR SCHEME
      // =====================================================
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        background: colors.background,
        error: colors.error,

        onPrimary: colors.textPrimary,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
        onBackground: colors.textPrimary,
        onError: Colors.white,
      ),

      // =====================================================
      // APP BAR
      // =====================================================
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBar,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.textPrimary),
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // =====================================================
      // TEXT
      // =====================================================
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
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: colors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: colors.textSecondary),
        bodySmall: TextStyle(fontSize: 12, color: colors.textSecondary),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),

      // =====================================================
      // ICONS
      // =====================================================
      iconTheme: IconThemeData(color: colors.textSecondary),

      // =====================================================
      // CARDS & PANELS
      // =====================================================
      cardColor: colors.cardBackground,
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.borderColor),
        ),
      ),

      // =====================================================
      // DIVIDER
      // =====================================================
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),

      // =====================================================
      // BUTTONS
      // =====================================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.textPrimary
        
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // =====================================================
      // INPUTS / TEXT FIELDS
      // =====================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.panelBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.focus),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.error),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: TextStyle(color: colors.textSecondary),
        hintStyle: TextStyle(color: colors.textSecondary),
      ),

      // =====================================================
      // LIST TILES
      // =====================================================
      listTileTheme: ListTileThemeData(
        iconColor: colors.textSecondary,
        textColor: colors.textPrimary,
        // tileColor: colors.cardBackground,
        selectedColor: colors.primary,
        selectedTileColor: colors.selection,
      ),

      // =====================================================
      // SNACKBAR / MESSAGES
      // =====================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.panelBackground,
        contentTextStyle: TextStyle(color: colors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // =====================================================
      // PROGRESS / LOADING
      // =====================================================
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surface,
        circularTrackColor: colors.surface,
      ),

      // =====================================================
      // TABS
      // =====================================================
      tabBarTheme: TabBarThemeData(
        indicatorColor: colors.primary,
        labelColor: colors.textPrimary,
        unselectedLabelColor: colors.textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // =====================================================
      // TOOLTIP
      // =====================================================
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.panelBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(color: colors.textPrimary),
      ),

      // =====================================================
      // BOTTOM SHEETS
      // =====================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.panelBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }
}
