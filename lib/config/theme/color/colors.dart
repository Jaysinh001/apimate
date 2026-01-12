import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/theme_bloc/theme_bloc.dart';

class AppColors {
  static const dracula = _DraculaColors();
  static const monokai = _MonokaiColors();
  static const solarized = _SolarizedColors();
  static const gruvbox = _GruvboxColors();
  static const nord = _NordColors();

  static dynamic getCurrentColorScheme({required BuildContext context}) {
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

  // Core
  Color get primary => const Color(0xFFBD93F9);
  Color get secondary => const Color(0xFFFF79C6);
  Color get background => const Color(0xFF282A36);
  Color get surface => const Color(0xFF44475A);
  Color get appBar => const Color(0xFF44475A);

  // Text
  Color get textPrimary => Colors.white;
  Color get textSecondary => Colors.white70;

  // Borders & Dividers
  Color get borderColor => const Color(0xFF6272A4);
  Color get divider => const Color(0xFF3E4452);

  // Cards & Panels
  Color get cardBackground => const Color(0xFF343746);
  Color get panelBackground => const Color(0xFF2E303E);

  // States
  Color get success => const Color(0xFF50FA7B);
  Color get warning => const Color(0xFFFFB86C);
  Color get error => const Color(0xFFFF5555);
  Color get info => const Color(0xFF8BE9FD);

  // Selection / Focus
  Color get selection => const Color(0xFF44475A);
  Color get focus => const Color(0xFFBD93F9);
  Color get hover => const Color(0xFF3E4452);

  // API Methods
  Color get getMethod => const Color(0xFF50FA7B);
  Color get postMethod => const Color(0xFF8BE9FD);
  Color get putMethod => const Color(0xFFFFB86C);
  Color get deleteMethod => const Color(0xFFFF5555);

  // Response States
  Color get responseSuccess => const Color(0xFF1E3D2F);
  Color get responseError => const Color(0xFF3A1E1E);
  Color get responseWarning => const Color(0xFF3A2E1E);

  // Charts / Load Test
  Color get chartPrimary => const Color(0xFFBD93F9);
  Color get chartSecondary => const Color(0xFFFF79C6);
  Color get chartGrid => const Color(0xFF44475A);
  Color get chartActiveVUs => const Color(0xFF50FA7B); // Neon Green
  Color get chartRps => const Color(0xFF8BE9FD); // Cyan
  Color get chartLatency => const Color(0xFFFFB86C); // Orange
  Color get chartError => const Color(0xFFFF5555); // Red
}

class _MonokaiColors {
  const _MonokaiColors();

  // Core
  Color get primary => const Color(0xFFF92672);
  Color get secondary => const Color(0xFFA6E22E);
  Color get background => const Color(0xFF272822);
  Color get surface => const Color(0xFF49483E);
  Color get appBar => const Color(0xFF3E3D32);

  // Text
  Color get textPrimary => Colors.white;
  Color get textSecondary => Colors.white70;

  // Borders & Dividers
  Color get borderColor => const Color(0xFF75715E);
  Color get divider => const Color(0xFF3E3D32);

  // Cards & Panels
  Color get cardBackground => const Color(0xFF34352D);
  Color get panelBackground => const Color(0xFF2E2F28);

  // States
  Color get success => const Color(0xFFA6E22E);
  Color get warning => const Color(0xFFF4BF75);
  Color get error => const Color(0xFFF92672);
  Color get info => const Color(0xFF66D9EF);

  // Selection / Focus
  Color get selection => const Color(0xFF3E3D32);
  Color get focus => const Color(0xFFF92672);
  Color get hover => const Color(0xFF4A4A40);

  // API Methods
  Color get getMethod => const Color(0xFFA6E22E);
  Color get postMethod => const Color(0xFF66D9EF);
  Color get putMethod => const Color(0xFFF4BF75);
  Color get deleteMethod => const Color(0xFFF92672);

  // Response States
  Color get responseSuccess => const Color(0xFF1E3D2A);
  Color get responseError => const Color(0xFF3D1E1E);
  Color get responseWarning => const Color(0xFF3D2E1E);

  // Charts / Load Test
  Color get chartPrimary => const Color(0xFFF92672);
  Color get chartSecondary => const Color(0xFFA6E22E);
  Color get chartGrid => const Color(0xFF49483E);
  Color get chartActiveVUs => const Color(0xFFA6E22E); // Green
  Color get chartRps => const Color(0xFF66D9EF); // Blue
  Color get chartLatency => const Color(0xFFF4BF75); // Amber
  Color get chartError => const Color(0xFFF92672); // Magenta Red
}

class _SolarizedColors {
  const _SolarizedColors();

  // Core
  Color get primary => const Color(0xFF268BD2);
  Color get secondary => const Color(0xFF2AA198);
  Color get background => const Color(0xFFFDF6E3);
  Color get surface => const Color(0xFFEEE8D5);
  Color get appBar => const Color(0xFFEEE8D5);

  // Text
  Color get textPrimary => const Color(0xFF586E75);
  Color get textSecondary => const Color(0xFF657B83);

  // Borders & Dividers
  Color get borderColor => const Color(0xFF93A1A1);
  Color get divider => const Color(0xFFEEE8D5);

  // Cards & Panels
  Color get cardBackground => const Color(0xFFF5EFDC);
  Color get panelBackground => const Color(0xFFEEE8D5);

  // States
  Color get success => const Color(0xFF859900);
  Color get warning => const Color(0xFFB58900);
  Color get error => const Color(0xFFDC322F);
  Color get info => const Color(0xFF268BD2);

  // Selection / Focus
  Color get selection => const Color(0xFFEEE8D5);
  Color get focus => const Color(0xFF268BD2);
  Color get hover => const Color(0xFFF5EFDC);

  // API Methods
  Color get getMethod => const Color(0xFF859900);
  Color get postMethod => const Color(0xFF268BD2);
  Color get putMethod => const Color(0xFFB58900);
  Color get deleteMethod => const Color(0xFFDC322F);

  // Response States
  Color get responseSuccess => const Color(0xFFE6EED9);
  Color get responseError => const Color(0xFFF5DADA);
  Color get responseWarning => const Color(0xFFF1E8D5);

  // Charts / Load Test
  Color get chartPrimary => const Color(0xFF268BD2);
  Color get chartSecondary => const Color(0xFF2AA198);
  Color get chartGrid => const Color(0xFF93A1A1);
  Color get chartActiveVUs => const Color(0xFF859900); // Green
  Color get chartRps => const Color(0xFF268BD2); // Blue
  Color get chartLatency => const Color(0xFFB58900); // Yellow
  Color get chartError => const Color(0xFFDC322F); // Red
}

class _GruvboxColors {
  const _GruvboxColors();

  // Core
  Color get primary => const Color(0xFFFB4934);
  Color get secondary => const Color(0xFFB8BB26);
  Color get background => const Color(0xFF282828);
  Color get surface => const Color(0xFF504945);
  Color get appBar => const Color(0xFF3C3836);

  // Text
  Color get textPrimary => const Color(0xFFEBDBB2);
  Color get textSecondary => const Color(0xFFD5C4A1);

  // Borders & Dividers
  Color get borderColor => const Color(0xFF665C54);
  Color get divider => const Color(0xFF3C3836);

  // Cards & Panels
  Color get cardBackground => const Color(0xFF3C3836);
  Color get panelBackground => const Color(0xFF282828);

  // States
  Color get success => const Color(0xFFB8BB26);
  Color get warning => const Color(0xFFFABD2F);
  Color get error => const Color(0xFFFB4934);
  Color get info => const Color(0xFF83A598);

  // Selection / Focus
  Color get selection => const Color(0xFF504945);
  Color get focus => const Color(0xFFFB4934);
  Color get hover => const Color(0xFF665C54);

  // API Methods
  Color get getMethod => const Color(0xFFB8BB26);
  Color get postMethod => const Color(0xFF83A598);
  Color get putMethod => const Color(0xFFFABD2F);
  Color get deleteMethod => const Color(0xFFFB4934);

  // Response States
  Color get responseSuccess => const Color(0xFF24302A);
  Color get responseError => const Color(0xFF302424);
  Color get responseWarning => const Color(0xFF302E24);

  // Charts / Load Test
  Color get chartPrimary => const Color(0xFFFB4934);
  Color get chartSecondary => const Color(0xFFB8BB26);
  Color get chartGrid => const Color(0xFF504945);
  Color get chartActiveVUs => const Color(0xFFB8BB26); // Olive Green
  Color get chartRps => const Color(0xFF83A598); // Aqua
  Color get chartLatency => const Color(0xFFFABD2F); // Yellow
  Color get chartError => const Color(0xFFFB4934); // Red
}

class _NordColors {
  const _NordColors();

  // Core
  Color get primary => const Color(0xFF81A1C1);
  Color get secondary => const Color(0xFF88C0D0);
  Color get background => const Color(0xFF2E3440);
  Color get surface => const Color(0xFF434C5E);
  Color get appBar => const Color(0xFF3B4252);

  // Text
  Color get textPrimary => const Color(0xFFD8DEE9);
  Color get textSecondary => const Color(0xFFE5E9F0);

  // Borders & Dividers
  Color get borderColor => const Color(0xFF4C566A);
  Color get divider => const Color(0xFF3B4252);

  // Cards & Panels
  Color get cardBackground => const Color(0xFF3B4252);
  Color get panelBackground => const Color(0xFF2E3440);

  // States
  Color get success => const Color(0xFFA3BE8C);
  Color get warning => const Color(0xFFEBCB8B);
  Color get error => const Color(0xFFBF616A);
  Color get info => const Color(0xFF88C0D0);

  // Selection / Focus
  Color get selection => const Color(0xFF434C5E);
  Color get focus => const Color(0xFF81A1C1);
  Color get hover => const Color(0xFF4C566A);

  // API Methods
  Color get getMethod => const Color(0xFFA3BE8C);
  Color get postMethod => const Color(0xFF88C0D0);
  Color get putMethod => const Color(0xFFEBCB8B);
  Color get deleteMethod => const Color(0xFFBF616A);

  // Response States
  Color get responseSuccess => const Color(0xFF24302A);
  Color get responseError => const Color(0xFF302424);
  Color get responseWarning => const Color(0xFF302E24);

  // Charts / Load Test
  Color get chartPrimary => const Color(0xFF81A1C1);
  Color get chartSecondary => const Color(0xFF88C0D0);
  Color get chartGrid => const Color(0xFF434C5E);
  Color get chartActiveVUs => const Color(0xFFA3BE8C); // Green
  Color get chartRps => const Color(0xFF88C0D0); // Light Blue
  Color get chartLatency => const Color(0xFFEBCB8B); // Yellow
  Color get chartError => const Color(0xFFBF616A); // Red
}
