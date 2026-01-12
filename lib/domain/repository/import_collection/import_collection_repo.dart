// import 'package:sqflite/sqflite.dart';

// import '../../../data/services/database_service.dart';
// import '../../model/import_collection_model/preview_node_model.dart';
// import '../../model/import_collection_model/raw_import_model.dart';

// class ImportCollectionRepo {
//   final DatabaseService _dbService = DatabaseService.instance;

//   /// Imports a collection preview tree into local DB
//   /// Returns the newly created collection ID
//   Future<int> importCollection({
//     required String collectionName,
//     String? description,
//     required List<ImportPreviewNode> previewTree,
//   }) async {
//     final db = await _dbService.database;
//     final now = DateTime.now().toIso8601String();
//     // Required for Phase 2 : While Inserting the urls, headers etc.
//     final Map<ImportPreviewNode, int> requestIdMap = {};

//     return await db.transaction<int>((txn) async {
//       // 1️⃣ Insert collection
//       final int collectionId = await txn.insert('collections', {
//         'name': collectionName,
//         'description': description,
//         'sync_status': 'local',
//         'is_deleted': 0,
//         'created_at': now,
//         'updated_at': now,
//       });

//       // 2️⃣ Insert folders & requests recursively
//       await _insertPreviewNodes(
//         txn: txn,
//         collectionId: collectionId,
//         parentFolderId: null,
//         nodes: previewTree,
//         requestIdMap: requestIdMap

//       );

//       // 3️⃣ Return collection id (commit happens automatically)
//       return collectionId;
//     });
//   }

//     // /// Recursive insertion of preview nodes
//     // Future<void> _insertPreviewNodes({
//     //   required Transaction txn,
//     //   required int collectionId,
//     //   required int? parentFolderId,
//     //   required List<ImportPreviewNode> nodes,
//     //   required Map<ImportPreviewNode, int> requestIdMap,
//     // }) async {
//     //   final now = DateTime.now().toIso8601String();
//     //   int orderIndex = 0;

//     //   for (final node in nodes) {
//     //     // 📁 Folder
//     //     if (node.type == PreviewNodeType.folder) {
//     //       final int folderId = await txn.insert('folders', {
//     //         'collection_id': collectionId,
//     //         'parent_folder_id': parentFolderId,
//     //         'name': node.name,
//     //         'order_index': orderIndex,
//     //         'sync_status': 'local',
//     //         'is_deleted': 0,
//     //         'created_at': now,
//     //         'updated_at': now,
//     //       });

//     //       // Recurse into children
//     //       await _insertPreviewNodes(
//     //         txn: txn,
//     //         collectionId: collectionId,
//     //         parentFolderId: folderId,
//     //         nodes: node.children ?? [],
//     //         requestIdMap: requestIdMap
//     //       );
//     //     }

//     //     // 🔗 Request
//     //     if (node.type == PreviewNodeType.request) {
//     //      final int requestId = await txn.insert('requests', {
//     //         'collection_id': collectionId,
//     //         'folder_id': parentFolderId,
//     //         'name': node.name,
//     //         'method': node.method ?? 'UNKNOWN',
//     //         'url': '', // URL will be filled in next iteration
//     //         'order_index': orderIndex,
//     //         'sync_status': 'local',
//     //         'is_deleted': 0,
//     //         'created_at': now,
//     //         'updated_at': now,
//     //       });
//     //       // 🔑 store mapping
//     //       requestIdMap[node] = requestId;
//     //     }

//     //     orderIndex++;
//     //   }
//     // }

//     Future<void> _insertPreviewNodes({
//   required Transaction txn,
//   required int collectionId,
//   required int? parentFolderId,
//   required List<ImportPreviewNode> nodes,
//   required Map<ImportPreviewNode, int> requestIdMap,
//   required PostmanCollection postmanCollection,
// }) async {
//   final now = DateTime.now().toIso8601String();
//   int orderIndex = 0;

//   for (final node in nodes) {
//     // 📁 Folder
//     if (node.type == PreviewNodeType.folder) {
//       final int folderId = await txn.insert(
//         'folders',
//         {
//           'collection_id': collectionId,
//           'parent_folder_id': parentFolderId,
//           'name': node.name,
//           'order_index': orderIndex,
//           'sync_status': 'local',
//           'is_deleted': 0,
//           'created_at': now,
//           'updated_at': now,
//         },
//       );

//       await _insertPreviewNodes(
//         txn: txn,
//         collectionId: collectionId,
//         parentFolderId: folderId,
//         nodes: node.children ?? [],
//         requestIdMap: requestIdMap,
//         postmanCollection: postmanCollection,
//       );
//     }

//     // 🔗 Request
//     if (node.type == PreviewNodeType.request) {
//       final int requestId = await txn.insert(
//         'requests',
//         {
//           'collection_id': collectionId,
//           'folder_id': parentFolderId,
//           'name': node.name,
//           'method': node.method ?? 'UNKNOWN',
//           'url': '',
//           'order_index': orderIndex,
//           'sync_status': 'local',
//           'is_deleted': 0,
//           'created_at': now,
//           'updated_at': now,
//         },
//       );

//       requestIdMap[node] = requestId;

//       // ✅ hydrate immediately (no lookup needed)
//       final postmanRequest = node.postmanRequest;
//       if (postmanRequest != null) {
//         await _insertRequestDetails(
//           txn: txn,
//           requestId: requestId,
//           request: postmanRequest,
//         );
//       }
//     }

//     orderIndex++;
//   }
// }

//     Future<void> hydrateRequests({
//     required int collectionId,
//     required PostmanCollection postmanCollection,
//     required Map<ImportPreviewNode, int> requestIdMap,
//   }) async {
//     final db = await _dbService.database;

//     await db.transaction((txn) async {
//       await _hydrateItems(
//         txn: txn,
//         items: postmanCollection.item,
//         requestIdMap: requestIdMap,
//       );
//     });
//   }

//   Future<void> _hydrateItems({
//     required Transaction txn,
//     required List<PostmanItem>? items,
//     required Map<ImportPreviewNode, int> requestIdMap,
//   }) async {
//     if (items == null) return;

//     for (final item in items) {
//       if (item.isFolder) {
//         await _hydrateItems(
//           txn: txn,
//           items: item.item,
//           requestIdMap: requestIdMap,
//         );
//       }

//       if (item.isRequest) {
//         final previewNode = requestIdMap.keys.firstWhere(
//           (n) => n.name == item.name,
//           orElse: () => null,
//         );

//         if (previewNode == null) continue;

//         final requestId = requestIdMap[previewNode]!;

//         await _insertRequestDetails(
//           txn: txn,
//           requestId: requestId,
//           request: item.request!,
//         );
//       }
//     }
//   }

//   Future<void> _insertRequestDetails({
//     required Transaction txn,
//     required int requestId,
//     required PostmanRequest request,
//   }) async {
//     final now = DateTime.now().toIso8601String();

//     // URL
//     final String url =
//         request.url is String ? request.url : request.url?['raw'] ?? '';

//     await txn.update(
//       'requests',
//       {'url': url, 'updated_at': now},
//       where: 'id = ?',
//       whereArgs: [requestId],
//     );

//     // Headers
//     if (request.header is List) {
//       for (final h in request.header) {
//         await txn.insert('headers', {
//           'request_id': requestId,
//           'key': h['key'],
//           'value': h['value'],
//           'is_active': h['disabled'] == true ? 0 : 1,
//           'created_at': now,
//           'updated_at': now,
//         });
//       }
//     }

//     // Body
//     final body = request.body;
//     if (body != null) {
//       await txn.insert('request_bodies', {
//         'request_id': requestId,
//         'mode': body.mode,
//         'content': body.raw?.toString(),
//         'created_at': now,
//         'updated_at': now,
//       });
//     }
//   }
// }

// =========================================================================================================

import 'package:sqflite/sqflite.dart';

import '../../../data/services/database_service.dart';
import '../../model/import_collection_model/preview_node_model.dart';
import '../../model/import_collection_model/raw_import_model.dart';

class ImportCollectionRepo {
  final DatabaseService _dbService = DatabaseService.instance;

  /// ===============================
  /// PUBLIC ENTRY POINT
  /// ===============================
  ///
  /// Phase 1 + Phase 2 combined:
  /// - Creates collection
  /// - Inserts folder/request structure
  /// - Hydrates requests (URL, headers, body)
  ///
  /// Returns newly created collectionId
  Future<int> importCollection({
    required PostmanCollection postmanCollection,
    required List<ImportPreviewNode> previewTree,
  }) async {
    try {
      final db = await _dbService.database;
      final now = DateTime.now().toIso8601String();

      return await db.transaction<int>((txn) async {
        // 1️⃣ Insert collection
        final int collectionId = await txn.insert('collections', {
          'name': postmanCollection.info?.name ?? "UNKNOWN COLLECTION",
          'description': postmanCollection.info?.description,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        });

        // 2️⃣ Insert collection variables
        await _insertCollectionVariables(
          txn: txn,
          collectionId: collectionId,
          variables: postmanCollection.variable,
        );

        // 3️⃣ Insert folders + requests + hydrate
        await _insertPreviewNodes(
          txn: txn,
          collectionId: collectionId,
          parentFolderId: null,
          nodes: previewTree,
        );

        return collectionId;
      });
    } catch (e) {
      rethrow;
    }
  }

  /// ===============================
  /// COLLECTION VARIABLE INSERTION
  /// ===============================
  Future<void> _insertCollectionVariables({
    required Transaction txn,
    required int collectionId,
    required List<PostmanVariable>? variables,
  }) async {
    if (variables == null || variables.isEmpty) return;

    final now = DateTime.now().toIso8601String();

    for (final variable in variables) {
      final key = variable.key;
      if (key == null || key.toString().trim().isEmpty) continue;

      await txn.insert('collection_variables', {
        'collection_id': collectionId,
        'key': key,
        'value': variable.value?.toString(),
        'is_active': 1,
        'sync_status': 'local',
        'is_deleted': 0,
        'created_at': now,
        'updated_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  /// ===============================
  /// RECURSIVE STRUCTURE INSERTION
  /// ===============================
  Future<void> _insertPreviewNodes({
    required Transaction txn,
    required int collectionId,
    required int? parentFolderId,
    required List<ImportPreviewNode> nodes,
  }) async {
    final now = DateTime.now().toIso8601String();
    int orderIndex = 0;

    for (final node in nodes) {
      // 📁 Folder
      if (node.type == PreviewNodeType.folder) {
        final int folderId = await txn.insert('folders', {
          'collection_id': collectionId,
          'parent_folder_id': parentFolderId,
          'name': node.name,
          'order_index': orderIndex,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        });

        await _insertPreviewNodes(
          txn: txn,
          collectionId: collectionId,
          parentFolderId: folderId,
          nodes: node.children ?? [],
        );
      }

      // 🔗 Request
      if (node.type == PreviewNodeType.request) {
        final int requestId = await txn.insert('requests', {
          'collection_id': collectionId,
          'folder_id': parentFolderId,
          'name': node.name,
          'method': node.method ?? 'UNKNOWN',
          'url': '', // hydrated below
          'order_index': orderIndex,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        });

        // Phase 2: hydrate request details immediately
        final PostmanRequest? postmanRequest = node.postmanRequest;
        if (postmanRequest != null) {
          await _hydrateRequest(
            txn: txn,
            requestId: requestId,
            request: postmanRequest,
          );
        }
      }

      orderIndex++;
    }
  }

  /// ===============================
  /// REQUEST HYDRATION (PHASE 2)
  /// ===============================
  Future<void> _hydrateRequest({
    required Transaction txn,
    required int requestId,
    required PostmanRequest request,
  }) async {
    final now = DateTime.now().toIso8601String();

    // 1️⃣ URL
    final String url = _extractUrl(request.url);
    await txn.update(
      'requests',
      {'url': url, 'updated_at': now},
      where: 'id = ?',
      whereArgs: [requestId],
    );

    // 2️⃣ Headers
    if (request.header is List) {
      for (final header in request.header as List) {
        await txn.insert('headers', {
          'request_id': requestId,
          'key': header['key'],
          'value': header['value'],
          'is_active': header['disabled'] == true ? 0 : 1,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        });
      }
    }

    // 3️⃣ Body
    final body = request.body;
    if (body != null) {
      await txn.insert('request_bodies', {
        'request_id': requestId,
        'mode': body.mode,
        'content': body.raw?.toString(),
        'content_type': null,
        'sync_status': 'local',
        'is_deleted': 0,
        'created_at': now,
        'updated_at': now,
      });
    }
  }

  /// ===============================
  /// HELPERS
  /// ===============================
  String _extractUrl(dynamic url) {
    if (url is String) return url;
    if (url is Map && url['raw'] != null) return url['raw'];
    return '';
  }
}
