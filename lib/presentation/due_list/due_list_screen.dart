import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/due_list/due_list_view_model.dart';
import 'package:asha_ehr/presentation/visits/visit_list_screen.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';
import 'package:asha_ehr/presentation/components/app_card.dart';

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
                    return AppCard(
                      onTap: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => VisitListScreen(
                               memberId: item.memberId,
                               memberName: item.memberName,
                               suggestedVisitType: _getVisitTypeFromItem(item),
                             ))
                           );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildBadge(item.coreCategory),
                              const SizedBox(width: AppSpacing.s8),
                              Expanded(child: Text(item.programTag, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold))),
                              const Icon(Icons.calendar_today, size: 12, color: AppColors.highRisk),
                              const SizedBox(width: 4),
                              const Text("Action Required", style: TextStyle(fontSize: 12, color: AppColors.highRisk, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.s12),
                          Text(item.memberName, style: AppTextStyles.title),
                          if (item.householdLocation != null) ...[
                            const SizedBox(height: AppSpacing.s4),
                            Text(item.householdLocation!, style: AppTextStyles.body),
                          ],
                          const SizedBox(height: AppSpacing.s12),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s8),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: AppSpacing.s8),
                                Expanded(child: Text(item.reason, style: AppTextStyles.caption)),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildBadge(String category) {
    Color color = _getColorForCategory(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'CHILD': return AppColors.info;
      case 'MATERNAL': return const Color(0xFFD81B60); // Pink 600
      case 'ROUTINE': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }
}
