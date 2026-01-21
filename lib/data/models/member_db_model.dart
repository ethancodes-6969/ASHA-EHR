import 'package:asha_ehr/domain/entities/member.dart';

class MemberDbModel {
  static const String tableName = 'members';
  
  static const String colId = 'id';
  static const String colHouseholdId = 'household_id';
  static const String colName = 'name';
  static const String colGender = 'gender';
  static const String colDateOfBirth = 'date_of_birth';
  static const String colIdProofNumber = 'id_proof_number';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colIsDirty = 'is_dirty';

  static Map<String, dynamic> toMap(Member member) {
    return {
      colId: member.id,
      colHouseholdId: member.householdId,
      colName: member.name,
      colGender: member.gender,
      colDateOfBirth: member.dateOfBirth,
      colIdProofNumber: member.idProofNumber,
      colCreatedAt: member.createdAt,
      colUpdatedAt: member.updatedAt,
      colIsDirty: 1, 
    };
  }

  static Member fromMap(Map<String, dynamic> map) {
    return Member(
      id: map[colId] as String,
      householdId: map[colHouseholdId] as String,
      name: map[colName] as String,
      gender: map[colGender] as String,
      dateOfBirth: map[colDateOfBirth] as int,
      idProofNumber: map[colIdProofNumber] as String?,
      createdAt: map[colCreatedAt] as int,
      updatedAt: map[colUpdatedAt] as int,
    );
  }
}
