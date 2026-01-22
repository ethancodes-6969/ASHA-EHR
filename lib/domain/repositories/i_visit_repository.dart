import 'package:asha_ehr/domain/entities/visit.dart';

abstract class IVisitRepository {
  Future<List<Visit>> getVisitsByMember(String memberId);
  Future<List<Visit>> getAllVisits(); // Internal use only
  Future<void> saveVisit(Visit visit);
}
