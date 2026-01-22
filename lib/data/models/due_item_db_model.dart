import 'package:asha_ehr/domain/entities/due_item.dart';

class DueItemDbModel {
  static const String tableName = 'due_items';
  
  static const String colId = 'id';
  static const String colMemberId = 'member_id';
  static const String colMemberName = 'member_name';
  static const String colHouseholdLocation = 'household_location';
  static const String colCoreCategory = 'core_category';
  static const String colProgramTag = 'program_tag';
  static const String colDueDate = 'due_date';
  static const String colGeneratedAt = 'generated_at';

  static const String colReason = 'reason';

  static Map<String, dynamic> toMap(DueItem item) {
    return {
      colId: item.id,
      colMemberId: item.memberId,
      colMemberName: item.memberName,
      colHouseholdLocation: item.householdLocation,
      colCoreCategory: item.coreCategory,
      colProgramTag: item.programTag,
      colDueDate: item.dueDate,
      colGeneratedAt: item.generatedAt,
      colReason: item.reason,
    };
  }

  static DueItem fromMap(Map<String, dynamic> map) {
    return DueItem(
      id: map[colId] as String,
      memberId: map[colMemberId] as String,
      memberName: map[colMemberName] as String,
      householdLocation: map[colHouseholdLocation] as String?,
      coreCategory: map[colCoreCategory] as String,
      programTag: map[colProgramTag] as String,
      dueDate: map[colDueDate] as int,
      generatedAt: map[colGeneratedAt] as int,
      reason: map[colReason] as String? ?? '',
    );
  }
}
