import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/presentation/sync/sync_view_model.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SyncViewModel>();
    final status = viewModel.status;

    if (status == SyncStatus.syncing) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      );
    }

    IconData icon;
    Color color;

    switch (status) {
      case SyncStatus.failed:
        icon = Icons.cloud_off;
        color = AppColors.highRisk; 
        break;
      case SyncStatus.success:
        icon = Icons.cloud_done;
        color = Colors.white; 
        break;
      default:
        icon = Icons.cloud_queue;
        color = Colors.white;
    }

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () {
        // READ-ONLY: Show status but do not trigger sync
        String msg;
        if (status == SyncStatus.failed) {
          msg = "Sync Failed: ${viewModel.lastError ?? 'Unknown error'}";
        } else if (status == SyncStatus.success) {
          msg = "Sync Complete";
        } else {
          msg = "Sync Idle";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      },
    );
  }
}
