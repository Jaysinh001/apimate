import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/theme/color/colors.dart';
import 'package:flutter/material.dart';

import '../../config/utility/screen_config.dart';

class ApiListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;
  final String name;
  final String method;
  final String url;

  const ApiListTile({
    super.key,
    this.onTap,
    this.onDeleteTap,
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
            border: Border.all(
              color:
                  AppColors()
                      .getCurrentColorScheme(context: context)
                      .borderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: screenConfig.paddingH,
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(4, 2, 8, 2),
              horizontalTitleGap: 12,
              minLeadingWidth: 36,
              leading: MyText.bodyMedium(
                method,
                style: TextStyle(
                  color:
                      AppColors()
                          .getCurrentColorScheme(context: context)
                          .primary,
                ),
              ),
              title: MyText.bodyMedium(
                name,
                fontWeightType: FontWeightType.bold,
              ),
              subtitle: MyText.bodySmall(
                url,
                // maxLines: 1,
                style: TextStyle(
                  color:
                      AppColors()
                          .getCurrentColorScheme(context: context)
                          .secondary,
                ),
              ),
              trailing: GestureDetector(
                onTap: onDeleteTap,
                child: Icon(
                  Icons.delete,
                  color:
                      AppColors()
                          .getCurrentColorScheme(context: context)
                          .primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
