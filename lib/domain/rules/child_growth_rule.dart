import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/rules/clinical_rule.dart';

class ChildGrowthRule implements ClinicalRule {
  @override
  List<DueItem> evaluate({
    required Member member,
    required List<Visit> visits,
    required DateTime now,
  }) {
    if (member.dateOfBirth == null) return [];

    final dob = DateTime.fromMillisecondsSinceEpoch(member.dateOfBirth!);
    final ageInDays = now.difference(dob).inDays;
    
    // Rule: Age < 5 years (approx 1825 days)
    if (ageInDays > (5 * 365)) return [];

    // Rule: Growth monitoring every 60 days
    // Check last visit date
    // Sort visits descending
    final memberVisits = List<Visit>.from(visits)..sort((a, b) => b.visitDate.compareTo(a.visitDate));
    
    final lastVisit = memberVisits.isNotEmpty ? memberVisits.first : null;
    
    int daysSinceLastVisit;
    if (lastVisit == null) {
      daysSinceLastVisit = 9999; 
    } else {
      final lastDate = DateTime.fromMillisecondsSinceEpoch(lastVisit.visitDate);
      daysSinceLastVisit = now.difference(lastDate).inDays;
    }

    if (daysSinceLastVisit > 60) {
      final reason = lastVisit == null 
        ? "Child growth monitoring overdue — No visits recorded"
        : "Child growth monitoring overdue — last visit $daysSinceLastVisit days ago";
        
      return [
        DueItem(
          id: "${member.id}_CHILD_GROWTH",
          memberId: member.id,
          memberName: member.name,
          coreCategory: "CHILD",
          programTag: "Growth Monitoring",
          dueDate: now.millisecondsSinceEpoch,
          generatedAt: now.millisecondsSinceEpoch,
          reason: reason,
        )
      ];
    }

    return [];
  }
}
