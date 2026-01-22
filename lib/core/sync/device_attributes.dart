import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DeviceAttributes {
  static const String _prefKeyDeviceId = 'asha_device_id';
  static const String _tableDevice = 'asha_device';
  static const String _colId = 'id';
  static const String _colCreatedAt = 'created_at';

  final DatabaseHelper dbHelper;

  DeviceAttributes(this.dbHelper);

  Future<String> getDeviceId() async {
    // 1. Try SharedPreferences (Fastest)
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_prefKeyDeviceId);

    if (deviceId != null) {
      // Ensure backup exists (self-healing)
      await _ensureSqliteBackup(deviceId);
      return deviceId;
    }

    // 2. Try SQLite (Backup)
    deviceId = await _getDeviceIdFromSqlite();
    if (deviceId != null) {
      // Restore to Prefs
      await prefs.setString(_prefKeyDeviceId, deviceId);
      return deviceId;
    }

    // 3. Generate NEW (First Launch or Total Wipe)
    deviceId = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    // Save Dual Persistence
    await prefs.setString(_prefKeyDeviceId, deviceId);
    await _saveToSqlite(deviceId, now);

    return deviceId;
  }

  Future<String?> _getDeviceIdFromSqlite() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableDevice);
    if (maps.isNotEmpty) {
      return maps.first[_colId] as String;
    }
    return null;
  }

  Future<void> _saveToSqlite(String id, int createdAt) async {
    final db = await dbHelper.database;
    await db.insert(_tableDevice, {
      _colId: id,
      _colCreatedAt: createdAt,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _ensureSqliteBackup(String id) async {
    final existing = await _getDeviceIdFromSqlite();
    if (existing == null) {
      await _saveToSqlite(id, DateTime.now().millisecondsSinceEpoch);
    }
  }
}
