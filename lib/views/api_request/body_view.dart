import 'package:apimate/config/components/my_textfield.dart';
import 'package:flutter/material.dart';

class BodyView extends StatefulWidget {
  final TextEditingController controller;
  const BodyView({super.key, required this.controller});

  @override
  State<BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: MyTextfield(
          hint: "Enter Body Data Here {'type' : value}",
          controller: widget.controller,
        ),
      ),
    );
  }
}
