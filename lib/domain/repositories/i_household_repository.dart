import 'package:asha_ehr/domain/entities/household.dart';

abstract class IHouseholdRepository {
  Future<List<Household>> getAllHouseholds();
  Future<void> saveHousehold(Household household);
  Future<void> updateHousehold(Household household);
  Future<void> archiveHousehold(String id);
}
