import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/visits/visit_list_view_model.dart';
import 'package:asha_ehr/presentation/create_visit/create_visit_screen.dart';
import 'package:asha_ehr/presentation/theme/semantic_colors.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';

import 'package:asha_ehr/domain/enums/visit_type.dart';

class VisitListScreen extends StatelessWidget {
  final String memberId;
  final String memberName;
  final VisitType? suggestedVisitType;

  const VisitListScreen({
    super.key,
    required this.memberId,
    required this.memberName,
    this.suggestedVisitType,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<VisitListViewModel>()..loadVisits(memberId),
      child: _VisitContent(memberId: memberId, memberName: memberName, suggestedVisitType: suggestedVisitType),
    );
  }
}

class _VisitContent extends StatelessWidget {
  final String memberId;
  final String memberName;
  final VisitType? suggestedVisitType;

  const _VisitContent({required this.memberId, required this.memberName, this.suggestedVisitType});

  String _formatDate(int millis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis);
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VisitListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Visits: $memberName"),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.visits.isEmpty
              ? const Center(child: Text("No visits recorded."))
              : ListView.builder(
                  itemCount: viewModel.visits.length,
                  itemBuilder: (context, index) {
                    final visit = viewModel.visits[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(
                           _getIconForVisitType(visit.visitType),
                           color: SemanticColors.neutral,
                        ),
                        title: Row(
                          children: [
                            _buildVisitTypeBadge(visit.visitType),
                            const SizedBox(width: 8),
                            Text(_formatDate(visit.visitDate), style: AppTextStyles.body),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (visit.notes != null && visit.notes!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(visit.notes!, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                            if (visit.programTags.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Wrap(
                                  spacing: 4,
                                  children: visit.programTags
                                      .map((tag) => Chip(
                                            label: Text(tag, style: const TextStyle(fontSize: 10)),
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity.compact,
                                          ))
                                      .toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateVisitScreen(
                  memberId: memberId, 
                  memberName: memberName,
                  initialVisitType: suggestedVisitType,
              ),
            ),
          );
          if (result == true) {
            if (context.mounted) {
              context.read<VisitListViewModel>().loadVisits(memberId);
            }
          }
        },
        child: const Icon(Icons.medical_services_outlined),
      ),
    );
  }

  Widget _buildVisitTypeBadge(VisitType type) {
    Color color;
    IconData icon;
    String label = type.name;

    switch (type) {
      case VisitType.ANC:
        color = SemanticColors.warning;
        icon = Icons.pregnant_woman;
        break;
      case VisitType.PNC:
        color = SemanticColors.success;
        icon = Icons.woman; 
        break;
      case VisitType.HBNC:
      case VisitType.HBYC:
        color = SemanticColors.warning;
        icon = Icons.child_care;
        break;
      case VisitType.ROUTINE:
        color = SemanticColors.neutral;
        icon = Icons.home;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getIconForVisitType(VisitType type) {
    switch (type) {
      case VisitType.ANC: return Icons.pregnant_woman;
      case VisitType.PNC: return Icons.health_and_safety;
      case VisitType.HBNC:
      case VisitType.HBYC: return Icons.child_care;
      case VisitType.ROUTINE:
        return Icons.home;
    }
  }
}

