import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:asha_ehr/domain/usecases/regenerate_due_list_usecase.dart';

class DashboardViewModel extends ChangeNotifier {
  final GetDashboardStatsUseCase _getStatsUseCase;
  final RegenerateDueListUseCase _regenerateUseCase;

  DashboardViewModel(this._getStatsUseCase, this._regenerateUseCase);

  Map<String, int> _stats = {'total': 0};
  Map<String, int> get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> initialLoad() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Regenerate
      await _regenerateUseCase.call();
      // 2. Refresh stats
      _stats = await _getStatsUseCase();
    } catch (e) {
      debugPrint("Error loading dashboard: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    // Just refresh stats, maybe regeneration happened elsewhere? 
    // Or valid to force regenerate on pull-to-refresh
    await initialLoad();
  }
}
