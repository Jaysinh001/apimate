import 'dart:convert';

import '../../../data/services/database_service.dart';
import '../../model/request_client_model/request_auth_model.dart';
import '../../model/request_client_model/request_client_data_model.dart';
import '../../model/request_client_model/request_draft_model.dart';
import '../../model/request_client_model/request_execution_input.dart';

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
    // 6️⃣ Load request auth
    // ======================
    final authRows = await db.query(
      'request_auth',
      where: 'request_id = ? AND is_active = 1',
      whereArgs: [requestId],
      limit: 1,
    );

    RequestAuth auth = RequestAuth.none();

    if (authRows.isNotEmpty) {
      final row = authRows.first;

      final type = row['type'] as String;

      auth = RequestAuth(
        type: _mapAuthType(type),
        token: row['token'] as String?,
        apiKey: row['api_key'] as String?,
        apiValue: row['api_value'] as String?,
        apiLocation: _mapApiLocation(row['api_location'] as String?),
        username: row['username'] as String?,
        password: row['password'] as String?,
        isActive: (row['is_active'] as int) == 1,
      );
    }

    // ======================
    // Build aggregate object
    // ======================
    return RequestClientData(
      requestId: requestId,
      method: request['method'] as String,
      rawUrl: request['url'] as String,
      headers: headers,
      auth: auth,
      queryParams: queryParams,
      body: body,
      collectionVariables: variables,
      inactiveCollectionVariables: inactiveKeys,
    );
  }

  Future<RequestExecutionInput> buildExecutionInput(
    RequestClientData data,
  ) async {
    RequestExecutionInput input = RequestExecutionInput(
      method: data.method,
      url: data.rawUrl,
      headers: Map.from(data.headers),
      queryParams: Map.from(data.queryParams),
      body: data.body?.content,
      contentType: data.body?.contentType,
    );

    // 🔥 APPLY AUTH HERE
    input = _applyAuth(input, data.auth);

    return input;

    // return _applyAuth(input, data.auth);
  }

  RequestExecutionInput _applyAuth(
    RequestExecutionInput input,
    RequestAuth auth,
  ) {
    if (!auth.isActive) return input;

    final headers = Map<String, String>.from(input.headers);
    final query = Map<String, String>.from(input.queryParams);

    switch (auth.type) {
      case AuthType.bearer:
        headers['Authorization'] = 'Bearer ${auth.token}';
        break;

      case AuthType.apiKey:
        if (auth.apiLocation == ApiKeyLocation.header) {
          headers[auth.apiKey!] = auth.apiValue!;
        } else {
          query[auth.apiKey!] = auth.apiValue!;
        }
        break;

      case AuthType.basic:
        final encoded = base64Encode(
          utf8.encode('${auth.username}:${auth.password}'),
        );
        headers['Authorization'] = 'Basic $encoded';
        break;

      default:
        break;
    }

    return RequestExecutionInput(
      method: input.method,
      url: input.url,
      headers: headers,
      queryParams: query,
      body: input.body,
      contentType: input.contentType,
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

      // =========================
      // 5️⃣ Save request auth
      // =========================
      await txn.delete(
        'request_auth',
        where: 'request_id = ?',
        whereArgs: [requestId],
      );

      if (draft.auth.isActive) {
        await txn.insert('request_auth', {
          'request_id': requestId,
          'type': draft.auth.type.name,
          'token': draft.auth.token,
          'api_key': draft.auth.apiKey,
          'api_value': draft.auth.apiValue,
          'api_location': draft.auth.apiLocation?.name,
          'username': draft.auth.username,
          'password': draft.auth.password,
          'is_active': 1,
          'created_at': now,
          'updated_at': now,
        });
      }
    });
  }

  AuthType _mapAuthType(String value) {
    switch (value) {
      case 'bearer':
        return AuthType.bearer;
      case 'apikey':
        return AuthType.apiKey;
      case 'basic':
        return AuthType.basic;
      case 'oauth2':
        return AuthType.oauth2;
      default:
        return AuthType.none;
    }
  }

  ApiKeyLocation? _mapApiLocation(String? value) {
    if (value == null) return null;
    return value == 'query' ? ApiKeyLocation.query : ApiKeyLocation.header;
  }
}
