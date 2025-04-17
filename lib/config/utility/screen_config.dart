import 'package:flutter/material.dart';

class ScreenConfig {
  final BuildContext context;
  late MediaQueryData _mediaQueryData;
  late double screenWidth;
  late double screenHeight;
  late double blockSizeHorizontal;
  late double blockSizeVertical;
  late Orientation orientation;

  ScreenConfig(this.context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    orientation = _mediaQueryData.orientation;
  }

  // Define breakpoints for responsive layouts
  bool isSmallScreen() => screenWidth < 600;
  bool isMediumScreen() => screenWidth >= 600 && screenWidth < 1200;
  bool isLargeScreen() => screenWidth >= 1200;

  // Screen aspect ratio
  double aspectRatio() => screenWidth / screenHeight;

  // Screen padding
  EdgeInsets get padding => _mediaQueryData.padding;
}
