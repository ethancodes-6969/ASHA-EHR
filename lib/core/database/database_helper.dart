import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "asha_ehr.db";
  static const _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE households (
        id TEXT PRIMARY KEY,
        family_head_name TEXT NOT NULL,
        location_description TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_dirty INTEGER DEFAULT 1
      )
    ''');
  }
}
