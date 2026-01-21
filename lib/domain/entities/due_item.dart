import 'package:equatable/equatable.dart';

class DueItem extends Equatable {
  final String id;
  final String memberId;
  final String memberName;
  final String? householdLocation;
  final String coreCategory; // 'MATERNAL', 'CHILD', etc.
  final String programTag; // 'ROUTINE', 'ANC_1', etc.
  final int dueDate;
  final int generatedAt;

  const DueItem({
    required this.id,
    required this.memberId,
    required this.memberName,
    this.householdLocation,
    required this.coreCategory,
    required this.programTag,
    required this.dueDate,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        memberId,
        memberName,
        householdLocation,
        coreCategory,
        programTag,
        dueDate,
        generatedAt,
      ];
}
