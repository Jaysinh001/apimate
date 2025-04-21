import 'package:apimate/bloc/api_reqiest_bloc/api_request_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc/theme_bloc/theme_bloc.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';
import 'config/theme/app_theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => ApiRequestBloc()),
      ],

      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Apimate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme().getTheme(theme: state.theme),
            initialRoute: RoutesName.splashView,
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}
