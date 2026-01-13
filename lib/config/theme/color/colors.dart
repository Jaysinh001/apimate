import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/theme_bloc/theme_bloc.dart';
import 'app_color_scheme.dart';

class AppColors {
  static const dracula = _DraculaColors();
  static const monokai = _MonokaiColors();
  static const solarized = _SolarizedColors();
  static const gruvbox = _GruvboxColors();
  static const nord = _NordColors();

  static AppColorScheme getCurrentColorScheme({required BuildContext context}) {
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

class _DraculaColors implements AppColorScheme {
  const _DraculaColors();

  // Core
  @override
  Color get primary => const Color(0xFFBD93F9);
  @override
  Color get secondary => const Color(0xFFFF79C6);
  @override
  Color get background => const Color(0xFF282A36);
  @override
  Color get surface => const Color(0xFF44475A);
  @override
  Color get appBar => const Color(0xFF44475A);

  // Text
  @override
  Color get textPrimary => Colors.white;
  @override
  Color get textSecondary => Colors.white70;

  // Borders & Dividers
  @override
  Color get borderColor => const Color(0xFF6272A4);
  @override
  Color get divider => const Color(0xFF3E4452);

  // Cards & Panels
  @override
  Color get cardBackground => const Color(0xFF343746);
  @override
  Color get panelBackground => const Color(0xFF2E303E);

  // States
  @override
  Color get success => const Color(0xFF50FA7B);
  @override
  Color get warning => const Color(0xFFFFB86C);
  @override
  Color get error => const Color(0xFFFF5555);
  @override
  Color get info => const Color(0xFF8BE9FD);

  // Selection / Focus
  @override
  Color get selection => const Color(0xFF44475A);
  @override
  Color get focus => const Color(0xFFBD93F9);
  @override
  Color get hover => const Color(0xFF3E4452);

  // API Methods
  @override
  Color get getMethod => const Color(0xFF50FA7B);
  @override
  Color get postMethod => const Color(0xFF8BE9FD);
  @override
  Color get putMethod => const Color(0xFFFFB86C);
  @override
  Color get deleteMethod => const Color(0xFFFF5555);

  // Response States
  @override
  Color get responseSuccess => const Color(0xFF1E3D2F);
  @override
  Color get responseError => const Color(0xFF3A1E1E);
  @override
  Color get responseWarning => const Color(0xFF3A2E1E);

  // Charts / Load Test
  @override
  Color get chartPrimary => const Color(0xFFBD93F9);
  @override
  Color get chartSecondary => const Color(0xFFFF79C6);
  @override
  Color get chartGrid => const Color(0xFF44475A);
  @override
  Color get chartActiveVUs => const Color(0xFF50FA7B); // Neon Green
  @override
  Color get chartRps => const Color(0xFF8BE9FD); // Cyan
  @override
  Color get chartLatency => const Color(0xFFFFB86C); // Orange
  @override
  Color get chartError => const Color(0xFFFF5555); // Red
}

class _MonokaiColors implements AppColorScheme {
  const _MonokaiColors();

  // Core
  @override
  Color get primary => const Color(0xFFF92672);
  @override
  Color get secondary => const Color(0xFFA6E22E);
  @override
  Color get background => const Color(0xFF272822);
  @override
  Color get surface => const Color(0xFF49483E);
  @override
  Color get appBar => const Color(0xFF3E3D32);

  // Text
  @override
  Color get textPrimary => Colors.white;
  @override
  Color get textSecondary => Colors.white70;

  // Borders & Dividers
  @override
  Color get borderColor => const Color(0xFF75715E);
  @override
  Color get divider => const Color(0xFF3E3D32);

  // Cards & Panels
  @override
  Color get cardBackground => const Color(0xFF34352D);
  @override
  Color get panelBackground => const Color(0xFF2E2F28);

  // States
  @override
  Color get success => const Color(0xFFA6E22E);
  @override
  Color get warning => const Color(0xFFF4BF75);
  @override
  Color get error => const Color(0xFFF92672);
  @override
  Color get info => const Color(0xFF66D9EF);

  // Selection / Focus
  @override
  Color get selection => const Color(0xFF3E3D32);
  @override
  Color get focus => const Color(0xFFF92672);
  @override
  Color get hover => const Color(0xFF4A4A40);

  // API Methods
  @override
  Color get getMethod => const Color(0xFFA6E22E);
  @override
  Color get postMethod => const Color(0xFF66D9EF);
  @override
  Color get putMethod => const Color(0xFFF4BF75);
  @override
  Color get deleteMethod => const Color(0xFFF92672);

  // Response States
  @override
  Color get responseSuccess => const Color(0xFF1E3D2A);
  @override
  Color get responseError => const Color(0xFF3D1E1E);
  @override
  Color get responseWarning => const Color(0xFF3D2E1E);

  // Charts / Load Test
  @override
  Color get chartPrimary => const Color(0xFFF92672);
  @override
  Color get chartSecondary => const Color(0xFFA6E22E);
  @override
  Color get chartGrid => const Color(0xFF49483E);
  @override
  Color get chartActiveVUs => const Color(0xFFA6E22E); // Green
  @override
  Color get chartRps => const Color(0xFF66D9EF); // Blue
  @override
  Color get chartLatency => const Color(0xFFF4BF75); // Amber
  @override
  Color get chartError => const Color(0xFFF92672); // Magenta Red
}

class _SolarizedColors implements AppColorScheme {
  const _SolarizedColors();

  // Core
  @override
  Color get primary => const Color(0xFF268BD2);
  @override
  Color get secondary => const Color(0xFF2AA198);
  @override
  Color get background => const Color(0xFFFDF6E3);
  @override
  Color get surface => const Color(0xFFEEE8D5);
  @override
  Color get appBar => const Color(0xFFEEE8D5);

  // Text
  @override
  Color get textPrimary => const Color(0xFF586E75);
  @override
  Color get textSecondary => const Color(0xFF657B83);

  // Borders & Dividers
  @override
  Color get borderColor => const Color(0xFF93A1A1);
  @override
  Color get divider => const Color(0xFFEEE8D5);

  // Cards & Panels
  @override
  Color get cardBackground => const Color(0xFFF5EFDC);
  @override
  Color get panelBackground => const Color(0xFFEEE8D5);

  // States
  @override
  Color get success => const Color(0xFF859900);
  @override
  Color get warning => const Color(0xFFB58900);
  @override
  Color get error => const Color(0xFFDC322F);
  @override
  Color get info => const Color(0xFF268BD2);

  // Selection / Focus
  @override
  Color get selection => const Color(0xFFEEE8D5);
  @override
  Color get focus => const Color(0xFF268BD2);
  @override
  Color get hover => const Color(0xFFF5EFDC);

  // API Methods
  @override
  Color get getMethod => const Color(0xFF859900);
  @override
  Color get postMethod => const Color(0xFF268BD2);
  @override
  Color get putMethod => const Color(0xFFB58900);
  @override
  Color get deleteMethod => const Color(0xFFDC322F);

  // Response States
  @override
  Color get responseSuccess => const Color(0xFFE6EED9);
  @override
  Color get responseError => const Color(0xFFF5DADA);
  @override
  Color get responseWarning => const Color(0xFFF1E8D5);

  // Charts / Load Test
  @override
  Color get chartPrimary => const Color(0xFF268BD2);
  @override
  Color get chartSecondary => const Color(0xFF2AA198);
  @override
  Color get chartGrid => const Color(0xFF93A1A1);
  @override
  Color get chartActiveVUs => const Color(0xFF859900); // Green
  @override
  Color get chartRps => const Color(0xFF268BD2); // Blue
  @override
  Color get chartLatency => const Color(0xFFB58900); // Yellow
  @override
  Color get chartError => const Color(0xFFDC322F); // Red
}

class _GruvboxColors implements AppColorScheme {
  const _GruvboxColors();

  // Core
  @override
  Color get primary => const Color(0xFFFB4934);
  @override
  Color get secondary => const Color(0xFFB8BB26);
  @override
  Color get background => const Color(0xFF282828);
  @override
  Color get surface => const Color(0xFF504945);
  @override
  Color get appBar => const Color(0xFF3C3836);

  // Text
  @override
  Color get textPrimary => const Color(0xFFEBDBB2);
  @override
  Color get textSecondary => const Color(0xFFD5C4A1);

  // Borders & Dividers
  @override
  Color get borderColor => const Color(0xFF665C54);
  @override
  Color get divider => const Color(0xFF3C3836);

  // Cards & Panels
  @override
  Color get cardBackground => const Color(0xFF3C3836);
  @override
  Color get panelBackground => const Color(0xFF282828);

  // States
  @override
  Color get success => const Color(0xFFB8BB26);
  @override
  Color get warning => const Color(0xFFFABD2F);
  @override
  Color get error => const Color(0xFFFB4934);
  @override
  Color get info => const Color(0xFF83A598);

  // Selection / Focus
  @override
  Color get selection => const Color(0xFF504945);
  @override
  Color get focus => const Color(0xFFFB4934);
  @override
  Color get hover => const Color(0xFF665C54);

  // API Methods
  @override
  Color get getMethod => const Color(0xFFB8BB26);
  @override
  Color get postMethod => const Color(0xFF83A598);
  @override
  Color get putMethod => const Color(0xFFFABD2F);
  @override
  Color get deleteMethod => const Color(0xFFFB4934);

  // Response States
  @override
  Color get responseSuccess => const Color(0xFF24302A);
  @override
  Color get responseError => const Color(0xFF302424);
  @override
  Color get responseWarning => const Color(0xFF302E24);

  // Charts / Load Test
  @override
  Color get chartPrimary => const Color(0xFFFB4934);
  @override
  Color get chartSecondary => const Color(0xFFB8BB26);
  @override
  Color get chartGrid => const Color(0xFF504945);
  @override
  Color get chartActiveVUs => const Color(0xFFB8BB26); // Olive Green
  @override
  Color get chartRps => const Color(0xFF83A598); // Aqua
  @override
  Color get chartLatency => const Color(0xFFFABD2F); // Yellow
  @override
  Color get chartError => const Color(0xFFFB4934); // Red
}

class _NordColors implements AppColorScheme {
  const _NordColors();

  // Core
  @override
  Color get primary => const Color(0xFF81A1C1);
  @override
  Color get secondary => const Color(0xFF88C0D0);
  @override
  Color get background => const Color(0xFF2E3440);
  @override
  Color get surface => const Color(0xFF434C5E);
  @override
  Color get appBar => const Color(0xFF3B4252);

  // Text
  @override
  Color get textPrimary => const Color(0xFFD8DEE9);
  @override
  Color get textSecondary => const Color(0xFFE5E9F0);

  // Borders & Dividers
  @override
  Color get borderColor => const Color(0xFF4C566A);
  @override
  Color get divider => const Color(0xFF3B4252);

  // Cards & Panels
  @override
  Color get cardBackground => const Color(0xFF3B4252);
  @override
  Color get panelBackground => const Color(0xFF2E3440);

  // States
  @override
  Color get success => const Color(0xFFA3BE8C);
  @override
  Color get warning => const Color(0xFFEBCB8B);
  @override
  Color get error => const Color(0xFFBF616A);
  @override
  Color get info => const Color(0xFF88C0D0);

  // Selection / Focus
  @override
  Color get selection => const Color(0xFF434C5E);
  @override
  Color get focus => const Color(0xFF81A1C1);
  @override
  Color get hover => const Color(0xFF4C566A);

  // API Methods
  @override
  Color get getMethod => const Color(0xFFA3BE8C);
  @override
  Color get postMethod => const Color(0xFF88C0D0);
  @override
  Color get putMethod => const Color(0xFFEBCB8B);
  @override
  Color get deleteMethod => const Color(0xFFBF616A);

  // Response States
  @override
  Color get responseSuccess => const Color(0xFF24302A);
  @override
  Color get responseError => const Color(0xFF302424);
  @override
  Color get responseWarning => const Color(0xFF302E24);

  // Charts / Load Test
  @override
  Color get chartPrimary => const Color(0xFF81A1C1);
  @override
  Color get chartSecondary => const Color(0xFF88C0D0);
  @override
  Color get chartGrid => const Color(0xFF434C5E);
  @override
  Color get chartActiveVUs => const Color(0xFFA3BE8C); // Green
  @override
  Color get chartRps => const Color(0xFF88C0D0); // Light Blue
  @override
  Color get chartLatency => const Color(0xFFEBCB8B); // Yellow
  @override
  Color get chartError => const Color(0xFFBF616A); // Red
}
