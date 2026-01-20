import 'package:flutter/material.dart';

abstract class AppColorScheme {
  // Core
  Color get primary;
  Color get secondary;
  Color get background;
  Color get surface;
  Color get appBar;

  // Text
  Color get textPrimary;
  Color get textSecondary;

  // Borders & Dividers
  Color get borderColor;
  Color get divider;

  // Cards & Panels
  Color get cardBackground;
  Color get panelBackground;

  // States
  Color get success;
  Color get warning;
  Color get error;
  Color get info;

  // Selection / Focus
  Color get selection;
  Color get focus;
  Color get hover;

  // API Methods
  Color get getMethod;
  Color get postMethod;
  Color get putMethod;
  Color get deleteMethod;

  // Response States
  Color get responseSuccess;
  Color get responseError;
  Color get responseWarning;

  // Charts / Load Test
  Color get chartPrimary;
  Color get chartSecondary;
  Color get chartGrid;
  Color get chartActiveVUs;
  Color get chartRps;
  Color get chartLatency;
  Color get chartError;
}
