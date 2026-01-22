import 'package:flutter/material.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.title),
        if (action != null) action!,
      ],
    );
  }
}
