import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
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

    // 1. Fetch EVERYTHING (MVP Style)
    final households = await householdRepository.getAllHouseholds();
    final List<DueItem> newDueItems = [];

    for (final household in households) {
      final members = await memberRepository.getMembersByHousehold(household.id);
      
      for (final member in members) {
        final visits = await visitRepository.getVisitsByMember(member.id);
        
        // Sort visits desc
        visits.sort((a, b) => b.visitDate.compareTo(a.visitDate));
        final lastVisit = visits.isNotEmpty ? visits.first : null;
        
        // Rule 1: Child (< 5 years) and No Visit > 60 days
        if (_isChild(member, now)) {
          if (_daysSince(lastVisit?.visitDate, now) > 60) {
             newDueItems.add(_createDueItem(
               member, 
               household.locationDescription,
               "CHILD", 
               "Growth Monitoring", 
               now, 
               generatedAt
             ));
             continue; // Prioritize Child rule, don't double add routine
          }
        }

        // Rule 2: Maternal (Has MATERNAL visit AND > 30 days since last)
        // Note: We check if ANY past visit was MATERNAL to tag them as "Active Maternal" for MVP
        final hasMaternalHistory = visits.any((v) => v.coreCategory == CoreVisitCategory.maternal);
        if (hasMaternalHistory) {
           final lastMaternalVisit = visits.firstWhere(
             (v) => v.coreCategory == CoreVisitCategory.maternal, 
             orElse: () => visits.first // Should be found if any() is true
           );
           
           if (_daysSince(lastMaternalVisit.visitDate, now) > 30) {
              newDueItems.add(_createDueItem(
                 member,
                 household.locationDescription,
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
             household.locationDescription,
             "ROUTINE", 
             "Routine Home Visit", 
             now, 
             generatedAt
           ));
        }
      }
    }

    // Replace DB
    await dueListRepository.replaceAll(newDueItems);
  }

  bool _isChild(Member member, DateTime now) {
    final dob = DateTime.fromMillisecondsSinceEpoch(member.dateOfBirth);
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
