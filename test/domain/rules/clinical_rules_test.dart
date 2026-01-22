import 'package:flutter_test/flutter_test.dart';
import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/enums/visit_type.dart';
import 'package:asha_ehr/domain/rules/anc_rule.dart';
import 'package:asha_ehr/domain/rules/pnc_rule.dart';
import 'package:asha_ehr/domain/rules/child_growth_rule.dart';
import 'package:asha_ehr/domain/rules/routine_rule.dart';

void main() {
  late DateTime now;
  late AncRule ancRule;
  late PncRule pncRule;
  late ChildGrowthRule childRule;
  late RoutineRule routineRule;

  setUp(() {
    now = DateTime(2023, 10, 1); // Fixed "Now" for deterministic tests
    ancRule = AncRule();
    pncRule = PncRule();
    childRule = ChildGrowthRule();
    routineRule = RoutineRule();
  });

  group('Clinical Rules Verification Scenarios', () {
    // Scenario A — Pregnant Woman (ANC 2 due)
    // Pregnant, LMP 22 weeks ago
    // Only ANC 1 done
    // Expected: ANC 2 due
    test('Scenario A: Pregnant Woman (ANC 2 due)', () {
      final lmpDate = now.subtract(const Duration(days: 22 * 7)); // 22 weeks ago
      final member = Member(
        id: 'param_a',
        householdId: 'h1',
        name: 'Mrs. A',
        gender: 'F',
        dateOfBirth: 0,
        isPregnant: true,
        lmpDate: lmpDate.millisecondsSinceEpoch,
        createdAt: 0,
        updatedAt: 0,
      );

      final visits = <Visit>[
        Visit(
          id: 'v1',
          memberId: 'param_a',
          visitDate: lmpDate.add(const Duration(days: 10 * 7)).millisecondsSinceEpoch, // ANC 1 at 10 weeks
          visitType: VisitType.ANC,
          programTags: const [],
          createdAt: 0,
          updatedAt: 0,
        )
      ];

      final items = ancRule.evaluate(member: member, visits: visits, now: now);

      expect(items.length, 1);
      final item = items.first;
      expect(item.programTag, 'ANC_2');
      expect(item.reason, contains('ANC 2 due'));
      expect(item.reason, contains('22 weeks'));
    });

    // Scenario B — Post Delivery (PNC pending)
    // Delivery 7 days ago
    // No PNC visit
    // Expected: "PNC Day 7 pending"
    test('Scenario B: Post Delivery (PNC Day 7 pending)', () {
      final deliveryDate = now.subtract(const Duration(days: 7));
      final member = Member(
        id: 'param_b',
        householdId: 'h1',
        name: 'Mrs. B',
        gender: 'F',
        dateOfBirth: 0,
        isPregnant: false,
        deliveryDate: deliveryDate.millisecondsSinceEpoch,
        createdAt: 0,
        updatedAt: 0,
      );

      final visits = <Visit>[]; // No visits

      final items = pncRule.evaluate(member: member, visits: visits, now: now);

      expect(items.length, 1);
      final item = items.first;
      // Depending on logic, it might flag Day 3 or Day 7.
      // Logic for Day 7 needs to be >= 7 days.
      // If exactly 7 days, it falls into Day 7 check.
      expect(item.programTag, 'PNC_7');
      expect(item.reason, contains('PNC Day 7 visit pending'));
    });

    // Scenario C — Child (Growth due)
    // Age 2
    // Last visit 75 days ago
    // Expected: Growth monitoring due
    test('Scenario C: Child (Growth Monitoring Due)', () {
      final dob = now.subtract(const Duration(days: 2 * 365)); // 2 years old
      final member = Member(
        id: 'child_c',
        householdId: 'h1',
        name: 'Baby C',
        gender: 'M',
        dateOfBirth: dob.millisecondsSinceEpoch,
        createdAt: 0,
        updatedAt: 0,
      );

      final lastVisitDate = now.subtract(const Duration(days: 75));
      final visits = <Visit>[
        Visit(
          id: 'v_c',
          memberId: 'child_c',
          visitDate: lastVisitDate.millisecondsSinceEpoch,
          visitType: VisitType.ROUTINE, // Assuming Routine or HBNC/HBYC counts
          programTags: const [],
          createdAt: 0,
          updatedAt: 0,
        )
      ];

      final items = childRule.evaluate(member: member, visits: visits, now: now);

      expect(items.length, 1);
      expect(items.first.coreCategory, 'CHILD');
      expect(items.first.reason, contains('75 days ago'));
    });

    // Scenario D — Healthy Household (No due items)
    // Visit done 10 days ago
    // Expected: No due items
    test('Scenario D: Healthy Household (No due items)', () {
      final member = Member(
        id: 'member_d',
        householdId: 'h1',
        name: 'Mr. D',
        gender: 'M',
        dateOfBirth: now.subtract(const Duration(days: 30 * 365)).millisecondsSinceEpoch, // 30yo
        createdAt: 0,
        updatedAt: 0,
      );

      final lastVisitDate = now.subtract(const Duration(days: 10));
      final visits = <Visit>[
        Visit(
          id: 'v_d',
          memberId: 'member_d',
          visitDate: lastVisitDate.millisecondsSinceEpoch,
          visitType: VisitType.ROUTINE,
          programTags: const [],
          createdAt: 0,
          updatedAt: 0,
        )
      ];

      // Check all rules just to be safe (Simulate Orchestration)
      final items = <DueItem>[];
      items.addAll(ancRule.evaluate(member: member, visits: visits, now: now));
      items.addAll(pncRule.evaluate(member: member, visits: visits, now: now));
      items.addAll(childRule.evaluate(member: member, visits: visits, now: now));
      items.addAll(routineRule.evaluate(member: member, visits: visits, now: now));

      expect(items, isEmpty);
    });
  });
}
