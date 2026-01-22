import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:asha_ehr/data/models/visit_db_model.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/repositories/i_visit_repository.dart';
import 'package:sqflite/sqflite.dart';

class VisitRepositoryImpl implements IVisitRepository {
  final DatabaseHelper dbHelper;

  VisitRepositoryImpl(this.dbHelper);

  @override
  Future<List<Visit>> getAllVisits() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(VisitDbModel.tableName);
    return maps.map((map) => VisitDbModel.fromMap(map)).toList();
  }

  @override
  Future<List<Visit>> getVisitsByMember(String memberId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      VisitDbModel.tableName,
      where: '${VisitDbModel.colMemberId} = ?',
      whereArgs: [memberId],
      orderBy: '${VisitDbModel.colVisitDate} DESC',
    );

    return maps.map((map) => VisitDbModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveVisit(Visit visit) async {
    final db = await dbHelper.database;
    await db.insert(
      VisitDbModel.tableName,
      VisitDbModel.toMap(visit),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
