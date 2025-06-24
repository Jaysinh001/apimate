import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apimate/main.dart';
import 'package:apimate/views/api_collections/add_collection_bottomsheet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../config/utility/utility.dart' show Utility;
import '../../domain/model/collection_file_model.dart';
import '../../domain/model/collection_list_model.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(const CollectionState()) {
    on<GetCollectionsFromLocalDB>(handleGetCollectionsFromLocalDB);
    on<CreateCollection>(handleCreateCollection);
    on<ImportCollectionFile>(handleImportCollectionFile);
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

  FutureOr<void> handleImportCollectionFile(
    ImportCollectionFile event,
    Emitter<CollectionState> emit,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path ?? '');

      final content = await file.readAsString();

      Utility.showLog("Picked File : $content");

      final importResponse = collectionFileModelFromJson(content);

      if (importResponse.info != null) {
        add(
          CreateCollection(name: importResponse.info?.name ?? 'New Collection'),
        );
      }
    } else {
      // User canceled the picker
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
}
