import 'package:apimate/views/api_collections/api_collections.dart';
import 'package:apimate/views/collection_detail_view/collection_detail_view.dart';
import 'package:apimate/views/import_collection/import_collection_view.dart';
import 'package:apimate/views/load_test/load_test_config_view.dart';
import 'package:apimate/views/load_test/load_test_live_view.dart';
import 'package:apimate/views/load_test/select_apis_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upgrader/upgrader.dart';

import '../../domain/model/collection_detail_model/collection_explorer_node.dart';
import '../../main.dart';
import '../../views/request_client/request_client_view.dart';
import '../../views/views.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashView:
        return MaterialPageRoute(builder: (context) => const SplashView());

      case RoutesName.apiCollections:
        return MaterialPageRoute(
          builder:
              (context) => UpgradeAlert(
                navigatorKey: navigatorKey,
                barrierDismissible: false,
                upgrader: Upgrader(
                  debugDisplayAlways: true,
                  durationUntilAlertAgain: Duration(hours: 1),
                ),
                child: const ApiCollectionsScreen(),
              ),
        );
      case RoutesName.importCollectionView:
        return MaterialPageRoute(
          builder: (context) => const ImportCollectionView(),
        );
      case RoutesName.collectionDetailView:
        final _id = settings.arguments;

        if (_id is int && _id > 0) {
          return MaterialPageRoute(
            builder: (context) => CollectionDetailView(collectionID: _id),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => const DefaultRouteScreenView(),
          );
        }
      case RoutesName.requestClientView:
        final _id = settings.arguments;

        if (_id is int && _id > 0) {
          return MaterialPageRoute(
            builder: (context) => RequestClientView(requestId: _id),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => const DefaultRouteScreenView(),
          );
        }
      case RoutesName.selectApisView:
        return MaterialPageRoute(
          builder:
              (context) => SelectApisView(
                tree: settings.arguments as List<CollectionExplorerNode>,
              ),
        );
      case RoutesName.loadTestConfigView:
        return MaterialPageRoute(
          builder:
              (context) => LoadTestConfigView(
                selectedRequestIds: settings.arguments as List<int>,
              ),
        );
      case RoutesName.loadTestLiveView:
        return MaterialPageRoute(builder: (context) => LoadTestLiveView());

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
