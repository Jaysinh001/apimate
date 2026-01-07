import 'package:apimate/domain/model/postman_export_model/export_postman_collection_model.dart';
import '../../../data/services/database_service.dart';

/// Repository responsible for exporting a collection
/// into Postman Collection v2.1 JSON format.
class PostmanExportRepo {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Export a collection by ID and return Postman JSON as String
  Future<String> exportCollection(int collectionId) async {
    final db = await _dbService.database;

    // ======================
    // 1️⃣ Load collection
    // ======================
    final collectionRows = await db.query(
      'collections',
      where: 'id = ? AND is_deleted = 0',
      whereArgs: [collectionId],
      limit: 1,
    );

    if (collectionRows.isEmpty) {
      throw Exception('Collection not found');
    }

    final collection = collectionRows.first;

    // ======================
    // 2️⃣ Load collection variables
    // ======================
    final variableRows = await db.query(
      'collection_variables',
      where: 'collection_id = ? AND is_deleted = 0',
      whereArgs: [collectionId],
    );

    final variables = variableRows
        .map(
          (row) => ExportPostmanVariable(
            key: row['key'] as String,
            value: row['value'] as String?,
          ),
        )
        .toList();

    // ======================
    // 3️⃣ Load root folders (parent_folder_id IS NULL)
    // ======================
    final folderRows = await db.query(
      'folders',
      where:
          'collection_id = ? AND parent_folder_id IS NULL AND is_deleted = 0',
      whereArgs: [collectionId],
      orderBy: 'order_index ASC',
    );

    final items = <ExportPostmanItem>[];

    for (final folder in folderRows) {
      items.add(await _buildFolderTree(folder['id'] as int));
    }

    // ======================
    // 4️⃣ Load root requests (not inside any folder)
    // ======================
    final requestRows = await db.query(
      'requests',
      where:
          'collection_id = ? AND folder_id IS NULL AND is_deleted = 0',
      whereArgs: [collectionId],
      orderBy: 'order_index ASC',
    );

    for (final req in requestRows) {
      items.add(await _buildRequestItem(req['id'] as int));
    }

    // ======================
    // 5️⃣ Build Postman collection
    // ======================
    final postmanCollection = ExportPostmanCollection(
      info: ExportPostmanInfo(
        name: collection['name'] as String,
        description: collection['description'] as String?,
      ),
      item: items,
      variable: variables,
    );

    return postmanCollection.toPrettyJson();
  }

  // ============================================================
  // Recursive folder → items
  // ============================================================
  Future<ExportPostmanItem> _buildFolderTree(int folderId) async {
    final db = await _dbService.database;

    final folderRows = await db.query(
      'folders',
      where: 'id = ? AND is_deleted = 0',
      whereArgs: [folderId],
      limit: 1,
    );

    if (folderRows.isEmpty) {
      throw Exception('Folder not found');
    }

    final folder = folderRows.first;
    final children = <ExportPostmanItem>[];

    // Load subfolders
    final subFolders = await db.query(
      'folders',
      where:
          'parent_folder_id = ? AND is_deleted = 0',
      whereArgs: [folderId],
      orderBy: 'order_index ASC',
    );

    for (final sub in subFolders) {
      children.add(await _buildFolderTree(sub['id'] as int));
    }

    // Load requests inside this folder
    final requests = await db.query(
      'requests',
      where:
          'folder_id = ? AND is_deleted = 0',
      whereArgs: [folderId],
      orderBy: 'order_index ASC',
    );

    for (final req in requests) {
      children.add(await _buildRequestItem(req['id'] as int));
    }

    return ExportPostmanItem(
      name: folder['name'] as String,
      item: children,
    );
  }

  // ============================================================
  // Request → PostmanItem
  // ============================================================
  Future<ExportPostmanItem> _buildRequestItem(int requestId) async {
    final db = await _dbService.database;

    // Load request
    final requestRows = await db.query(
      'requests',
      where: 'id = ? AND is_deleted = 0',
      whereArgs: [requestId],
      limit: 1,
    );

    if (requestRows.isEmpty) {
      throw Exception('Request not found');
    }

    final request = requestRows.first;

    // Load headers
    final headerRows = await db.query(
      'headers',
      where:
          'request_id = ? AND is_deleted = 0 AND is_active = 1',
      whereArgs: [requestId],
    );

    final headers = headerRows
        .map(
          (row) => ExportPostmanHeader(
            key: row['key'] as String,
            value: row['value'] as String? ?? '',
          ),
        )
        .toList();

    // Load query params
    final queryRows = await db.query(
      'query_params',
      where:
          'request_id = ? AND is_deleted = 0 AND is_active = 1',
      whereArgs: [requestId],
    );

    final queries = queryRows
        .map(
          (row) => ExportPostmanQuery(
            key: row['key'] as String,
            value: row['value'] as String? ?? '',
          ),
        )
        .toList();

    // Load body
    final bodyRows = await db.query(
      'request_bodies',
      where: 'request_id = ? AND is_deleted = 0',
      whereArgs: [requestId],
      limit: 1,
    );

    ExportPostmanBody? body;
    if (bodyRows.isNotEmpty) {
      final row = bodyRows.first;
      body = ExportPostmanBody(
        mode: row['mode'] as String? ?? 'raw',
        raw: row['content'] as String? ?? '',
      );
    }

    return ExportPostmanItem(
      name: request['name'] as String,
      request: ExportPostmanRequest(
        method: request['method'] as String,
        url: ExportPostmanUrl(
          raw: request['url'] as String,
        ),
        header: headers,
        body: body,
      ),
    );
  }
}
