import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/theme_bloc/theme_bloc.dart';
import '../../../data/services/shared_preference_manager.dart';

class AppColors {
  static const dracula = _DraculaColors();
  static const monokai = _MonokaiColors();
  static const solarized = _SolarizedColors();
  static const gruvbox = _GruvboxColors();
  static const nord = _NordColors();

  dynamic getCurrentColorScheme({required BuildContext context}) {
    var theme = context.read<ThemeBloc>().state.theme;

    switch (theme) {
      case ThemeNames.dracula:
        return AppColors.dracula;
      case ThemeNames.monokai:
        return AppColors.monokai;
      case ThemeNames.solarized:
        return AppColors.solarized;
      case ThemeNames.gruvbox:
        return AppColors.gruvbox;
      case ThemeNames.nord:
        return AppColors.nord;
    }
  }
}

class _DraculaColors {
  const _DraculaColors();

  Color get primary => const Color(0xFFBD93F9);
  Color get secondary => const Color(0xFFFF79C6);
  Color get surface => const Color(0xFF44475A);
  Color get background => const Color(0xFF282A36);
  Color get textPrimary => Colors.white;
  Color get textSecondary => Colors.white70;
  Color get borderColor => const Color(0xFF6272A4);
  Color get appBar => const Color(0xFF44475A);
}

class _MonokaiColors {
  const _MonokaiColors();

  Color get primary => const Color(0xFFF92672);
  Color get secondary => const Color(0xFFA6E22E);
  Color get surface => const Color(0xFF49483E);
  Color get background => const Color(0xFF272822);
  Color get textPrimary => Colors.white;
  Color get textSecondary => Colors.white70;
  Color get borderColor => const Color(0xFF75715E);
  Color get appBar => const Color(0xFF3E3D32);
}

class _SolarizedColors {
  const _SolarizedColors();

  Color get primary => const Color(0xFF268BD2);
  Color get secondary => const Color(0xFF2AA198);
  Color get surface => const Color(0xFFEEE8D5);
  Color get background => const Color(0xFFFDF6E3);
  Color get textPrimary => const Color(0xFF586E75);
  Color get textSecondary => const Color(0xFF657B83);
  Color get borderColor => const Color(0xFF93A1A1);
  Color get appBar => const Color(0xFFEEE8D5);
}

class _GruvboxColors {
  const _GruvboxColors();

  Color get primary => const Color(0xFFFB4934);
  Color get secondary => const Color(0xFFB8BB26);
  Color get surface => const Color(0xFF504945);
  Color get background => const Color(0xFF282828);
  Color get textPrimary => const Color(0xFFEBDBB2);
  Color get textSecondary => const Color(0xFFD5C4A1);
  Color get borderColor => const Color(0xFF665C54);
  Color get appBar => const Color(0xFF3C3836);
}

class _NordColors {
  const _NordColors();

  Color get primary => const Color(0xFF81A1C1);
  Color get secondary => const Color(0xFF88C0D0);
  Color get surface => const Color(0xFF434C5E);
  Color get background => const Color(0xFF2E3440);
  Color get textPrimary => const Color(0xFFD8DEE9);
  Color get textSecondary => const Color(0xFFE5E9F0);
  Color get borderColor => const Color(0xFF4C566A);
  Color get appBar => const Color(0xFF3B4252);
}
