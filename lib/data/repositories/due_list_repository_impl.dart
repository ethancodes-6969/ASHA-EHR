import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:asha_ehr/data/models/due_item_db_model.dart';
import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/repositories/i_due_list_repository.dart';
import 'package:sqflite/sqflite.dart';

class DueListRepositoryImpl implements IDueListRepository {
  final DatabaseHelper dbHelper;

  DueListRepositoryImpl(this.dbHelper);

  @override
  Future<List<DueItem>> getAllDueItems() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DueItemDbModel.tableName,
      orderBy: '${DueItemDbModel.colDueDate} ASC',
    );

    return maps.map((map) => DueItemDbModel.fromMap(map)).toList();
  }

  @override
  Future<Map<String, int>> getStats() async {
    final db = await dbHelper.database;
    final total = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM ${DueItemDbModel.tableName}'
    ));
    
    // For now simple total, in future we can split by priority or category
    return {'total': total ?? 0};
  }

  @override
  Future<void> replaceAll(List<DueItem> items) async {
    final db = await dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete(DueItemDbModel.tableName);
      
      final batch = txn.batch();
      for (final item in items) {
        batch.insert(DueItemDbModel.tableName, DueItemDbModel.toMap(item));
      }
      await batch.commit(noResult: true);
    });
  }
}
