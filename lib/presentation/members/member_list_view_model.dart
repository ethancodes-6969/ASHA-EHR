import 'package:flutter/foundation.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/usecases/get_members_by_household_usecase.dart';

class MemberListViewModel extends ChangeNotifier {
  final GetMembersByHouseholdUseCase _getMembersUseCase;

  MemberListViewModel(this._getMembersUseCase);

  List<Member> _members = [];
  List<Member> get members => _members;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadMembers(String householdId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _members = await _getMembersUseCase(householdId);
    } catch (e) {
      debugPrint("Error loading members: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
