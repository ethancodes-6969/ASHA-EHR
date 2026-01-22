import 'package:flutter/material.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Flat or very subtle
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEEEEEE), width: 1), // Subtle border
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.s16),
          child: child,
        ),
      ),
    );
  }
}
