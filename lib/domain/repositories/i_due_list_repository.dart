import 'package:asha_ehr/domain/entities/due_item.dart';

abstract class IDueListRepository {
  Future<List<DueItem>> getAllDueItems();
  Future<Map<String, int>> getStats();
  Future<void> replaceAll(List<DueItem> items);
}
