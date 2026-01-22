import 'package:flutter/material.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';
import 'package:asha_ehr/presentation/components/app_card.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;
  final IconData? icon;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               if (icon != null) ...[
                 Icon(icon, size: 20, color: AppColors.textSecondary),
                 const SizedBox(width: AppSpacing.s8),
               ],
               Expanded(child: Text(label, style: AppTextStyles.caption)),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            value,
            style: AppTextStyles.headline.copyWith(color: valueColor ?? AppColors.primary),
          ),
          if (subtitle != null) ...[
             const SizedBox(height: AppSpacing.s4),
             Text(subtitle!, style: AppTextStyles.caption),
          ]
        ],
      ),
    );
  }
}
