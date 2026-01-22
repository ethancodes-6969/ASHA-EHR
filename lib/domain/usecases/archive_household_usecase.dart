import 'package:asha_ehr/domain/repositories/i_household_repository.dart';

class ArchiveHouseholdUseCase {
  final IHouseholdRepository repository;

  ArchiveHouseholdUseCase(this.repository);

  Future<void> call(String householdId) async {
    await repository.archiveHousehold(householdId);
  }
}
