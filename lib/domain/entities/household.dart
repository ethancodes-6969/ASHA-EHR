import 'package:equatable/equatable.dart';

class Household extends Equatable {
  final String id;
  final String familyHeadName;
  final String locationDescription;
  final int createdAt;
  final int updatedAt;

  const Household({
    required this.id,
    required this.familyHeadName,
    required this.locationDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, familyHeadName, locationDescription, createdAt, updatedAt];
}
