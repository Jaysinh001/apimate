import 'package:flutter/material.dart';

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
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).aspectRatio * 30,
        ),
        decoration: BoxDecoration(
          color: btnColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: btnWidget ??
            MyText.bodyMedium(
              title ?? "",
              fontWeightType: FontWeightType.semiBold,
              style: TextStyle(
                color: titleColor ?? AppColors.white,
              ),
            ),
      ),
    );
  }
}
