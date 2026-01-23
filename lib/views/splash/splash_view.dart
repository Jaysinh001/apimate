import 'package:apimate/bloc/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes/routes_name.dart';
import '../../data/services/shared_preference_manager.dart';

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
    // Initialize the SharedPreferencesManager
    final sharedPreferencesManager = SharedPreferencesManager();
    await sharedPreferencesManager.init();

    final retrievedTheme = sharedPreferencesManager.getThemeName();

    context.read<ThemeBloc>().add(ChangeTheme(theme: retrievedTheme));

    await Future.delayed(Duration(seconds: 2));

    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.apiCollections,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/apimate_name_logo.png")),
    );
  }
}
