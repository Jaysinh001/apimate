import 'package:flutter/material.dart';

class ParamsView extends StatefulWidget {
  const ParamsView({super.key});

  @override
  State<ParamsView> createState() => _ParamsViewState();
}

class _ParamsViewState extends State<ParamsView> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Params"));
  }
}
