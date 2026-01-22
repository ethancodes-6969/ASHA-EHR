import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/repositories/i_member_repository.dart';

class UpdateMemberUseCase {
  final IMemberRepository repository;

  UpdateMemberUseCase(this.repository);

  Future<void> call({
    required Member member,
    String? name,
    String? gender, // Usually not editable? User said: "Name, DOB, Pregnancy fields" in Phase D request. Gender? Maybe. Use caution.
    int? dateOfBirth,
    bool? isPregnant,
    int? lmpDate,
    int? deliveryDate,
  }) async {
    final updated = member.copyWith(
      name: name,
      gender: gender,
      dateOfBirth: dateOfBirth,
      isPregnant: isPregnant,
      lmpDate: lmpDate,
      deliveryDate: deliveryDate,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await repository.updateMember(updated);
  }
}
