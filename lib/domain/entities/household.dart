import 'package:equatable/equatable.dart';

class Household extends Equatable {
  final String id;
  final String familyHeadName;
  final String locationDescription;
  final int createdAt;
  final int updatedAt;
  final bool isArchived;

  const Household({
    required this.id,
    required this.familyHeadName,
    required this.locationDescription,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  Household copyWith({
    String? id,
    String? familyHeadName,
    String? locationDescription,
    int? createdAt,
    int? updatedAt,
    bool? isArchived,
  }) {
    return Household(
      id: id ?? this.id,
      familyHeadName: familyHeadName ?? this.familyHeadName,
      locationDescription: locationDescription ?? this.locationDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [id, familyHeadName, locationDescription, createdAt, updatedAt, isArchived];
}
