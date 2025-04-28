import 'dart:developer';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import '../theme/color/colors.dart';

// import '../theme/color/colors.dart';

class Utility {
  static void showToastMessage(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      // backgroundColor: AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
    var spinkit = SpinKitPouringHourGlassRefined(
      color: AppColors().getCurrentColorScheme(context: context).primary,
      size: 50.0,
    );

    showDialog(
      context: context,
      builder:
          (context) => Column(
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
    );
  }

  static hideFullScreenLoader({required BuildContext context}) {
    if (Navigator.of(context).overlay != null) {
      Navigator.pop(context);
    }
  }
}
