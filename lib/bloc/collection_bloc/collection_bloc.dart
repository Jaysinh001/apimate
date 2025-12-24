import 'dart:async';
import 'dart:convert';

import 'package:apimate/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../config/utility/utility.dart' show Utility;
import '../../domain/model/collection_list_model.dart';
import '../../domain/model/import_collection_model/raw_import_model.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(const CollectionState()) {
    on<GetCollectionsFromLocalDB>(handleGetCollectionsFromLocalDB);
    on<CreateCollection>(handleCreateCollection);
    on<DeleteCollection>(handleDeleteCollection);
  }

  Future<void> handleGetCollectionsFromLocalDB(
    GetCollectionsFromLocalDB event,
    Emitter<CollectionState> emit,
  ) async {
    emit(
      state.copyWith(collectionScreenStatus: CollectionScreenStatus.loading),
    );

    try {
      final query = '''SELECT * FROM collections''';

      final res = await databaseService?.executeQuery(sqlQuery: query);

      Utility.showLog("handleGetCollectionsFromLocalDB ::: $res");

      final collectionList = collectionListModelFromJson(jsonEncode(res));

      Utility.showLog("collectionListModelFromJson ::: $collectionList");

      emit(
        state.copyWith(
          collectionScreenStatus: CollectionScreenStatus.success,
          collectionList: collectionList,
        ),
      );
    } catch (e) {
      Utility.showLog("handleGetCollectionsFromLocalDB Exception ::: $e");

      emit(
        state.copyWith(
          collectionScreenStatus: CollectionScreenStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleCreateCollection(
    CreateCollection event,
    Emitter<CollectionState> emit,
  ) async {
    emit(
      state.copyWith(collectionScreenStatus: CollectionScreenStatus.loading),
    );

    try {
      final query =
          '''INSERT INTO collections (name, created_at, updated_at) VALUES (?, ?, ?)''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.name,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ],
      );

      Utility.showLog("handleGetCollectionsFromLocalDB ::: $res");

      if (res != null) {
        emit(
          state.copyWith(
            collectionScreenStatus: CollectionScreenStatus.created,
            message: "Collection created successfully!",
          ),
        );

        add(GetCollectionsFromLocalDB());
      } else {
        emit(
          state.copyWith(
            collectionScreenStatus: CollectionScreenStatus.error,
            message: "Failed to create your collection",
          ),
        );
      }
    } catch (e) {
      Utility.showLog("handleGetCollectionsFromLocalDB Exception ::: $e");

      emit(
        state.copyWith(
          collectionScreenStatus: CollectionScreenStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleDeleteCollection(
    DeleteCollection event,
    Emitter<CollectionState> emit,
  ) async {
    emit(
      state.copyWith(collectionScreenStatus: CollectionScreenStatus.loading),
    );

    try {
      String query = '''DELETE FROM collections WHERE id = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [event.id],
      );

      if (res == 1) {
        state.collectionList.removeWhere((element) => element.id == event.id);

        emit(
          state.copyWith(
            collectionScreenStatus: CollectionScreenStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            collectionScreenStatus: CollectionScreenStatus.error,
            message: "Technical error while deleting the collection!",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          collectionScreenStatus: CollectionScreenStatus.error,
          message: "Oops! Something went wrong",
        ),
      );
    }
  }

  void traverseItems({List<PostmanItem>? items, Map<String, int>? stats}) {
    if (items == null) return;

    for (final item in items) {
      // 📁 Folder
      if (item.isFolder) {
        stats?["folders"] = (stats["folders"] ?? 0) + 1;
        traverseItems(items: item.item, stats: stats);
      }

      // 🔗 Request
      if (item.isRequest) {
        stats?["requests"] = (stats["requests"] ?? 0) + 1;

        // stats.requestCount++;

        final method = item.request?.method?.toUpperCase() ?? 'UNKNOWN';
        stats?[method] = (stats[method] ?? 0) + 1;

        // stats.methodCount[method] = (stats.methodCount[method] ?? 0) + 1;
      }
    }
  }
}
