import 'package:apimate/config/components/my_bottomsheet.dart';
import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/config/utility/utility.dart';
import 'package:apimate/views/api_collections/collection_widget.dart';
import 'package:flutter/material.dart';

import 'add_collection_bottomsheet.dart';

class ApiCollectionsScreen extends StatelessWidget {
  const ApiCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddCollectionBottomsheet();
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            MyNavbar(showBackBtn: false, title: "API Collections"),
            CollectionTile(
              name: "Mitcon",
              onCollectionTap: () {
                Utility.showLog("Mitcon clicked!");
              },
            ),
            CollectionTile(
              name: "Dhyey",
              onCollectionTap: () {
                Utility.showLog("Dhyey Clicked!");
              },
            ),

            CollectionTile(
              name: "Dhyey",
              onCollectionTap: () {
                Utility.showLog("Dhyey Clicked!");
              },
            ),
          ],
        ),
      ),
    );
  }
}
