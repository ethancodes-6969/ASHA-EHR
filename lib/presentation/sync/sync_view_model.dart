import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/repositories/i_sync_repository.dart';
import 'package:asha_ehr/domain/usecases/regenerate_due_list_usecase.dart';

class SyncViewModel extends ChangeNotifier {
  final ISyncRepository _syncRepository;
  final RegenerateDueListUseCase _regenerateDueListUseCase;

  SyncViewModel(this._syncRepository, this._regenerateDueListUseCase);

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _lastError;
  String? get lastError => _lastError;

  Future<void> syncNow() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _lastError = null;
    notifyListeners();

    try {
      // 1. Push
      final pushed = await _syncRepository.push();
      debugPrint("Pushed $pushed items");

      // 2. Pull
      await _syncRepository.pull();
      
      // 3. Regenerate (Side Effect of Pull)
      // Per architecture rule: ViewModel triggers this, not Repository.
      Future.microtask(() => _regenerateDueListUseCase.call());

    } catch (e) {
      _lastError = e.toString();
      debugPrint("Sync Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
