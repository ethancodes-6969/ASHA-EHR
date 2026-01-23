import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:asha_ehr/core/sync/device_attributes.dart';
import 'package:asha_ehr/data/models/household_db_model.dart';
import 'package:asha_ehr/data/models/member_db_model.dart';
import 'package:asha_ehr/data/models/visit_db_model.dart';
import 'package:asha_ehr/data/remote/firestore_helper.dart';
import 'package:asha_ehr/domain/repositories/i_sync_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SyncRepositoryImpl implements ISyncRepository {
  final DatabaseHelper dbHelper;
  final FirestoreHelper firestoreHelper;
  final DeviceAttributes deviceAttributes;

  static const String _prefLastSync = 'last_sync_timestamp';

  SyncRepositoryImpl({
    required this.dbHelper,
    required this.firestoreHelper,
    required this.deviceAttributes,
  });

  @override
  Future<int> push() async {
    final db = await dbHelper.database;
    final deviceId = await deviceAttributes.getDeviceId();
    int syncedCount = 0;

    // 1. Households
    syncedCount += await _pushTable(
      db, 
      HouseholdDbModel.tableName, 
      FirestoreHelper.colHouseholds, 
      deviceId,
    );

    // 2. Members
    syncedCount += await _pushTable(
      db, 
      MemberDbModel.tableName, 
      FirestoreHelper.colMembers, 
      deviceId,
    );

    // 3. Visits
    syncedCount += await _pushTable(
      db, 
      VisitDbModel.tableName, 
      FirestoreHelper.colVisits, 
      deviceId,
    );

    return syncedCount;
  }

  Future<int> _pushTable(Database db, String tableName, String collection, String deviceId) async {
    final dirtyRows = await db.query(tableName, where: 'is_dirty = 1');
    if (dirtyRows.isEmpty) return 0;

    // Map to Firestore JSON
    final docs = dirtyRows.map((row) {
      final map = Map<String, dynamic>.from(row);
      map['owner_device_id'] = deviceId;
      map.remove('is_dirty'); // Don't sync dirty flag
      return map;
    }).toList();

    // Batch Push
    // Naive batching of all docs. Ideally chunk by 500.
    // For MVP, if > 500, we'd loop. 
    // Assuming < 500 dirty items for now or simple loop.
    await firestoreHelper.pushBatch(collection, docs);

    // Mark CLEAN
    final ids = dirtyRows.map((r) => r['id'] as String).toList();
    final batch = db.batch();
    for (final id in ids) {
      batch.update(tableName, {'is_dirty': 0}, where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);

    return docs.length;
  }

  @override
  Future<void> pull() async {
    final lastSync = await getLastSyncTimestamp();
    final deviceId = await deviceAttributes.getDeviceId();
    final db = await dbHelper.database;

    // 1. Pull Households
    final remoteHouseholds = await firestoreHelper.pullSince(
      FirestoreHelper.colHouseholds, deviceId, lastSync
    );
    await _upsertLocal(db, HouseholdDbModel.tableName, remoteHouseholds);

    // 2. Pull Members
    final remoteMembers = await firestoreHelper.pullSince(
      FirestoreHelper.colMembers, deviceId, lastSync
    );
    await _upsertLocal(db, MemberDbModel.tableName, remoteMembers);

    // 3. Pull Visits
    final remoteVisits = await firestoreHelper.pullSince(
      FirestoreHelper.colVisits, deviceId, lastSync
    );
    await _upsertLocal(db, VisitDbModel.tableName, remoteVisits);

    // Update Timestamp
    final now = DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefLastSync, now);
  }

  Future<void> _upsertLocal(Database db, String tableName, List<Map<String, dynamic>> docs) async {
    if (docs.isEmpty) return;
    
    final batch = db.batch();
    for (final doc in docs) {
      final row = Map<String, dynamic>.from(doc);
      // Clean up remote fields not in SQLite
      row.remove('owner_device_id');
      
      // Mark as CLEAN (since it came from server, it matches server)
      row['is_dirty'] = 0; 
      
      batch.insert(
        tableName, 
        row, 
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<int> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefLastSync) ?? 0;
  }

  @override
  Future<void> setLastError(String? error) async {
    final prefs = await SharedPreferences.getInstance();
    if (error == null) {
      await prefs.remove('last_sync_error');
    } else {
      await prefs.setString('last_sync_error', error);
    }
  }

  @override
  Future<String?> getLastError() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_sync_error');
  }
}
