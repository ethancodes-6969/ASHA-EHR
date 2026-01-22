import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/usecases/get_members_by_household_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_visits_by_member_usecase.dart';
import 'package:asha_ehr/domain/usecases/get_all_due_items_usecase.dart';

class MemberListViewModel extends ChangeNotifier {
  final GetMembersByHouseholdUseCase _getMembersUseCase;
  final GetVisitsByMemberUseCase _getVisitsUseCase;
  final GetAllDueItemsUseCase _getAllDueItemsUseCase;

  MemberListViewModel(
    this._getMembersUseCase,
    this._getVisitsUseCase,
    this._getAllDueItemsUseCase,
  );

  List<Member> _members = [];
  
  String _searchQuery = '';

  List<Member> get members => _searchQuery.isEmpty 
      ? _members 
      : _members.where((m) => 
          m.name.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _visitCount = 0;
  int get visitCount => _visitCount;

  int _dueCount = 0;
  int get dueCount => _dueCount;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadMembers(String householdId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch Members
      _members = await _getMembersUseCase(householdId);
      
      // 2. Compute Summary (In-Memory)
      if (_members.isEmpty) {
        _visitCount = 0;
        _dueCount = 0;
      } else {
        // Parallel Fetch
        final results = await Future.wait([
          // Fetch visits for each member
          Future.wait(_members.map((m) => _getVisitsUseCase(m.id))),
          // Fetch all due items
          _getAllDueItemsUseCase(),
        ]);

        final visitLists = results[0] as List<List<dynamic>>;
        final allDueItems = results[1] as List<dynamic>;

        // Aggregation
        _visitCount = visitLists.fold<int>(0, (sum, list) => sum + list.length);
        
        final memberIds = _members.map((m) => m.id).toSet();
        // Dynamic access to .memberId might be unsafe if not typed.
        // But logic is correct. Ideally cast.
        _dueCount = allDueItems.where((d) => memberIds.contains((d).memberId)).length;
      }

    } catch (e) {
      debugPrint("Error loading members/stats: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
