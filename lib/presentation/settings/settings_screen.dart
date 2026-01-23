import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/core/sync/device_attributes.dart';
import 'package:asha_ehr/presentation/sync/sync_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asha_ehr/l10n/app_localizations.dart';
import 'package:asha_ehr/presentation/settings/locale_provider.dart';

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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Selector
          Text(AppLocalizations.of(context)!.language, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.selectLanguage),
              trailing: Consumer<LocaleProvider>(
                builder: (context, provider, child) {
                  return DropdownButton<String>(
                    value: provider.locale?.languageCode ?? 'en',
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                      DropdownMenuItem(value: 'mr', child: Text('मराठी')),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        provider.setLocale(Locale(value));
                      }
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Device Identity
          Text(AppLocalizations.of(context)!.deviceIdentity, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.ashaDeviceId),
              subtitle: Text(_deviceId ?? "Loading..."),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  if (_deviceId != null) {
                    Clipboard.setData(ClipboardData(text: _deviceId!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.idCopied)),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(AppLocalizations.of(context)!.dangerZone, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.restoreDataInstruction,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _restoreController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.enterOldDeviceId,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.restore),
            label: Text(AppLocalizations.of(context)!.restoreData),
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
        title: Text(AppLocalizations.of(context)!.confirmRestore),
        content: Text(AppLocalizations.of(context)!.restoreConfirmMessage(inputId)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)!.restoreData)),
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
        messenger.showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.restoring)));
        
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
