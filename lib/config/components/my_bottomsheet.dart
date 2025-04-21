import 'package:flutter/material.dart';

class MyBottomsheet extends StatelessWidget {
  final List<Widget>? childerns;
  const MyBottomsheet({super.key, required this.childerns});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          ...childerns ?? [],
        ],
      ),
    );
  }
}
