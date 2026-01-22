import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/core/sync/device_attributes.dart';
import 'package:asha_ehr/presentation/sync/sync_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a new SyncViewModel just for restoration action if needed, 
    // or reuse if provided. But Settings is pushed, so maybe new provider.
    return ChangeNotifierProvider(
      create: (_) => getIt<SyncViewModel>(),
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatefulWidget {
  const _SettingsContent();

  @override
  State<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<_SettingsContent> {
  String? _deviceId;
  final TextEditingController _restoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    final id = await getIt<DeviceAttributes>().getDeviceId();
    setState(() {
      _deviceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings & Recovery")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Device Identity", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text("ASHA Device ID"),
              subtitle: Text(_deviceId ?? "Loading..."),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  if (_deviceId != null) {
                    Clipboard.setData(ClipboardData(text: _deviceId!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ID Copied")),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text("Danger Zone: Restore Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          const Text(
            "If you reformatted your device, paste your OLD Device ID here to recover your data. WARNING: This will overwrite local data.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _restoreController,
            decoration: const InputDecoration(
              labelText: "Enter Old Device ID",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.restore),
            label: const Text("RESTORE DATA"),
            onPressed: () => _handleRestore(context),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRestore(BuildContext context) async {
    final inputId = _restoreController.text.trim();
    if (inputId.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Restore"),
        content: Text("Are you sure you want to restore data for ID: $inputId?\n\nCURRENT DATA WILL BE MERGED."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Restore")),
        ],
      ),
    );

    if (confirm == true) {
      // 1. Overwrite Local ID
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('asha_device_id', inputId);

      // Capture context-dependent services synchronously before async gaps
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final syncViewModel = context.read<SyncViewModel>();

      try {
        messenger.showSnackBar(const SnackBar(content: Text("Restoring...")));
        
        // Clear last sync to force full pull
        await prefs.remove('last_sync_timestamp');
        
        // Trigger Sync (Async Gap here is safe because we use captured viewModel)
        await syncViewModel.syncNow();
        
        if (!mounted) return;
        await _loadDeviceId(); 
        
        messenger.showSnackBar(const SnackBar(content: Text("Restore Complete! Check Dashboard.")));
      } catch(e) {
        messenger.showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}
