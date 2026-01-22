import 'package:asha_ehr/core/database/database_helper.dart';
import 'package:asha_ehr/data/models/member_db_model.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/repositories/i_member_repository.dart';
import 'package:sqflite/sqflite.dart';

class MemberRepositoryImpl implements IMemberRepository {
  final DatabaseHelper dbHelper;

  MemberRepositoryImpl(this.dbHelper);

  @override
  Future<List<Member>> getAllMembers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(MemberDbModel.tableName);
    return maps.map((map) => MemberDbModel.fromMap(map)).toList();
  }

  @override
  Future<List<Member>> getMembersByHousehold(String householdId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      MemberDbModel.tableName,
      where: '${MemberDbModel.colHouseholdId} = ?',
      whereArgs: [householdId],
      orderBy: '${MemberDbModel.colUpdatedAt} DESC',
    );

    return maps.map((map) => MemberDbModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveMember(Member member) async {
    final db = await dbHelper.database;
    await db.insert(
      MemberDbModel.tableName,
      MemberDbModel.toMap(member),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
