import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/usecases/get_visits_by_member_usecase.dart';

class VisitListViewModel extends ChangeNotifier {
  final GetVisitsByMemberUseCase _getVisitsUseCase;

  VisitListViewModel(this._getVisitsUseCase);

  List<Visit> _visits = [];
  List<Visit> get visits => _visits;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadVisits(String memberId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _visits = await _getVisitsUseCase(memberId);
    } catch (e) {
      debugPrint("Error loading visits: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
