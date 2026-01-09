import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/main.dart';
import 'package:flutter/material.dart';

class MyBottomsheet extends StatelessWidget {
  final List<Widget>? childerns;
  const MyBottomsheet({super.key, required this.childerns});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: currentTheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          ...childerns ?? [],

          MyGap(gap: (MediaQuery.of(context).viewInsets.bottom + 20)),
        ],
      ),
    );
  }
}
