import 'package:sqflite/sqflite.dart';

import '../../../data/services/database_service.dart';
import '../../model/import_collection_model/preview_node_model.dart';


class ImportCollectionRepo {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Imports a collection preview tree into local DB
  /// Returns the newly created collection ID
  Future<int> importCollection({
    required String collectionName,
    String? description,
    required List<ImportPreviewNode> previewTree,
  }) async {
    final db = await _dbService.database;
    final now = DateTime.now().toIso8601String();

    return await db.transaction<int>((txn) async {
      // 1️⃣ Insert collection
      final int collectionId = await txn.insert(
        'collections',
        {
          'name': collectionName,
          'description': description,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        },
      );

      // 2️⃣ Insert folders & requests recursively
      await _insertPreviewNodes(
        txn: txn,
        collectionId: collectionId,
        parentFolderId: null,
        nodes: previewTree,
      );

      // 3️⃣ Return collection id (commit happens automatically)
      return collectionId;
    });
  }

  /// Recursive insertion of preview nodes
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
        final int folderId = await txn.insert(
          'folders',
          {
            'collection_id': collectionId,
            'parent_folder_id': parentFolderId,
            'name': node.name,
            'order_index': orderIndex,
            'sync_status': 'local',
            'is_deleted': 0,
            'created_at': now,
            'updated_at': now,
          },
        );

        // Recurse into children
        await _insertPreviewNodes(
          txn: txn,
          collectionId: collectionId,
          parentFolderId: folderId,
          nodes: node.children ?? [],
        );
      }

      // 🔗 Request
      if (node.type == PreviewNodeType.request) {
        await txn.insert(
          'requests',
          {
            'collection_id': collectionId,
            'folder_id': parentFolderId,
            'name': node.name,
            'method': node.method ?? 'UNKNOWN',
            'url': '', // URL will be filled in next iteration
            'order_index': orderIndex,
            'sync_status': 'local',
            'is_deleted': 0,
            'created_at': now,
            'updated_at': now,
          },
        );
      }

      orderIndex++;
    }
  }
}
