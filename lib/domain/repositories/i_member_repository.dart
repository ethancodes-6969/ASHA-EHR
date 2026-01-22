import 'package:asha_ehr/domain/entities/member.dart';

abstract class IMemberRepository {
  Future<List<Member>> getMembersByHousehold(String householdId);
  Future<List<Member>> getAllMembers(); // Internal use only
  Future<void> saveMember(Member member);
}
