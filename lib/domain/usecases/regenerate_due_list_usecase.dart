import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/repositories/i_due_list_repository.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';
import 'package:asha_ehr/domain/repositories/i_member_repository.dart';
import 'package:asha_ehr/domain/repositories/i_visit_repository.dart';
import 'package:asha_ehr/domain/rules/anc_rule.dart';
import 'package:asha_ehr/domain/rules/child_growth_rule.dart';
import 'package:asha_ehr/domain/rules/pnc_rule.dart';
import 'package:asha_ehr/domain/rules/routine_rule.dart';

class RegenerateDueListUseCase {
  final IHouseholdRepository householdRepository;
  final IMemberRepository memberRepository;
  final IVisitRepository visitRepository;
  final IDueListRepository dueListRepository;

  RegenerateDueListUseCase({
    required this.householdRepository,
    required this.memberRepository,
    required this.visitRepository,
    required this.dueListRepository,
  });

  Future<void> call() async {
    final now = DateTime.now();
    final todayMillis = now.millisecondsSinceEpoch;
    final generatedAt = todayMillis;

    // 1. Fetch ALL Data (Batch Mode)
    final results = await Future.wait([
      householdRepository.getAllHouseholds(),
      memberRepository.getAllMembers(),
      visitRepository.getAllVisits(),
    ]);

    final households = results[0] as List<Household>;
    final members = results[1] as List<Member>;
    final visits = results[2] as List<Visit>;

    // 2. Index in Memory
    final householdMap = {
      for (final h in households) h.id: h
    };

    final visitsByMember = <String, List<Visit>>{};
    for (final v in visits) {
      if (!visitsByMember.containsKey(v.memberId)) {
        visitsByMember[v.memberId] = [];
      }
      visitsByMember[v.memberId]!.add(v);
    }

    final List<DueItem> newDueItems = [];
    final rules = [
      AncRule(),
      PncRule(),
      ChildGrowthRule(),
      RoutineRule(),
    ];

    // 3. Process Rules
    for (final member in members) {
      final household = householdMap[member.householdId];
      final memberVisits = visitsByMember[member.id] ?? [];
      
      for (final rule in rules) {
        final ruleItems = rule.evaluate(
          member: member,
          visits: memberVisits,
          now: now,
        );
        
        for (final item in ruleItems) {
           newDueItems.add(
             DueItem(
               id: item.id,
               memberId: item.memberId,
               memberName: item.memberName,
               householdLocation: household?.locationDescription,
               coreCategory: item.coreCategory,
               programTag: item.programTag,
               dueDate: item.dueDate,
               generatedAt: item.generatedAt,
               reason: item.reason,
             )
           );
        }
      }
    }

    // Replace DB
    await dueListRepository.replaceAll(newDueItems);
  }
}
