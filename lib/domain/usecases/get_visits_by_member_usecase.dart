import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/repositories/i_visit_repository.dart';

class GetVisitsByMemberUseCase {
  final IVisitRepository repository;

  GetVisitsByMemberUseCase(this.repository);

  Future<List<Visit>> call(String memberId) async {
    return await repository.getVisitsByMember(memberId);
  }
}
