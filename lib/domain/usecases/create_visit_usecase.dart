import 'package:asha_ehr/domain/entities/visit.dart';
import 'package:asha_ehr/domain/repositories/i_visit_repository.dart';
import 'package:asha_ehr/domain/usecases/regenerate_due_list_usecase.dart';
import 'package:uuid/uuid.dart';

class CreateVisitUseCase {
  final IVisitRepository repository;
  final RegenerateDueListUseCase regenerateDueListUseCase;

  CreateVisitUseCase(this.repository, this.regenerateDueListUseCase);

  Future<void> call({
    required String memberId,
    required int visitDate,
    required CoreVisitCategory coreCategory,
    List<String>? programTags,
    String? notes,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = const Uuid().v4();

    final visit = Visit(
      id: id,
      memberId: memberId,
      visitDate: visitDate,
      coreCategory: coreCategory,
      programTags: programTags ?? [],
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );

    await repository.saveVisit(visit);
    
    // Trigger regeneration
    await regenerateDueListUseCase();
  }
}
