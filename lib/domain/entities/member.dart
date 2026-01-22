import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String householdId;
  final String name;
  final String gender; // 'M', 'F', 'O'
  final int? dateOfBirth; // Nullable (Epoch millis)
  final String? idProofNumber;
  final bool? isPregnant;
  final int? lmpDate;
  final int? deliveryDate;
  final int createdAt;
  final int updatedAt;
  final bool isArchived;

  const Member({
    required this.id,
    required this.householdId,
    required this.name,
    required this.gender,
    this.dateOfBirth,
    this.idProofNumber,
    this.isPregnant,
    this.lmpDate,
    this.deliveryDate,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  Member copyWith({
    String? id,
    String? householdId,
    String? name,
    String? gender,
    int? dateOfBirth,
    String? idProofNumber,
    bool? isPregnant,
    int? lmpDate,
    int? deliveryDate,
    int? createdAt,
    int? updatedAt,
    bool? isArchived,
  }) {
    return Member(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      idProofNumber: idProofNumber ?? this.idProofNumber,
      isPregnant: isPregnant ?? this.isPregnant,
      lmpDate: lmpDate ?? this.lmpDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
    id, 
    householdId, 
    name, 
    gender, 
    dateOfBirth, 
    idProofNumber, 
    isPregnant,
    lmpDate,
    deliveryDate,
    createdAt, 
    updatedAt,
    isArchived
  ];
}
