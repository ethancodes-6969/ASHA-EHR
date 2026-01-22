import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/enums/visit_type.dart';

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
      colCoreCategory: visit.visitType.name,
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
      visitType: _parseVisitType(map[colCoreCategory] as String?),
      programTags: _parseTags(map[colProgramTags] as String?),
      notes: map[colNotes] as String?,
      createdAt: map[colCreatedAt] as int,
      updatedAt: map[colUpdatedAt] as int,
    );
  }

  static VisitType _parseVisitType(String? value) {
    if (value == null) return VisitType.ROUTINE;
    
    try {
      return VisitType.values.firstWhere(
        (e) => e.name == value.toUpperCase(),
      );
    } catch (_) {
      debugPrint('⚠️ Unknown VisitType "$value", defaulting to ROUTINE');
      return VisitType.ROUTINE;
    }
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
