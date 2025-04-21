import 'package:flutter/material.dart';

class AuthorizationView extends StatefulWidget {
  const AuthorizationView({super.key});

  @override
  State<AuthorizationView> createState() => _AuthorizationViewState();
}

class _AuthorizationViewState extends State<AuthorizationView> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Authorization"));
  }
}
