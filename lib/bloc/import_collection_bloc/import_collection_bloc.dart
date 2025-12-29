import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../config/utility/utility.dart';
import '../../domain/model/import_collection_model/preview_node_model.dart';
import '../../domain/model/import_collection_model/raw_import_model.dart';
import '../../domain/repository/import_collection/import_collection_repo.dart';

part 'import_collection_state.dart';
part 'import_collection_event.dart';

class ImportCollectionBloc
    extends Bloc<ImportCollectionEvent, ImportCollectionState> {
  ImportCollectionBloc() : super(const ImportCollectionState()) {
    on<ImportCollectionFile>(handleImportCollectionFile);
    on<BuildImportPreview>(handleBuildImportPreview);
    on<ImportDataToLocalStorage>(handleImportDataToLocalStorage);
  }

  Future<void> handleImportCollectionFile(
    ImportCollectionFile event,
    Emitter<ImportCollectionState> emit,
  ) async {
    try {
      Utility.showLog("handleImportCollectionFile 1");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      Utility.showLog("handleImportCollectionFile 2 : ${result?.count}");

      PostmanCollection collection = PostmanCollection();

      if (result != null) {
        emit(state.copyWith(status: ImportCollectionScreenStatus.loading));

        File file = File(result.files.single.path ?? '');

        final content = await file.readAsString();

        // MARK: IMPORT STEP 1
        // Firstly we will parse the json string into lossless mental models
        // Flow will be JSON String --> Map<String, dynamic> --> PostmanCollection model.
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(content);
          collection = PostmanCollection.fromJson(jsonMap);
          // saving the state of postman collection.
          emit(state.copyWith(postmanCollection: collection));

          Utility.showLog("collection.info : ${collection.info}\n");
        } catch (e) {
          Utility.showLog(
            "Technical error while Parsing the collection to raw models!\n${e.toString()}",
          );

          emit(
            state.copyWith(
              status: ImportCollectionScreenStatus.error,
              message:
                  "Technical error while Parsing the collection to raw models!",
            ),
          );
        }

        // MARK: IMPORT STEP 2
        // In Postman schema:
        //   1. A folder = item has item[] children
        //   2. A request = item has request
        // NOTE: An item can never be both

        Map<String, int> stats = {"folders": 0, "requests": 0};

        traverseItems(items: collection.item, stats: stats);

        Utility.showLog("Updated Stats : $stats");

        emit(
          state.copyWith(
            importFolderCount: stats["folders"],
            importRequestCount: stats["requests"],
          ),
        );

        add(BuildImportPreview());
      }
    } catch (e) {}
  }

  FutureOr<void> handleBuildImportPreview(
    BuildImportPreview event,
    Emitter<ImportCollectionState> emit,
  ) {
    final previewTree = buildPreviewTree(state.postmanCollection.item);

    emit(
      state.copyWith(
        status: ImportCollectionScreenStatus.preview,
        previewTree: previewTree,
      ),
    );
  }

  FutureOr<void> handleImportDataToLocalStorage(
    ImportDataToLocalStorage event,
    Emitter<ImportCollectionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ImportCollectionScreenStatus.loading));

      ImportCollectionRepo repo = ImportCollectionRepo();

      final res = await repo.importCollection(
        postmanCollection: state.postmanCollection,
        previewTree: state.previewTree,
      );
      Utility.showLog("handleImportDataToLocalStorage res : $res");
      if (res > 0) {
        emit(
          state.copyWith(
            status: ImportCollectionScreenStatus.imported,
            message: "Failed to import collection into local storage!",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ImportCollectionScreenStatus.error,
            message: "Something went wrong while inserting the data",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ImportCollectionScreenStatus.error,
          message: "Failed to insert the collection into local storage",
        ),
      );
      Utility.showLog("handleImportDataToLocalStorage Exception : $e");
    }
  }

  List<ImportPreviewNode> buildPreviewTree(List<PostmanItem>? items) {
    if (items == null) return [];

    return items.map((item) {
      // 📁 Folder
      if (item.isFolder) {
        return ImportPreviewNode(
          type: PreviewNodeType.folder,
          name: item.name ?? 'Unnamed Folder',
          children: buildPreviewTree(item.item),
        );
      }

      // 🔗 Request
      return ImportPreviewNode(
        type: PreviewNodeType.request,
        name: item.name ?? 'Unnamed Request',
        method: item.request?.method?.toUpperCase() ?? 'UNKNOWN',
        postmanRequest: item.request,
      );
    }).toList();
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

        final method = item.request?.method?.toUpperCase() ?? 'UNKNOWN';
        stats?[method] = (stats[method] ?? 0) + 1;
      }
    }
  }
}
