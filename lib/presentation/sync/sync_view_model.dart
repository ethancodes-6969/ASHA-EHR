import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/repositories/i_sync_repository.dart';
import 'package:asha_ehr/domain/usecases/regenerate_due_list_usecase.dart';

enum SyncStatus { idle, syncing, success, failed }

class SyncViewModel extends ChangeNotifier {
  final ISyncRepository _syncRepository;
  final RegenerateDueListUseCase _regenerateDueListUseCase;

  SyncViewModel(this._syncRepository, this._regenerateDueListUseCase) {
    _loadLastSyncInfo();
  }

  SyncStatus _status = SyncStatus.idle;
  SyncStatus get status => _status;

  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;

  String? _lastError;
  String? get lastError => _lastError;

  Future<void> _loadLastSyncInfo() async {
    try {
      final timestamp = await _syncRepository.getLastSyncTimestamp();
      if (timestamp > 0) {
        _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      
      final error = await _syncRepository.getLastError();
      if (error != null) {
        _status = SyncStatus.failed;
        _lastError = error;
      } else if (_lastSyncTime != null) {
        // If we have a time and no error, assume success state
        _status = SyncStatus.success;
        _lastError = null;
      } else {
        _status = SyncStatus.idle;
      }
    } catch (e) {
      debugPrint("Error loading sync info: $e");
      // Don't crash UI on init failure
    }
    notifyListeners();
  }

  Future<void> syncNow() async {
    // 1. Concurrent Guard
    if (_status == SyncStatus.syncing) return;

    _status = SyncStatus.syncing;
    _lastError = null;
    notifyListeners();

    try {
      // 2. Perform Sync
      final pushed = await _syncRepository.push();
      debugPrint("Pushed $pushed items");
      await _syncRepository.pull();
      
      // 3. Side Effects
      await _regenerateDueListUseCase.call();

      // 4. Persistence (Delegated to Repo)
      // Timestamp is updated inside pull(), we just refresh local state
      // Clear error in persistence
      await _syncRepository.setLastError(null);

      // 5. Update Local State
      final newTimestamp = await _syncRepository.getLastSyncTimestamp();
      _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(newTimestamp);
      _status = SyncStatus.success;
      _lastError = null;

    } catch (e) {
      debugPrint("Sync Failed: $e");
      
      // 6. Friendly Error Mapping
      String friendlyMsg = "Sync failed. Please try again.";
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socket') || errorStr.contains('network') || errorStr.contains('connection')) {
        friendlyMsg = "No internet connection.";
      }

      // 7. Persist Error
      await _syncRepository.setLastError(friendlyMsg);

      _status = SyncStatus.failed;
      _lastError = friendlyMsg;
    } finally {
      notifyListeners();
    }
  }
}
