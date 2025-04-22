import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/components/my_textfield.dart';
import 'package:apimate/config/utility/screen_config.dart';
import 'package:apimate/config/utility/utility.dart';
import 'package:flutter/material.dart';

import '../../config/components/my_bottomsheet.dart';

class AddCollectionBottomsheet extends StatelessWidget {
  const AddCollectionBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController collectionName = TextEditingController();
    ScreenConfig screenConfig = ScreenConfig(context);
    return MyBottomsheet(
      childerns: [
        MyGap(gap: 20),
        MyText.h6("Add new collection"),
        Padding(
          padding: screenConfig.padding,
          child: MyTextfield(
            hint: "Enter New Collection Name",
            controller: collectionName,
          ),
        ),
        Padding(
          padding: screenConfig.padding,
          child: MyBtn(
            onBtnTap: () {
              Utility.showLog("New Collection add button clicked!!");
            },
            title: "Add",
          ),
        ),
      ],
    );
  }
}
