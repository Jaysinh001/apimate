import '../../../data/services/database_service.dart';
import '../../model/request_client_model/request_client_data_model.dart';
import '../../model/request_client_model/request_draft_model.dart';

class RequestClientRepo {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Load everything required to execute a request
  /// Load everything required to execute and edit a request
  Future<RequestClientData> loadRequest(int requestId) async {
    final db = await _dbService.database;

    // ======================
    // 1️⃣ Load request core
    // ======================
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
    final int collectionId = request['collection_id'] as int;

    // ======================
    // 2️⃣ Load headers
    // ======================
    final headerRows = await db.query(
      'headers',
      where: 'request_id = ? AND is_deleted = 0 AND is_active = 1',
      whereArgs: [requestId],
    );

    final headers = <String, String>{};
    for (final row in headerRows) {
      headers[row['key'] as String] = row['value'] as String? ?? '';
    }

    // ======================
    // 3️⃣ Load query params
    // ======================
    final queryRows = await db.query(
      'query_params',
      where: 'request_id = ? AND is_deleted = 0 AND is_active = 1',
      whereArgs: [requestId],
    );

    final queryParams = <String, String>{};
    for (final row in queryRows) {
      queryParams[row['key'] as String] = row['value'] as String? ?? '';
    }

    // ======================
    // 4️⃣ Load request body
    // ======================
    final bodyRows = await db.query(
      'request_bodies',
      where: 'request_id = ? AND is_deleted = 0',
      whereArgs: [requestId],
      limit: 1,
    );

    RequestBodyData? body;

    if (bodyRows.isNotEmpty) {
      final row = bodyRows.first;

      body = RequestBodyData(
        type: RequestBodyType.raw, // can map from `mode` later
        content: row['content'] as String? ?? '', // ✅ FIXED
        contentType: row['content_type'] as String?,
      );
    }

    // ======================
    // 5️⃣ Load collection variables
    // ======================
    final variableRows = await db.query(
      'collection_variables',
      where: 'collection_id = ? AND is_deleted = 0',
      whereArgs: [collectionId],
    );

    final Map<String, String?> variables = {};
    final Set<String> inactiveKeys = {};

    for (final row in variableRows) {
      final key = row['key'] as String;
      final value = row['value'] as String?;
      final isActive = (row['is_active'] as int) == 1;

      variables[key] = value;
      if (!isActive) {
        inactiveKeys.add(key);
      }
    }

    // ======================
    // 6️⃣ Build aggregate object
    // ======================
    return RequestClientData(
      requestId: requestId,
      method: request['method'] as String,
      rawUrl: request['url'] as String,
      headers: headers,
      queryParams: queryParams,
      body: body,
      collectionVariables: variables,
      inactiveCollectionVariables: inactiveKeys,
    );
  }

  Future<void> saveRequestDraft({
    required int requestId,
    required RequestDraft draft,
  }) async {
    final db = await _dbService.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      // =========================
      // 1️⃣ Update request URL
      // =========================
      await txn.update(
        'requests',
        {'url': draft.rawUrl, 'sync_status': 'modified', 'updated_at': now},
        where: 'id = ? AND is_deleted = 0',
        whereArgs: [requestId],
      );

      // =========================
      // 2️⃣ Replace headers
      // =========================
      await txn.delete(
        'headers',
        where: 'request_id = ?',
        whereArgs: [requestId],
      );

      for (final entry in draft.headers.entries) {
        await txn.insert('headers', {
          'request_id': requestId,
          'key': entry.key,
          'value': entry.value,
          'is_active': 1,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        });
      }

      // =========================
      // 3️⃣ Replace query params
      // =========================
      await txn.delete(
        'query_params',
        where: 'request_id = ?',
        whereArgs: [requestId],
      );

      for (final entry in draft.queryParams.entries) {
        await txn.insert('query_params', {
          'request_id': requestId,
          'key': entry.key,
          'value': entry.value,
          'is_active': 1,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        });
      }

      // =========================
      // 4️⃣ Upsert request body
      // =========================
      await txn.delete(
        'request_bodies',
        where: 'request_id = ?',
        whereArgs: [requestId],
      );

      if (draft.body != null && draft.body!.isNotEmpty) {
        await txn.insert('request_bodies', {
          'request_id': requestId,
          'mode': 'raw', // future-proof
          'content': draft.body,
          'content_type': draft.contentType,
          'sync_status': 'local',
          'is_deleted': 0,
          'created_at': now,
          'updated_at': now,
        });
      }
    });
  }
}
