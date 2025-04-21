import 'package:flutter/material.dart';

class HeadersView extends StatefulWidget {
  const HeadersView({super.key});

  @override
  State<HeadersView> createState() => _HeadersViewState();
}

class _HeadersViewState extends State<HeadersView> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Headers"));
  }
}
