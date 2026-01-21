import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String householdId;
  final String name;
  final String gender; // 'M', 'F', 'O'
  final int dateOfBirth; // Epoch millis
  final String? idProofNumber;
  final int createdAt;
  final int updatedAt;

  const Member({
    required this.id,
    required this.householdId,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    this.idProofNumber,
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
    createdAt, 
    updatedAt
  ];
}
