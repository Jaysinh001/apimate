import '../../../data/services/database_service.dart';
import '../../model/request_client_model/request_client_data_model.dart';

class RequestClientRepo {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Load everything required to execute a request
  Future<RequestClientData> loadRequest(int requestId) async {
    final db = await _dbService.database;

    // 1️⃣ Load request core
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

    // 2️⃣ Load headers
    final headerRows = await db.query(
      'headers',
      where: 'request_id = ? AND is_active = 1',
      whereArgs: [requestId],
    );

    final headers = <String, String>{};
    for (final row in headerRows) {
      headers[row['key'] as String] = row['value'] as String? ?? '';
    }

    // 3️⃣ Load query params
    final queryRows = await db.query(
      'query_params',
      where: 'request_id = ? AND is_active = 1',
      whereArgs: [requestId],
    );

    final queryParams = <String, String>{};
    for (final row in queryRows) {
      queryParams[row['key'] as String] = row['value'] as String? ?? '';
    }

    // 4️⃣ Load body (optional)
    final bodyRows = await db.query(
      'request_bodies',
      where: 'request_id = ?',
      whereArgs: [requestId],
      limit: 1,
    );

    RequestBodyData? body;

    if (bodyRows.isNotEmpty) {
      final row = bodyRows.first;
      body = RequestBodyData(
        type: RequestBodyType.raw,
        content: row['body'] as String? ?? '',
        contentType: row['content_type'] as String?,
      );
    }

    final int collectionId = request['collection_id'] as int;

    // 5️⃣ Load collection variables
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

    //  Build aggregate object
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
}
