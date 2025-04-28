import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/theme/color/colors.dart';
import 'package:flutter/material.dart';

import '../../config/utility/screen_config.dart';

class ApiListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String name;
  final String method;
  final String url;

  const ApiListTile({
    super.key,
    this.onTap,
    required this.name,
    required this.method,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);
    return Padding(
      padding: screenConfig.padding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: screenConfig.paddingH,
            child: ListTile(
              leading: MyText.bodyMedium(
                method,
                style: TextStyle(color: AppColors.dracula.primary),
              ),
              title: MyText.bodyMedium(
                name,
                fontWeightType: FontWeightType.bold,
              ),
              subtitle: MyText.bodySmall(
                url,
                // maxLines: 1,
                style: TextStyle(color: AppColors.dracula.secondary),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
