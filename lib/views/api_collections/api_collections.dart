import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/config/routes/routes_name.dart';
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
            useSafeArea: true,
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
              name: "Mitcon (9)",
              onCollectionTap: () {
                Utility.showLog("Mitcon clicked!");
                Navigator.pushNamed(
                  context,
                  RoutesName.apiList,
                  arguments: "Mitcon",
                );
              },
            ),
            CollectionTile(
              name: "Dhyey (6)",
              onCollectionTap: () {
                Utility.showLog("Dhyey Clicked!");
                Navigator.pushNamed(
                  context,
                  RoutesName.apiList,
                  arguments: "Dhyey",
                );
              },
            ),

            CollectionTile(
              name: "PCA (4)",
              onCollectionTap: () {
                Utility.showLog("PCAs Clicked!");
                Navigator.pushNamed(
                  context,
                  RoutesName.apiList,
                  arguments: "PCA",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
