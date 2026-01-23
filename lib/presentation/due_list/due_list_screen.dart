import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/due_list/due_list_view_model.dart';
import 'package:asha_ehr/presentation/visits/visit_list_screen.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';
import 'package:asha_ehr/presentation/components/app_card.dart';
import 'package:asha_ehr/presentation/theme/semantic_colors.dart';

import 'package:asha_ehr/domain/enums/visit_type.dart';
import 'package:asha_ehr/domain/entities/due_item.dart';

class DueListScreen extends StatelessWidget {
  const DueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<DueListViewModel>()..loadItems(),
      child: const _DueListContent(),
    );
  }
}

class _DueListContent extends StatelessWidget {
  const _DueListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DueListViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Due Tasks")),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.items.isEmpty
              ? const Center(child: Text("All caught up! No due tasks.", style: AppTextStyles.body))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.items[index];
                    final urgencyColor = _getUrgencyColor(item.dueDate);
                    final visitType = _getVisitTypeFromItem(item);
                    
                    return AppCard(
                      onTap: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => VisitListScreen(
                               memberId: item.memberId,
                               memberName: item.memberName,
                               suggestedVisitType: visitType,
                             ))
                           );
                      },
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Semantic Left Border
                            Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: urgencyColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ),
                            // 2. Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Leading Icon
                                        Icon(
                                          _getIconForVisitType(visitType),
                                          size: 24,
                                          color: urgencyColor,
                                        ),
                                        const SizedBox(width: AppSpacing.s12),
                                        
                                        // Main Header content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               Text(item.memberName, style: AppTextStyles.title),
                                               if (item.householdLocation != null) ...[
                                                 const SizedBox(height: AppSpacing.s4),
                                                 Text(item.householdLocation!, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                                               ],
                                            ],
                                          ),
                                        ),
                                        
                                        // Date / Status
                                        _buildUrgencyText(item.dueDate),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.s12),
                                    
                                    // Tags & Badges
                                    Row(
                                      children: [
                                         _buildVisitTypeBadge(visitType),
                                         const SizedBox(width: AppSpacing.s8),
                                         Expanded(child: Text(item.reason, style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  VisitType _getVisitTypeFromItem(DueItem item) {
    final tag = item.programTag.toUpperCase();
    if (tag.startsWith('ANC')) return VisitType.ANC;
    if (tag.startsWith('PNC')) return VisitType.PNC;
    if (tag.startsWith('HBNC')) return VisitType.HBNC;
    if (tag.startsWith('HBYC')) return VisitType.HBYC;
    return VisitType.ROUTINE;
  }

  Color _getUrgencyColor(int dueDateMillis) {
    final dueDate = DateTime.fromMillisecondsSinceEpoch(dueDateMillis);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Overdue or Today -> Danger
    if (dueDate.isBefore(today) || dueDate.isAtSameMomentAs(today)) {
      return SemanticColors.danger;
    }
    
    // Upcoming (within 7 days) -> Warning
    final nextWeek = today.add(const Duration(days: 7));
    if (dueDate.isBefore(nextWeek)) {
      return SemanticColors.warning;
    }
    
    // Future -> Neutral
    return SemanticColors.neutral;
  }

  Widget _buildUrgencyText(int dueDateMillis) {
    final color = _getUrgencyColor(dueDateMillis);
    final dueDate = DateTime.fromMillisecondsSinceEpoch(dueDateMillis);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    String text;
    if (dueDate.isBefore(today)) {
      final days = today.difference(dueDate).inDays;
      text = "Overdue by $days days";
    } else if (dueDate.isAtSameMomentAs(today)) {
      text = "Due Today";
    } else {
      text = "Due ${_formatDate(dueDate)}";
    }

    return Row(
      children: [
        Icon(Icons.calendar_today, size: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.day}/${dt.month}";
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
        borderRadius: BorderRadius.circular(16), // Pill shape
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
