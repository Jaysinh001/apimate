import 'package:apimate/bloc/collection_bloc/collection_bloc.dart';
import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/components/my_textfield.dart';
import 'package:apimate/config/utility/screen_config.dart';
import 'package:apimate/config/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/components/my_bottomsheet.dart';
import '../../config/routes/routes_name.dart';

class AddCollectionBottomsheet extends StatelessWidget {
  AddCollectionBottomsheet({super.key});

  TextEditingController collectionName = TextEditingController();
  @override
  Widget build(BuildContext context) {
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

              if (collectionName.text.isNotEmpty) {
                context.read<CollectionBloc>().add(
                  CreateCollection(name: collectionName.text),
                );
              } else {
                Utility.showToastMessage(
                  "Collection Name Should Not Be Empty",
                  context,
                );
              }
            },
            title: "Add",
          ),
        ),

        Row(
          children: [
            Expanded(child: Divider(indent: 16, endIndent: 16)),
            MyText.bodyMedium("OR"),
            Expanded(child: Divider(indent: 16, endIndent: 16)),
          ],
        ),

        Padding(
          padding: screenConfig.padding,
          child: MyBtn(
            onBtnTap: () {
              Utility.showLog("Import Collection add button clicked!!");

              // context.read<CollectionBloc>().add(ImportCollectionFile());
              // Navigator.pop(context); // Closing the bottomsheet

              Navigator.pushNamed(context, RoutesName.importCollectionView);
            },
            title: "Import Collection File",
          ),
        ),
      ],
    );
  }
}
