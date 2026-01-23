import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/dashboard/dashboard_view_model.dart';
import 'package:asha_ehr/presentation/home/home_screen.dart';
import 'package:asha_ehr/presentation/due_list/due_list_screen.dart';

import 'package:asha_ehr/presentation/theme/semantic_colors.dart';

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
import 'package:asha_ehr/l10n/app_localizations.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SyncViewModel>().syncNow();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
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
                  SectionHeader(title: AppLocalizations.of(context)!.todayOverview),
                  const SizedBox(height: AppSpacing.s12),
                  StatCard(
                    label: AppLocalizations.of(context)!.dueVisits,
                    value: (viewModel.stats['total'] ?? 0).toString(),
                    valueColor: SemanticColors.danger,
                    icon: Icons.warning_amber,
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DueListScreen()),
                      ).then((_) => viewModel.refresh());
                    },
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  SectionHeader(title: AppLocalizations.of(context)!.navigation),
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
                        Text(AppLocalizations.of(context)!.householdsRegister, style: AppTextStyles.title),
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
