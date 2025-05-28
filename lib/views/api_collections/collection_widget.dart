import 'package:apimate/config/utility/screen_config.dart';
import 'package:flutter/material.dart';

import '../../config/components/my_text.dart';
import '../../config/theme/color/colors.dart';

class CollectionTile extends StatelessWidget {
  final VoidCallback? onCollectionTap;
  final String name;

  const CollectionTile({super.key, this.onCollectionTap, required this.name});

  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);
    return Padding(
      padding: screenConfig.padding,
      child: GestureDetector(
        onTap: onCollectionTap,
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText.bodyMedium(
                  name,
                  style: TextStyle(
                    color:
                        AppColors()
                            .getCurrentColorScheme(context: context)
                            .primary,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color:
                      AppColors()
                          .getCurrentColorScheme(context: context)
                          .borderColor,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
