import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseService {
  static Database? _db;

  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getDatabase();
      return _db!;
    }
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = p.join(databaseDirPath, "apimate_main_db.db");

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE collections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE apis (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            collection_id INTEGER,
            name TEXT NOT NULL,
            method TEXT NOT NULL,
            url TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE headers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            api_id INTEGER,
            key TEXT NOT NULL,
            value TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY (api_id) REFERENCES apis(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE bodies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            api_id INTEGER,
            content_type TEXT,
            body TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY (api_id) REFERENCES apis(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE TABLE query_params (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            api_id INTEGER,
            key TEXT NOT NULL,
            value TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY (api_id) REFERENCES apis(id) ON DELETE CASCADE
          );
        ''');
      },
    );

    return database;
  }

  Future<dynamic> executeQuery({
    required String sqlQuery,
    List<Object?>? arguments,
  }) async {
    final db = await DatabaseService.instance.database;

    final lowerSql = sqlQuery.trim().toLowerCase();

    if (lowerSql.startsWith('select')) {
      return await db.rawQuery(sqlQuery, arguments);
    } else if (lowerSql.startsWith('insert')) {
      return await db.rawInsert(sqlQuery, arguments);
    } else if (lowerSql.startsWith('update')) {
      return await db.rawUpdate(sqlQuery, arguments);
    } else if (lowerSql.startsWith('delete')) {
      return await db.rawDelete(sqlQuery, arguments);
    } else {
      throw UnsupportedError('Unsupported SQL operation');
    }
  }
}
