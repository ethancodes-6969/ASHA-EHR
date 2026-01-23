import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/presentation/sync/sync_view_model.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';
import 'package:asha_ehr/l10n/app_localizations.dart';

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
                        _getStatusTitle(context, status),
                        style: AppTextStyles.title.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getLastSyncText(context, lastSync, status),
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
                      : Text(status == SyncStatus.failed ? AppLocalizations.of(context)!.retry : AppLocalizations.of(context)!.syncNow),
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
            child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary));
      case SyncStatus.success:
        return const Icon(Icons.cloud_done, color: AppColors.success, size: 32);
      case SyncStatus.failed:
        // cloud_off implies connection issue, which is most common
        return const Icon(Icons.cloud_off, color: AppColors.highRisk, size: 32);
      case SyncStatus.idle:
        // idle here means 'never synced' in the context of our VM logic (initially)
        return const Icon(Icons.cloud_queue, color: AppColors.warning, size: 32);
    }
  }

  String _getStatusTitle(BuildContext context, SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return AppLocalizations.of(context)!.syncing;
      case SyncStatus.success:
        return AppLocalizations.of(context)!.syncComplete;
      case SyncStatus.failed:
        return AppLocalizations.of(context)!.syncFailed;
      case SyncStatus.idle:
        return AppLocalizations.of(context)!.notSyncedYet;
    }
  }

  String _getLastSyncText(BuildContext context, DateTime? lastSync, SyncStatus status) {
    if (status == SyncStatus.failed) return AppLocalizations.of(context)!.retry;
    if (status == SyncStatus.idle || lastSync == null) return AppLocalizations.of(context)!.syncNow;

    final diff = DateTime.now().difference(lastSync);
    // Simple localization for time, can be improved later
    if (diff.inSeconds < 60) return "Just now";
    final prefix = AppLocalizations.of(context)!.lastSynced;
    
    if (diff.inMinutes < 60) return "$prefix: ${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "$prefix: ${diff.inHours} hours ago";
    return "$prefix: ${diff.inDays} days ago";
  }
}

