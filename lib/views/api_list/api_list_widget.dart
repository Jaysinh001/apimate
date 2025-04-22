import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/theme/color/colors.dart';
import 'package:flutter/material.dart';

import '../../config/utility/screen_config.dart';

class ApiListTile extends StatelessWidget {
  final VoidCallback? onCollectionTap;
  final String name;

  const ApiListTile({super.key, this.onCollectionTap, required this.name});

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
            border: Border.all(color: Colors.white24, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: screenConfig.paddingH,
            child: ListTile(
              leading: MyText.bodyMedium(
                "GET",
                style: TextStyle(color: AppColors.dracula.primary),
              ),
              title: MyText.bodyMedium(
                name,
                fontWeightType: FontWeightType.bold,
              ),
              subtitle: MyText.bodySmall(
                "http://erp.mitconindia.com:5048/Production/ODataV4/Company('MCES')/WS_Payroll_OverTime",
                // maxLines: 1,
                style: TextStyle(color: AppColors.dracula.secondary),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(name),
            //     ListTile( title: Text(name),)
            //     Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
