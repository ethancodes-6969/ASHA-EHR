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
  });

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
    updatedAt
  ];
}
