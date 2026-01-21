import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/entities/due_item.dart';
import 'package:asha_ehr/domain/usecases/get_all_due_items_usecase.dart';

class DueListViewModel extends ChangeNotifier {
  final GetAllDueItemsUseCase _getAllUseCase;

  DueListViewModel(this._getAllUseCase);

  List<DueItem> _items = [];
  List<DueItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _getAllUseCase();
    } catch (e) {
      debugPrint("Error loading due list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
