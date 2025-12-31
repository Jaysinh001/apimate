import 'package:flutter/material.dart';

class RequestTabs extends StatelessWidget {
  final TabController controller;
  const RequestTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      // padding: EdgeInsets.only(bottom: 0),
      dividerHeight: 0,
      tabs: [
        Tab(text: 'Params'),
        Tab(text: 'Headers'),
        Tab(text: 'Body'),
        Tab(text: 'Response'),
      ],
    );
  }
}
