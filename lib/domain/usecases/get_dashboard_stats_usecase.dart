import 'package:asha_ehr/domain/repositories/i_due_list_repository.dart';

class GetDashboardStatsUseCase {
  final IDueListRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<Map<String, int>> call() async {
    return await repository.getStats();
  }
}
