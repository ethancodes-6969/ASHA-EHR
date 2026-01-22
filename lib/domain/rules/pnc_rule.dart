import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/enums/visit_type.dart';
import 'package:asha_ehr/domain/rules/clinical_rule.dart';

class PncRule implements ClinicalRule {
  @override
  List<DueItem> evaluate({
    required Member member,
    required List<Visit> visits,
    required DateTime now,
  }) {
    // Check if delivery date exists
    if (member.deliveryDate == null) return [];

    final delivery = DateTime.fromMillisecondsSinceEpoch(member.deliveryDate!);
    final daysSinceDelivery = now.difference(delivery).inDays;
    final generatedAt = now.millisecondsSinceEpoch;
    final dueDate = now.millisecondsSinceEpoch;

    // PNC Schedule: Day 3, 7, 42
    // Windows:
    // Day 3: Days 2-4?
    // Day 7: Days 6-8?
    // Day 42: Days 35-49?

    // Logic: If we are effectively AT or PAST the milestone, and haven't done it.
    // Simplifying for clarity:
    // If daysSince >= 3 and < 7, check for Day 3 visit.
    // If daysSince >= 7 and < 42, check for Day 7 visit.
    // If daysSince >= 42, check for Day 42 visit.

    // Filter PNC Visits
    final pncVisits = visits.where((v) => v.visitType == VisitType.PNC).toList();

    bool hasVisitInWindow(int startDay, int endDay) {
      return pncVisits.any((v) {
        final visitDate = DateTime.fromMillisecondsSinceEpoch(v.visitDate);
        final days = visitDate.difference(delivery).inDays;
        return days >= startDay && days <= endDay;
      });
    }

    final List<DueItem> dues = [];

    // PNC Day 3
    if (daysSinceDelivery >= 3) {
       // Check if done in window 0-5 days?
       if (!hasVisitInWindow(0, 5)) {
          // If we are way past (e.g. day 20), do we still flag Day 3?
          // Usually prioritize the LATEST due.
          // If day 20, Day 7 is due.
          // Let's create dues for all missing milestones or just the most relevant?
          // For simple list, let's add the most overdue one.
          // But strict logic:
          // If daysSince < 7: Check 3.
          // If daysSince < 42: Check 7.
          // If daysSince >= 42: Check 42.
       }
    }

    // Revised Logic based on "Most Relevant actionable item":
    if (daysSinceDelivery >= 42) {
       if (!hasVisitInWindow(35, 60)) {
         dues.add(_createDue(member, "PNC_42", "PNC Day 42 visit pending - Delivery was $daysSinceDelivery days ago", dueDate, generatedAt));
       }
    } else if (daysSinceDelivery >= 7) {
       // Between 7 and 42
       if (!hasVisitInWindow(5, 14)) { // Generous window around day 7
         dues.add(_createDue(member, "PNC_7", "PNC Day 7 visit pending - Delivery was $daysSinceDelivery days ago", dueDate, generatedAt));
       }
    } else if (daysSinceDelivery >= 1) { // Changed from 3 to 1 to catch early? Guidelines say Day 3.
       // Let's stick to Day 3 rule.
       if (daysSinceDelivery >= 3) {
         if (!hasVisitInWindow(1, 5)) {
           dues.add(_createDue(member, "PNC_3", "PNC Day 3 visit pending - Delivery was $daysSinceDelivery days ago", dueDate, generatedAt));
         }
       }
    }
    
    return dues;
  }

  DueItem _createDue(Member member, String tag, String reason, int dueDate, int generatedAt) {
    return DueItem(
      id: "${member.id}_$tag",
      memberId: member.id,
      memberName: member.name,
      coreCategory: "MATERNAL",
      programTag: tag,
      dueDate: dueDate,
      generatedAt: generatedAt,
      reason: reason,
    );
  }
}
