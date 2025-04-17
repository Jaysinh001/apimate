import 'package:flutter/material.dart';

import '../theme/color/colors.dart';
import 'my_text.dart';

class MyNavbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackBtn;
  final VoidCallback? backBtnTap;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? trailing;

  const MyNavbar(
      {super.key,
      this.showBackBtn = true,
      this.backBtnTap,
      this.title,
      this.trailing,
      this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Visibility(
        visible: showBackBtn,
        child: GestureDetector(
          onTap: backBtnTap ?? () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neutral30)),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.neutral100,
            ),
          ),
        ),
      ),
      title: MyText.bodyLarge(
        title ?? "",
        fontWeightType: FontWeightType.bold,
        style: titleStyle ??
            const TextStyle(
              color: AppColors.neutral100,
              fontSize: 20,
            ),
      ),
      centerTitle: true,
      actions: [trailing ?? const SizedBox()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
