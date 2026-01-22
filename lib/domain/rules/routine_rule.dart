import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/rules/clinical_rule.dart';

class RoutineRule implements ClinicalRule {
  @override
  List<DueItem> evaluate({
    required Member member,
    required List<Visit> visits,
    required DateTime now,
  }) {
    // Routine check for everyone? Or only those not covered by other rules?
    // Spec says: "Applies to all members. No visit in last 90 days → DueItem"
    // Usually routine visits are for households, but mapped to individual members or head?
    // Let's apply to member. If ANY member hasn't been visited in 90 days?
    // ASHA visits the HOUSEHOLD. So effectively, if the member hasn't been seen.
    
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

    if (daysSinceLastVisit > 90) {
      final reason = lastVisit == null
        ? "Routine home visit due — No visits recorded"
        : "Routine home visit due — no visit in last ${(daysSinceLastVisit / 30).floor()} months";

      return [
         DueItem(
          id: "${member.id}_ROUTINE",
          memberId: member.id,
          memberName: member.name,
          coreCategory: "ROUTINE",
          programTag: "Home Visit",
          dueDate: now.millisecondsSinceEpoch,
          generatedAt: now.millisecondsSinceEpoch,
          reason: reason,
        )
      ];
    }
    
    return [];
  }
}
