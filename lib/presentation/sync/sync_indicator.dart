import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/presentation/sync/sync_view_model.dart';

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Requires SyncViewModel provided above
    final viewModel = context.watch<SyncViewModel>();

    if (viewModel.isSyncing) {
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

    return IconButton(
      icon: Icon(
        viewModel.lastError != null ? Icons.cloud_off : Icons.cloud_done,
        color: viewModel.lastError != null ? Colors.orangeAccent : Colors.white,
      ),
      onPressed: () {
        context.read<SyncViewModel>().syncNow();
        if (viewModel.lastError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Last Sync Error: ${viewModel.lastError}')),
          );
        } else {
             ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Syncing...')),
          );
        }
      },
    );
  }
}
