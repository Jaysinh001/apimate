import 'dart:developer';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import '../theme/color/colors.dart';

// import '../theme/color/colors.dart';

class Utility {
  // Add these static variables
  static const String _loaderDialogRoute = 'fullscreen_loader_dialog';
  static bool _isLoaderShowing = false;

  static void showToastMessage(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: currentTheme.textPrimary)),
      backgroundColor: currentTheme.surface,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        // borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      duration: const Duration(seconds: 4),
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // Ensure only one SnackBar is shown at a time
      ..showSnackBar(snackBar);
  }

  static void showLog(String message) {
    log(message);
  }

  static String formatDateTime({
    required DateTime dateTime,
    required String format,
  }) {
    return DateFormat(format).format(dateTime);
  }

  static const weekdayList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  static List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static String getDurationDifference(DateTime start, DateTime end) {
    // Calculate the difference
    Duration difference = end.difference(start);

    // Get hours and minutes from the duration
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;

    // Format the result
    String result = '';
    if (hours > 0) {
      result += '$hours hrs ';
    }
    result += '$minutes min';

    return result.trim();
  }

  static String prettyPrintJson(String jsonString) {
    var jsonObject = json.decode(jsonString);

    var encoder = const JsonEncoder.withIndent('  ');

    return encoder.convert(jsonObject);
  }

  static showFullScreenLoader({required BuildContext context, String? title}) {
    if (_isLoaderShowing) return;

    _isLoaderShowing = true;

    var spinkit = SpinKitPouringHourGlassRefined(
      color: currentTheme.primary,
      size: 50.0,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: RouteSettings(
        name: _loaderDialogRoute,
      ), // Assign unique route name
      builder:
          (context) => PopScope(
            canPop: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                spinkit,
                MyGap(gap: 8),
                MyText.bodyLarge(
                  title ?? "Please wait!",
                  style: TextStyle(
                    color:
                        AppColors()
                            .getCurrentColorScheme(context: context)
                            .primary,
                  ),
                ),
              ],
            ),
          ),
    ).then((_) {
      _isLoaderShowing = false;
    });
  }

  static hideFullScreenLoader({required BuildContext context}) {
    Utility.showLog("calling hideFullScreenLoader");

    if (!_isLoaderShowing) return;

    // Pop only if the loader dialog is on top of the stack
    Navigator.of(context).popUntil((route) {
      if (route.settings.name == _loaderDialogRoute) {
        // Found the loader dialog, pop it
        Navigator.of(context).pop();
        return true; // Stop the popUntil
      }
      // If loader is not found in the stack, stop without popping anything
      return !route.settings.name.toString().contains(_loaderDialogRoute);
    });

    _isLoaderShowing = false;
  }

  static Color getMethodColor(String method) {
    Color color;
    switch (method.toUpperCase()) {
      case 'GET':
        color = currentTheme.getMethod;
        break;
      case 'POST':
        color = currentTheme.postMethod;
        break;
      case 'PUT':
        color = currentTheme.putMethod;
        break;
      case 'DELETE':
        color = currentTheme.deleteMethod;
        break;
      default:
        color = currentTheme.secondary;
    }
    return color;
  }
}
