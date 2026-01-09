import 'package:apimate/bloc/theme_bloc/theme_bloc.dart';
import 'package:apimate/config/theme/app_theme/app_theme.dart';
import 'package:apimate/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/color/colors.dart';
import 'my_text.dart';

class MyBtn extends StatelessWidget {
  final String? title;
  final Widget? btnWidget;
  final Color? btnColor;
  final Color? titleColor;
  final VoidCallback onBtnTap;
  const MyBtn({
    super.key,
    this.title,
    this.btnWidget,
    required this.onBtnTap,
    this.btnColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBtnTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).aspectRatio * 30),
        decoration: BoxDecoration(
          color:
              btnColor ??
              currentTheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            btnWidget ??
            MyText.bodyMedium(
              title ?? "",
              fontWeightType: FontWeightType.semiBold,
              style: TextStyle(color: titleColor ?? currentTheme.textPrimary),
            ),
      ),
    );
  }
}
