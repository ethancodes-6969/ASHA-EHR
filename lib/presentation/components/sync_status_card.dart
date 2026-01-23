import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/presentation/sync/sync_view_model.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';

class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SyncViewModel>();
    final status = viewModel.status;
    final lastSync = viewModel.lastSyncTime;
    final lastError = viewModel.lastError;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatusIcon(status),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(status),
                        style: AppTextStyles.title.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getLastSyncText(lastSync),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: status == SyncStatus.syncing 
                      ? null 
                      : () => context.read<SyncViewModel>().syncNow(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: status == SyncStatus.syncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(status == SyncStatus.failed ? "Retry" : "Sync Now"),
                ),
              ],
            ),
            if (status == SyncStatus.failed && lastError != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.highRisk.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.highRisk),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lastError,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.highRisk,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return const SizedBox(
          width: 28, 
          height: 28, 
          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary)
        );
      case SyncStatus.success:
        return const Icon(Icons.check_circle, color: AppColors.success, size: 32);
      case SyncStatus.failed:
        return const Icon(Icons.error, color: AppColors.highRisk, size: 32);
      case SyncStatus.idle:
        return const Icon(Icons.cloud_queue, color: AppColors.textSecondary, size: 32);
    }
  }

  String _getStatusTitle(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing: return "Syncing Data...";
      case SyncStatus.success: return "Sync Complete";
      case SyncStatus.failed: return "Sync Failed";
      default: return "Data Sync";
    }
  }

  String _getLastSyncText(DateTime? lastSync) {
    if (lastSync == null) return "Never synced";
    final diff = DateTime.now().difference(lastSync);
    
    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }
}
