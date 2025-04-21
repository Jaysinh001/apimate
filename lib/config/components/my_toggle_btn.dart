import 'package:flutter/material.dart';

import '../theme/color/colors.dart';

class MyToggleBtn extends StatelessWidget {
  final bool value;
  final ValueChanged onChanged;
  const MyToggleBtn({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      // inactiveThumbColor: AppColors.neutral70,
      // trackOutlineColor: const WidgetStatePropertyAll(AppColors.neutral70),
      trackOutlineWidth: const WidgetStatePropertyAll(1.5),
    );
  }
}
