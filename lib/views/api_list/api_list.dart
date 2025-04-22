import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/views/api_list/api_list_widget.dart';
import 'package:flutter/material.dart';

import '../api_collections/add_collection_bottomsheet.dart';

class ApiListScreen extends StatelessWidget {
  final String collectionName;

  const ApiListScreen({super.key, required this.collectionName});

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
          children: [
            MyNavbar(title: "$collectionName API's"),
            ApiListTile(name: "WS_Payroll_EmployeeList"),
          ],
        ),
      ),
    );
  }
}
