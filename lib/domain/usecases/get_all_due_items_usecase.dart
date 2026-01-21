import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/repositories/i_due_list_repository.dart';

class GetAllDueItemsUseCase {
  final IDueListRepository repository;

  GetAllDueItemsUseCase(this.repository);

  Future<List<DueItem>> call() async {
    return await repository.getAllDueItems();
  }
}
