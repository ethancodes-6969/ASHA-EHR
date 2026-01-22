import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/enums/visit_type.dart';
import 'package:asha_ehr/domain/rules/clinical_rule.dart';

class AncRule implements ClinicalRule {
  @override
  List<DueItem> evaluate({
    required Member member,
    required List<Visit> visits,
    required DateTime now,
  }) {
    if (member.isPregnant != true || member.lmpDate == null) return [];

    final lmp = DateTime.fromMillisecondsSinceEpoch(member.lmpDate!);
    final weeksPreg = (now.difference(lmp).inDays / 7).floor();
    final generatedAt = now.millisecondsSinceEpoch;
    final dueDate = now.millisecondsSinceEpoch;

    // Filter ANC visits
    final ancVisits = visits.where((v) => v.visitType == VisitType.ANC).toList();
    
    // Sort by date descending
    ancVisits.sort((a, b) => b.visitDate.compareTo(a.visitDate));

    // ANC Schedule:
    // ANC 1: <= 12 weeks
    // ANC 2: 20-24 weeks
    // ANC 3: 28-32 weeks
    // ANC 4: >= 36 weeks

    final List<DueItem> dues = [];

    bool hasVisitInWindow(int startWeek, int endWeek) {
      return ancVisits.any((v) {
        final visitDate = DateTime.fromMillisecondsSinceEpoch(v.visitDate);
        final visitWeeks = (visitDate.difference(lmp).inDays / 7).floor();
        // Check if visit happened in or after the start week (and before end week is usually implied by next rule, but strict window checking is better)
        // Actually, government guidelines imply "At least one checkup within...".
        // Let's check if there is ANY ANC visit that corresponds roughly to this phase.
        // Or simpler: Has a visit happened since pregnancy reached X weeks?
        return visitWeeks >= startWeek && visitWeeks <= endWeek;
      });
    }

    // ANC 1 (< 12 weeks)
    // If weeksPreg > 12, we can't do "ANC 1" anymore effectively? 
    // Usually we just say "ANC Checkup due". 
    // Let's follow strict logic: If we are in the window, and haven't done it, it's due.
    // If we passed the window, we check the next window. 
    // BUT, if someone is 22 weeks and never had ANC 1, they need an ANC visit immediately.
    // So: 
    // If we are past 12 weeks, and have 0 visits -> Due.
    
    // Simplification for ASHA:
    // If current weeks is in window, and no visit in window -> Due.
    
    if (weeksPreg <= 12) {
       if (!hasVisitInWindow(0, 12)) {
         dues.add(_createDue(member, "ANC_1", "ANC 1 due (Weeks 0-12) - Current: $weeksPreg weeks", dueDate, generatedAt));
       }
    } else if (weeksPreg >= 20 && weeksPreg <= 24) {
       if (!hasVisitInWindow(20, 24)) {
         dues.add(_createDue(member, "ANC_2", "ANC 2 due (Weeks 20-24) - Current: $weeksPreg weeks", dueDate, generatedAt));
       }
    } else if (weeksPreg >= 28 && weeksPreg <= 32) {
       if (!hasVisitInWindow(28, 32)) {
         dues.add(_createDue(member, "ANC_3", "ANC 3 due (Weeks 28-32) - Current: $weeksPreg weeks", dueDate, generatedAt));
       }
    } else if (weeksPreg >= 36) {
       if (!hasVisitInWindow(36, 42)) { // Assuming 42 as max
         dues.add(_createDue(member, "ANC_4", "ANC 4 due (Weeks 36+) - Current: $weeksPreg weeks", dueDate, generatedAt));
       }
    }
    
    // Fallback: If pregnant and no visits at all, and not covered by above strict windows (e.g. week 15)
    // "ANC Checkup due - No visits recorded"
    if (ancVisits.isEmpty && dues.isEmpty) {
       dues.add(_createDue(member, "ANC_Catchup", "ANC Checkup due - Pregnancy at $weeksPreg weeks with no visits", dueDate, generatedAt));
    }

    return dues;
  }

  DueItem _createDue(Member member, String tag, String reason, int dueDate, int generatedAt) {
    return DueItem(
      id: "${member.id}_$tag",
      memberId: member.id,
      memberName: member.name,
      // householdLocation: null, // Will be filled by usecase merging or passed in? 
      // Rule evaluate method signature doesn't have Household. 
      // I should update evaluate signature or attach household location later.
      // UseCase has household map, so it can enrich the DueItem. 
      // For now, leave null.
      coreCategory: "MATERNAL",
      programTag: tag,
      dueDate: dueDate,
      generatedAt: generatedAt,
      reason: reason,
    );
  }
}
