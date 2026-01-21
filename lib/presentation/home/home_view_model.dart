import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/usecases/get_all_households_usecase.dart';

class HomeViewModel extends ChangeNotifier {
  final GetAllHouseholdsUseCase _getAllHouseholdsUseCase;

  HomeViewModel(this._getAllHouseholdsUseCase);

  List<Household> _households = [];
  List<Household> get households => _households;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadHouseholds() async {
    _isLoading = true;
    notifyListeners();

    try {
      _households = await _getAllHouseholdsUseCase();
    } catch (e) {
      debugPrint("Error loading households: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
