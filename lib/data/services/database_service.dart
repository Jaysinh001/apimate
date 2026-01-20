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

    String collection = '''CREATE TABLE collections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,                     -- cloud id (UUID)
  name TEXT NOT NULL,
  description TEXT,
  sync_status TEXT DEFAULT 'local',   -- local | synced | modified | deleted
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);''';
    String folder = '''CREATE TABLE folders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  collection_id INTEGER NOT NULL,
  parent_folder_id INTEGER,
  name TEXT NOT NULL,
  order_index INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_folder_id) REFERENCES folders(id) ON DELETE CASCADE
);
''';
    String request = '''CREATE TABLE requests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  collection_id INTEGER NOT NULL,
  folder_id INTEGER,
  name TEXT NOT NULL,
  method TEXT NOT NULL,
  url TEXT NOT NULL,
  order_index INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
  FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE
);
''';
    String headers = '''CREATE TABLE headers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  request_id INTEGER NOT NULL,
  key TEXT NOT NULL,
  value TEXT,
  is_active INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE
);
''';

    String requestAuth = '''CREATE TABLE request_auth (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  request_id INTEGER NOT NULL,
  type TEXT NOT NULL,               -- none | bearer | apikey | basic | oauth2
  token TEXT,                       -- bearer
  api_key TEXT,                     -- api key
  api_value TEXT,
  api_location TEXT,                -- header | query
  username TEXT,                    -- basic auth
  password TEXT,
  is_active INTEGER DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE
);
''';

    String queryParams = '''CREATE TABLE query_params (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  request_id INTEGER NOT NULL,
  key TEXT NOT NULL,
  value TEXT,
  is_active INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE
);
''';
    String requestBodies = '''CREATE TABLE request_bodies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  request_id INTEGER NOT NULL,
  mode TEXT,              -- raw | formdata | urlencoded | file | graphql
  content TEXT,           -- raw body / JSON
  content_type TEXT,
  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE
);
''';
    String responses = '''CREATE TABLE responses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  request_id INTEGER NOT NULL,
  name TEXT,
  status TEXT,
  status_code INTEGER,
  headers TEXT,            -- JSON
  body TEXT,
  response_time_ms INTEGER,
  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE
);
''';
    String loadTestRuns = '''CREATE TABLE load_test_runs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  collection_id INTEGER NOT NULL,
  name TEXT,
  total_requests INTEGER,
  concurrency INTEGER,
  duration_seconds INTEGER,
  started_at TEXT,
  finished_at TEXT,
  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,
  FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE
);
''';
    String loadTestResults = '''CREATE TABLE load_test_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  remote_id TEXT,
  load_test_run_id INTEGER NOT NULL,
  request_id INTEGER NOT NULL,
  status_code INTEGER,
  response_time_ms INTEGER,
  success INTEGER,          -- 1 = success, 0 = failure
  error_message TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY (load_test_run_id) REFERENCES load_test_runs(id) ON DELETE CASCADE,
  FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE
);
''';

    String collectionVariables = '''
CREATE TABLE collection_variables (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  collection_id INTEGER NOT NULL,

  key TEXT NOT NULL,
  value TEXT,

  is_active INTEGER DEFAULT 1,

  sync_status TEXT DEFAULT 'local',
  is_deleted INTEGER DEFAULT 0,
  last_synced_at TEXT,

  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,

  FOREIGN KEY (collection_id)
    REFERENCES collections(id)
    ON DELETE CASCADE,

  UNIQUE (collection_id, key)
);
''';

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(collection);
        await db.execute(folder);
        await db.execute(request);
        await db.execute(headers);
        await db.execute(requestAuth);
        await db.execute(queryParams);
        await db.execute(requestBodies);
        await db.execute(responses);
        await db.execute(loadTestRuns);
        await db.execute(loadTestResults);
        await db.execute(collectionVariables);
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
