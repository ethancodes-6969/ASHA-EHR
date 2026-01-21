import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';

class GetAllHouseholdsUseCase {
  final IHouseholdRepository repository;

  GetAllHouseholdsUseCase(this.repository);

  Future<List<Household>> call() async {
    return await repository.getAllHouseholds();
  }
}
