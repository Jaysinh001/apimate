import 'package:flutter/material.dart';

import '../../main.dart';
import 'my_text.dart';

class MyBtn extends StatelessWidget {
  final String? title;
  final Widget? btnWidget;
  final Color? btnColor;
  final Color? titleColor;
  final bool? isExpanded;
  final VoidCallback? onBtnTap;
  final bool? isOutlineButton; // New nullable boolean

  const MyBtn({
    super.key,
    this.title,
    this.btnWidget,
    required this.onBtnTap,
    this.btnColor,
    this.titleColor,
    this.isOutlineButton = false, // Defaulted to false for convenience
    this.isExpanded = true, // Defaulted to true for convenience
  });

  @override
  Widget build(BuildContext context) {
    // Shared content for both button types
    final Widget content = SizedBox(
      width: isExpanded == true ? double.infinity : null,
      child: Center(
        child:
            btnWidget ??
            MyText.bodyMedium(
              title ?? "",
              fontWeightType: FontWeightType.semiBold,
              style: TextStyle(
                color:
                    titleColor ??
                    (isOutlineButton == true
                        ? (btnColor ?? currentTheme.primary)
                        : currentTheme.textPrimary),
              ),
            ),
      ),
    );

    // Common shape
    final OutlinedBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );

    // Padding logic from your original code
    final EdgeInsets padding = EdgeInsets.all(
      MediaQuery.sizeOf(context).aspectRatio * 30,
    );

    if (isOutlineButton == true) {
      return OutlinedButton(
        onPressed: onBtnTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: btnColor ?? currentTheme.primary),
          padding: padding,
          shape: shape,
        ),
        child: content,
      );
    }

    return ElevatedButton(
      onPressed: onBtnTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor ?? currentTheme.primary,
        foregroundColor: titleColor ?? currentTheme.textPrimary,
        padding: padding,
        shape: shape,
        elevation:
            0, // Set to 0 to match the flat look of your previous Container
      ),
      child: content,
    );
  }
}
