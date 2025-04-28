import 'package:apimate/views/api_collections/api_collections.dart';
import 'package:apimate/views/api_list/api_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/get_api_list_model.dart';
import '../../views/api_request/api_response_view.dart';
import '../../views/views.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashView:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case RoutesName.apiRequestView:
        GetApiListModel? apiData = settings.arguments as GetApiListModel?;
        return MaterialPageRoute(
          builder: (context) => ApiRequestView(selectedApi: apiData),
        );
      case RoutesName.apiCollections:
        return MaterialPageRoute(
          builder: (context) => const ApiCollectionsScreen(),
        );
      case RoutesName.apiList:
        return MaterialPageRoute(
          builder:
              (context) =>
                  ApiListScreen(collectionID: settings.arguments as int),
        );
      case RoutesName.apiResponseView:
        return MaterialPageRoute(
          builder:
              (context) => ApiResponseView(
                response: settings.arguments as http.Response,
              ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const DefaultRouteScreenView(),
        );
    }
  }
}

class DefaultRouteScreenView extends StatelessWidget {
  const DefaultRouteScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Technical Error!")));
  }
}
