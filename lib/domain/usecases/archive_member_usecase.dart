import 'package:asha_ehr/domain/repositories/i_member_repository.dart';

class ArchiveMemberUseCase {
  final IMemberRepository repository;

  ArchiveMemberUseCase(this.repository);

  Future<void> call(String memberId) async {
    await repository.archiveMember(memberId);
  }
}
