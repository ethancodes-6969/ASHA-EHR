import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/repositories/i_member_repository.dart';

class GetMembersByHouseholdUseCase {
  final IMemberRepository repository;

  GetMembersByHouseholdUseCase(this.repository);

  Future<List<Member>> call(String householdId) async {
    return await repository.getMembersByHousehold(householdId);
  }
}
