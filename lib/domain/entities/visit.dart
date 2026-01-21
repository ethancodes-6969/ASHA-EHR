import 'package:equatable/equatable.dart';

enum CoreVisitCategory {
  routine,
  maternal,
  child,
  ncd,
  followUp,
  survey
}

class Visit extends Equatable {
  final String id;
  final String memberId;
  final int visitDate;
  final CoreVisitCategory coreCategory;
  final List<String> programTags;
  final String? notes;
  final int createdAt;
  final int updatedAt;

  const Visit({
    required this.id,
    required this.memberId,
    required this.visitDate,
    required this.coreCategory,
    required this.programTags,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        memberId,
        visitDate,
        coreCategory,
        programTags,
        notes,
        createdAt,
        updatedAt,
      ];
}
