import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../theme/color/colors.dart';

class MyLoader extends StatelessWidget {
  final double size;
  const MyLoader({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Platform.isAndroid
            ? const CupertinoActivityIndicator(
                color: AppColors.primaryColor,
              )
            : const CupertinoActivityIndicator(
                color: AppColors.primaryColor,
              ),
      ),
    );
  }
}
