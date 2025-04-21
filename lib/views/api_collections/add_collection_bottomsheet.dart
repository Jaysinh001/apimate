import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/components/my_textfield.dart';
import 'package:flutter/material.dart';

import '../../config/components/my_bottomsheet.dart';

class AddCollectionBottomsheet extends StatelessWidget {
  const AddCollectionBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController collectionName = TextEditingController();
    return MyBottomsheet(
      childerns: [
        MyText.bodyMedium("Add new collection"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyTextfield(
            hint: "Enter New Collection Name",
            controller: collectionName,
          ),
        ),
        MyBtn(onBtnTap: () {}, title: "Add"),
      ],
    );
  }
}
