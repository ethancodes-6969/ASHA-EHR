import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:asha_ehr/data/models/household_db_model.dart';
import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';
import 'package:sqflite/sqflite.dart';

class HouseholdRepositoryImpl implements IHouseholdRepository {
  final DatabaseHelper dbHelper;

  HouseholdRepositoryImpl(this.dbHelper);

  @override
  @override
  Future<List<Household>> getAllHouseholds() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      HouseholdDbModel.tableName,
      where: '${HouseholdDbModel.colIsArchived} = 0',
      orderBy: '${HouseholdDbModel.colUpdatedAt} DESC',
    );

    return maps.map((map) => HouseholdDbModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveHousehold(Household household) async {
    final db = await dbHelper.database;
    // ConflictAlgorithm.replace is okay for Phase 1 as there are no foreign keys yet.
    await db.insert(
      HouseholdDbModel.tableName,
      HouseholdDbModel.toMap(household),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateHousehold(Household household) async {
    final db = await dbHelper.database;
    await db.update(
      HouseholdDbModel.tableName,
      HouseholdDbModel.toMap(household),
      where: '${HouseholdDbModel.colId} = ?',
      whereArgs: [household.id],
    );
  }

  @override
  Future<void> archiveHousehold(String id) async {
    final db = await dbHelper.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      HouseholdDbModel.tableName,
      {
        HouseholdDbModel.colIsArchived: 1,
        HouseholdDbModel.colUpdatedAt: now,
        HouseholdDbModel.colIsDirty: 1,
      },
      where: '${HouseholdDbModel.colId} = ?',
      whereArgs: [id],
    );
  }
}
