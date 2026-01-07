import 'package:apimate/bloc/api_list_bloc/api_list_bloc.dart';
import 'package:apimate/bloc/api_request_bloc/api_request_bloc.dart';
import 'package:apimate/bloc/collection_list_bloc/collection_list_bloc.dart';
import 'package:apimate/bloc/load_test/load_test_bloc.dart';
import 'package:apimate/config/utility/utility.dart';
import 'package:apimate/data/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import 'bloc/theme_bloc/theme_bloc.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';
import 'config/theme/app_theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

DatabaseService? databaseService;
void main() {
  WidgetsFlutterBinding.ensureInitialized;
  databaseService = DatabaseService.instance;

  Utility.showLog("database :: $databaseService");

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
        BlocProvider(create: (context) => CollectionListBloc()),
        BlocProvider(create: (context) => ApiListBloc()),
        BlocProvider(create: (context) => ApiRequestBloc()),
        BlocProvider(create: (context) => LoadTestBloc()),
      ],

      child: BlocBuilder<ThemeBloc, ThemeState>(
        buildWhen: (previous, current) => current.theme != previous.theme,
        builder: (context, state) {
          return MaterialApp(
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);

              // Calculate the scaled text factor using the clamp function to ensure it stays within a specified range.
              final scale = mediaQueryData.textScaler.clamp(
                minScaleFactor: 1.0, // Minimum scale factor allowed.
                maxScaleFactor: 1.2, // Maximum scale factor allowed.
              );

              return UpgradeAlert(
                child: MediaQuery(
                  data: mediaQueryData.copyWith(textScaler: scale),
                  child: child!,
                ),
              );
            },
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
