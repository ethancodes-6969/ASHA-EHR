import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/enums/visit_type.dart';
import 'package:asha_ehr/domain/repositories/i_due_list_repository.dart';
import 'package:asha_ehr/domain/repositories/i_household_repository.dart';
import 'package:asha_ehr/domain/repositories/i_member_repository.dart';
import 'package:asha_ehr/domain/repositories/i_visit_repository.dart';

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
    // Parallelize fetches for speed? Sure, why not.
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

    // Sort visits once per list? Or just sort when needed?
    // Sorting small lists (max ~50 visits/member) is cheap.
    for (final list in visitsByMember.values) {
      list.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    }

    final List<DueItem> newDueItems = [];

    // 3. Process Rules
    for (final member in members) {
      final household = householdMap[member.householdId];
      final memberVisits = visitsByMember[member.id] ?? [];
      final lastVisit = memberVisits.isNotEmpty ? memberVisits.first : null;

      // Rule 1: Child (< 5 years) and No Visit > 60 days
      if (_isChild(member, now)) {
        if (_daysSince(lastVisit?.visitDate, now) > 60) {
           newDueItems.add(_createDueItem(
             member, 
             household?.locationDescription,
             "CHILD", 
             "Growth Monitoring", 
             now, 
             generatedAt
           ));
           continue; // Prioritize Child rule
        }
      }

      // Rule 2: Maternal (Has MATERNAL visit AND > 30 days since last)
      final hasMaternalHistory = memberVisits.any((v) => v.visitType == VisitType.ANC || v.visitType == VisitType.PNC);
      if (hasMaternalHistory) {
         final lastMaternalVisit = memberVisits.firstWhere(
           (v) => v.visitType == VisitType.ANC || v.visitType == VisitType.PNC, 
           orElse: () => memberVisits.first 
         );
         
         if (_daysSince(lastMaternalVisit.visitDate, now) > 30) {
            newDueItems.add(_createDueItem(
               member,
               household?.locationDescription,
               "MATERNAL", 
               "Maternal Follow-up", 
               now, 
               generatedAt
            ));
            continue;
         }
      }
      
      // Rule 3: Routine (No visit > 90 days)
      if (_daysSince(lastVisit?.visitDate, now) > 90) {
         newDueItems.add(_createDueItem(
           member, 
           household?.locationDescription,
           "ROUTINE", 
           "Routine Home Visit", 
           now, 
           generatedAt
         ));
      }
    }

    // Replace DB
    await dueListRepository.replaceAll(newDueItems);
  }

  bool _isChild(Member member, DateTime now) {
    if (member.dateOfBirth == null) return false;
    final dob = DateTime.fromMillisecondsSinceEpoch(member.dateOfBirth!);
    final ageInDays = now.difference(dob).inDays;
    return ageInDays < (5 * 365); 
  }

  int _daysSince(int? dateMillis, DateTime now) {
    if (dateMillis == null) return 9999; // Infinite if never visited
    final date = DateTime.fromMillisecondsSinceEpoch(dateMillis);
    return now.difference(date).inDays;
  }

  DueItem _createDueItem(
    Member member, 
    String? householdLocation, 
    String coreCategory, 
    String programTag, 
    DateTime now, 
    int generatedAt
  ) {
    // Deterministic ID: memberId + category + generatedAt (to keep it unique per run if needed, or just member+cat)
    // Actually, locking to memberId + category is better to avoid dupes, but since we regenerate scratch, random is fine?
    // User requested Deterministic ID: memberId + programTag + dueDate
    final dueDate = now.millisecondsSinceEpoch; // "Due Now"
    final id = "${member.id}_${programTag}_$dueDate";
    
    return DueItem(
      id: id,
      memberId: member.id,
      memberName: member.name,
      householdLocation: householdLocation,
      coreCategory: coreCategory,
      programTag: programTag,
      dueDate: dueDate,
      generatedAt: generatedAt,
    );
  }
}
