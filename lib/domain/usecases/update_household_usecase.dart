import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';

class UpdateHouseholdUseCase {
  final IHouseholdRepository repository;

  UpdateHouseholdUseCase(this.repository);

  Future<void> call({
    required Household household,
    String? familyHeadName,
    String? locationDescription,
  }) async {
    final updated = household.copyWith(
      familyHeadName: familyHeadName,
      locationDescription: locationDescription,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await repository.updateHousehold(updated);
  }
}
