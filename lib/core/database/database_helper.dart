import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "asha_ehr.db";
  static const _databaseVersion = 7; // Bumped version

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
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }
  
  // Enable foreign keys
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // V1
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
    
    // V2
    if (version >= 2) {
       await _createMembersTable(db);
    }
    
    // V3
    if (version >= 3) {
      await _createVisitsTable(db);
    }

    // V4
    if (version >= 4) {
      await _createDueItemsTable(db);
    }

    // V5
    if (version >= 5) {
      await _createAshaDeviceTable(db);
    }

    // V6 (Indices)
    if (version >= 6) {
      await _createIndices(db);
    }

    // V7 (Clinical Fields)
    if (version >= 7) {
      await _addClinicalFields(db);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createMembersTable(db);
    }
    if (oldVersion < 3) {
      await _createVisitsTable(db);
    }
    if (oldVersion < 4) {
      await _createDueItemsTable(db);
    }
    if (oldVersion < 5) {
      await _createAshaDeviceTable(db);
    }
    if (oldVersion < 6) {
      await _createIndices(db);
    }
    if (oldVersion < 7) {
      await _addClinicalFields(db);
    }
  }

  Future<void> _createMembersTable(Database db) async {
    await db.execute('''
      CREATE TABLE members (
        id TEXT PRIMARY KEY,
        household_id TEXT NOT NULL,
        name TEXT NOT NULL,
        gender TEXT NOT NULL,
        date_of_birth INTEGER NOT NULL,
        id_proof_number TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_dirty INTEGER DEFAULT 1,
        FOREIGN KEY(household_id) REFERENCES households(id)
      )
    ''');
    
    // Index for fast lookups by household
    await db.execute('CREATE INDEX idx_members_household_id ON members(household_id)');
  }

  Future<void> _createVisitsTable(Database db) async {
    await db.execute('''
      CREATE TABLE visits (
        id TEXT PRIMARY KEY,
        member_id TEXT NOT NULL,
        visit_date INTEGER NOT NULL,
        core_category TEXT NOT NULL,
        program_tags TEXT,
        notes TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_dirty INTEGER DEFAULT 1,
        FOREIGN KEY(member_id) REFERENCES members(id)
      )
    ''');

    // Index for fast lookups by member
    await db.execute('CREATE INDEX idx_visits_member_id ON visits(member_id)');
  }

  Future<void> _createDueItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE due_items (
        id TEXT PRIMARY KEY,
        member_id TEXT NOT NULL,
        member_name TEXT NOT NULL,
        household_location TEXT,
        core_category TEXT NOT NULL,
        program_tag TEXT NOT NULL,
        due_date INTEGER NOT NULL,
        generated_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_due_items_date ON due_items(due_date)');
  }

  Future<void> _createAshaDeviceTable(Database db) async {
    await db.execute('''
      CREATE TABLE asha_device (
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _createIndices(Database db) async {
    await db.execute('CREATE INDEX IF NOT EXISTS idx_households_updated ON households(updated_at)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_members_household ON members(household_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_visits_member ON visits(member_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_visits_date ON visits(visit_date)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_due_items_date ON due_items(due_date)');
  }
  Future<void> _addClinicalFields(Database db) async {
    await db.execute('ALTER TABLE members ADD COLUMN is_pregnant INTEGER');
    await db.execute('ALTER TABLE members ADD COLUMN lmp_date INTEGER');
    await db.execute('ALTER TABLE members ADD COLUMN delivery_date INTEGER');
  }
}
