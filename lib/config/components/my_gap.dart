import 'package:flutter/material.dart';

class MyGap extends StatelessWidget {
  final double gap;
  final bool zeroHeight;
  final bool zeroWidth;
  const MyGap({
    super.key,
    required this.gap,
    this.zeroHeight = false,
    this.zeroWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: zeroHeight ? 0 : gap, width: zeroWidth ? 0 : gap);
  }
}
