import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/dashboard/dashboard_view_model.dart';
import 'package:asha_ehr/presentation/home/home_screen.dart';
import 'package:asha_ehr/presentation/due_list/due_list_screen.dart';

import 'package:asha_ehr/presentation/sync/sync_view_model.dart';
import 'package:asha_ehr/presentation/sync/sync_indicator.dart';
import 'package:asha_ehr/presentation/settings/settings_screen.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/components/stat_card.dart';
import 'package:asha_ehr/presentation/components/section_header.dart';
import 'package:asha_ehr/presentation/components/app_card.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';
import 'package:asha_ehr/presentation/components/sync_status_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<DashboardViewModel>()..initialLoad()),
        // SyncViewModel loads last sync info on creation
        ChangeNotifierProvider(create: (_) => getIt<SyncViewModel>()),
      ],
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  @override
  void initState() {
    super.initState();
    // OPTIONAL: Auto-trigger sync on startup if needed, 
    // or just let the user do it manually as per Phase E1 "Manual Sync" focus.
    // User request says "Add explicit user-controlled sync", avoiding auto-sync surprises.
    // However, existing code triggered it. I'll keep it but it's safe now due to concurrency guards.
    // Actually, Phase E1 goal is "Trust Controls", implies manual. 
    // But "No regressions in auto-sync behavior". 
    // The "auto-sync" on startup is technically existing behavior. 
    // I will leave it, but maybe remove the explicit call if the VM handles it?
    // The VM doesn't auto-sync on init.
    // I'll keep the startup sync for now, it's good practice.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SyncViewModel>().syncNow();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ASHA Dashboard'),
        actions: [
          const SyncIndicator(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const SettingsScreen())
              );
            },
          )
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: viewModel.refresh,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.s16),
                children: [
                  const SyncStatusCard(),
                  const SizedBox(height: AppSpacing.s16),
                  const SectionHeader(title: "Today's Overview"),
                  const SizedBox(height: AppSpacing.s12),
                  StatCard(
                    label: "Visits Due Today",
                    value: (viewModel.stats['total'] ?? 0).toString(),
                    valueColor: AppColors.highRisk,
                    icon: Icons.assignment_late,
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DueListScreen()),
                      ).then((_) => viewModel.refresh());
                    },
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  const SectionHeader(title: "Navigation"),
                  const SizedBox(height: AppSpacing.s12),
                  AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      ).then((_) => viewModel.refresh());
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.people_alt, size: 32, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.s16),
                        const Text("Households Register", style: AppTextStyles.title),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
