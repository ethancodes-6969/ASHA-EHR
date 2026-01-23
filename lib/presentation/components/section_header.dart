import 'package:flutter/material.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppTextStyles.title.color),
              const SizedBox(width: 8),
            ],
            Text(title, style: AppTextStyles.title),
          ],
        ),
        if (action != null) action!,
      ],
    );
  }
}
