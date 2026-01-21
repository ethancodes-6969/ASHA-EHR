import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';
import 'package:uuid/uuid.dart';

class CreateHouseholdUseCase {
  final IHouseholdRepository repository;

  CreateHouseholdUseCase(this.repository);

  Future<void> call({required String familyHeadName, required String locationDescription}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = const Uuid().v4();

    final household = Household(
      id: id,
      familyHeadName: familyHeadName,
      locationDescription: locationDescription,
      createdAt: now,
      updatedAt: now,
    );

    await repository.saveHousehold(household);
  }
}
