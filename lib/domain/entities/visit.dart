import 'package:equatable/equatable.dart';
import 'package:asha_ehr/domain/enums/visit_type.dart';

class Visit extends Equatable {
  final String id;
  final String memberId;
  final int visitDate;
  final VisitType visitType;
  final List<String> programTags;
  final String? notes;
  final int createdAt;
  final int updatedAt;

  const Visit({
    required this.id,
    required this.memberId,
    required this.visitDate,
    required this.visitType,
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
        visitType,
        programTags,
        notes,
        createdAt,
        updatedAt,
      ];
}
