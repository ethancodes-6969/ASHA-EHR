import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/dashboard/dashboard_view_model.dart';
import 'package:asha_ehr/presentation/home/home_screen.dart';
import 'package:asha_ehr/presentation/due_list/due_list_screen.dart';

import 'package:asha_ehr/presentation/sync/sync_view_model.dart';
import 'package:asha_ehr/presentation/sync/sync_indicator.dart';
import 'package:asha_ehr/presentation/settings/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<DashboardViewModel>()..initialLoad()),
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
    // Trigger Sync on Startup
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
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildStatCard(
                    context, 
                    "Visits Due Today", 
                    viewModel.stats['total'] ?? 0,
                    const Color(0xFFFFCDD2), // Red tint
                    () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DueListScreen()),
                      ).then((_) => viewModel.refresh());
                    }
                  ),
                  const SizedBox(height: 16),
                  _buildNavCard(
                    context,
                    "Households Register",
                    Icons.people_alt,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      ).then((_) => viewModel.refresh());
                    }
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int count, Color color, VoidCallback onTap) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
