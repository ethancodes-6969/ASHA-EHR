import 'dart:convert';
import 'package:asha_ehr/domain/entities/visit.dart';

class VisitDbModel {
  static const String tableName = 'visits';

  static const String colId = 'id';
  static const String colMemberId = 'member_id';
  static const String colVisitDate = 'visit_date';
  static const String colCoreCategory = 'core_category';
  static const String colProgramTags = 'program_tags';
  static const String colNotes = 'notes';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colIsDirty = 'is_dirty';

  static Map<String, dynamic> toMap(Visit visit) {
    return {
      colId: visit.id,
      colMemberId: visit.memberId,
      colVisitDate: visit.visitDate,
      colCoreCategory: visit.coreCategory.name.toUpperCase(), // Enum to String
      colProgramTags: jsonEncode(visit.programTags), // List<String> to JSON
      colNotes: visit.notes,
      colCreatedAt: visit.createdAt,
      colUpdatedAt: visit.updatedAt,
      colIsDirty: 1,
    };
  }

  static Visit fromMap(Map<String, dynamic> map) {
    return Visit(
      id: map[colId] as String,
      memberId: map[colMemberId] as String,
      visitDate: map[colVisitDate] as int,
      coreCategory: _parseCategory(map[colCoreCategory] as String),
      programTags: _parseTags(map[colProgramTags] as String?),
      notes: map[colNotes] as String?,
      createdAt: map[colCreatedAt] as int,
      updatedAt: map[colUpdatedAt] as int,
    );
  }

  static CoreVisitCategory _parseCategory(String value) {
    return CoreVisitCategory.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => CoreVisitCategory.routine, // Default fallback
    );
  }

  static List<String> _parseTags(String? jsonTags) {
    if (jsonTags == null || jsonTags.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonTags);
      return decoded.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}
