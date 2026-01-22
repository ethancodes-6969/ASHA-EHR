import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/usecases/get_all_households_usecase.dart';
import 'package:asha_ehr/domain/usecases/archive_household_usecase.dart';

class HomeViewModel extends ChangeNotifier {
  final GetAllHouseholdsUseCase _getAllHouseholdsUseCase;
  final ArchiveHouseholdUseCase _archiveHouseholdUseCase;

  HomeViewModel(this._getAllHouseholdsUseCase, this._archiveHouseholdUseCase);

  List<Household> _households = [];
  
  String _searchQuery = '';

  List<Household> get households => _searchQuery.isEmpty 
      ? _households 
      : _households.where((h) => 
          h.familyHeadName.toLowerCase().contains(_searchQuery.toLowerCase()) || 
          h.locationDescription.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

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

  Future<void> archiveHousehold(String id) async {
    try {
      await _archiveHouseholdUseCase(id);
      await loadHouseholds();
    } catch (e) {
      debugPrint("Error archiving household: $e");
    }
  }
}
