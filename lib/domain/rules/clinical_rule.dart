import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/entities/visit.dart';

abstract class ClinicalRule {
  List<DueItem> evaluate({
    required Member member,
    required List<Visit> visits,
    required DateTime now,
  });
}
