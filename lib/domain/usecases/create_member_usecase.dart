
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/repositories/i_member_repository.dart';
import 'package:asha_ehr/domain/usecases/regenerate_due_list_usecase.dart';
import 'package:uuid/uuid.dart';

class CreateMemberUseCase {
  final IMemberRepository repository;
  final RegenerateDueListUseCase regenerateDueListUseCase;

  CreateMemberUseCase(this.repository, this.regenerateDueListUseCase);

  Future<void> call({
    required String householdId,
    required String name,
    required String gender,
    required int dateOfBirth,
    String? idProofNumber,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = const Uuid().v4();

    final member = Member(
      id: id,
      householdId: householdId,
      name: name,
      gender: gender,
      dateOfBirth: dateOfBirth,
      idProofNumber: idProofNumber,
      createdAt: now,
      updatedAt: now,
    );

    await repository.saveMember(member);
    Future.microtask(() => regenerateDueListUseCase());
  }
}
