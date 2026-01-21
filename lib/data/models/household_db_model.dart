import 'package:asha_ehr/domain/entities/household.dart';

class HouseholdDbModel {
  static const String tableName = 'households';
  
  static const String colId = 'id';
  static const String colFamilyHeadName = 'family_head_name';
  static const String colLocationDescription = 'location_description';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colIsDirty = 'is_dirty';

  static Map<String, dynamic> toMap(Household household) {
    return {
      colId: household.id,
      colFamilyHeadName: household.familyHeadName,
      colLocationDescription: household.locationDescription,
      colCreatedAt: household.createdAt,
      colUpdatedAt: household.updatedAt,
      colIsDirty: 1, // Logic: updates/inserts are dirty by default
    };
  }

  static Household fromMap(Map<String, dynamic> map) {
    return Household(
      id: map[colId] as String,
      familyHeadName: map[colFamilyHeadName] as String,
      locationDescription: map[colLocationDescription] as String? ?? '',
      createdAt: map[colCreatedAt] as int,
      updatedAt: map[colUpdatedAt] as int,
    );
  }
}
