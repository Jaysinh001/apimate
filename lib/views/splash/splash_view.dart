import 'package:apimate/config/components/my_text.dart';
import 'package:flutter/material.dart';

import '../../config/routes/routes_name.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    closeSplash();
  }

  Future<void> closeSplash() async {
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.apiRequestView,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: MyText.bodyLarge("splash Screen")));
  }
}
