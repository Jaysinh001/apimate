import 'package:sqflite/sqflite.dart';

import '../../../data/services/database_service.dart';
import '../../model/variable_model/collection_variable_model.dart';

class CollectionVariablesRepo {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Load all variables for a collection
  Future<List<CollectionVariable>> getVariables({
    required int collectionId,
  }) async {
    final db = await _dbService.database;

    final rows = await db.query(
      'collection_variables',
      where: 'collection_id = ? AND is_deleted = 0',
      whereArgs: [collectionId],
      orderBy: 'key ASC',
    );

    return rows.map(CollectionVariable.fromMap).toList();
  }

  /// Add a new variable
  Future<void> addVariable({
    required int collectionId,
    required String key,
    String? value,
  }) async {
    final db = await _dbService.database;
    final now = DateTime.now().toIso8601String();

    await db.insert(
      'collection_variables',
      {
        'collection_id': collectionId,
        'key': key,
        'value': value,
        'is_active': 1,
        'sync_status': 'local',
        'is_deleted': 0,
        'created_at': now,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Update variable value
  Future<void> updateVariableValue({
    required int variableId,
    required String? value,
  }) async {
    final db = await _dbService.database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      'collection_variables',
      {
        'value': value,
        'updated_at': now,
        'sync_status': 'modified',
      },
      where: 'id = ?',
      whereArgs: [variableId],
    );
  }

  /// Enable / disable variable
  Future<void> toggleVariable({
    required int variableId,
    required bool isActive,
  }) async {
    final db = await _dbService.database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      'collection_variables',
      {
        'is_active': isActive ? 1 : 0,
        'updated_at': now,
        'sync_status': 'modified',
      },
      where: 'id = ?',
      whereArgs: [variableId],
    );
  }

  /// Soft delete variable (future use)
  Future<void> deleteVariable({
    required int variableId,
  }) async {
    final db = await _dbService.database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      'collection_variables',
      {
        'is_deleted': 1,
        'updated_at': now,
        'sync_status': 'deleted',
      },
      where: 'id = ?',
      whereArgs: [variableId],
    );
  }
}
