import 'package:flutter/material.dart';
import 'package:asha_ehr/core/di/service_locator.dart';

import 'package:asha_ehr/domain/enums/visit_type.dart';
import 'package:asha_ehr/domain/usecases/create_visit_usecase.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/components/section_header.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';
import 'package:asha_ehr/l10n/app_localizations.dart';

class CreateVisitScreen extends StatefulWidget {
  final String memberId;
  final String memberName;
  final VisitType? initialVisitType;

  const CreateVisitScreen({
    super.key,
    required this.memberId,
    required this.memberName,
    this.initialVisitType,
  });

  @override
  State<CreateVisitScreen> createState() => _CreateVisitScreenState();
}

class _CreateVisitScreenState extends State<CreateVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();

  DateTime _visitDate = DateTime.now();
  late VisitType _category;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _category = widget.initialVisitType ?? VisitType.ROUTINE;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _visitDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final createUseCase = getIt<CreateVisitUseCase>();

      // Parse tags from comma separated string
      List<String> tags = [];
      if (_tagsController.text.isNotEmpty) {
        tags = _tagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }

      await createUseCase(
        memberId: widget.memberId,
        visitDate: _visitDate.millisecondsSinceEpoch,
        visitType: _category,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        programTags: tags,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorSaving(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${AppLocalizations.of(context)!.recordVisit}: ${widget.memberName}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: AppLocalizations.of(context)!.visitDetails, icon: Icons.event_note),
              const SizedBox(height: AppSpacing.s16),
              // Date Picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("${AppLocalizations.of(context)!.visitDate}: ${_visitDate.day}/${_visitDate.month}/${_visitDate.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const Divider(),

              // Category Dropdown
              DropdownButtonFormField<VisitType>(
                value: _category,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.visitType),
                items: VisitType.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: AppSpacing.s24),

              const SectionHeader(title: "Findings", icon: Icons.fact_check_outlined),
              const SizedBox(height: AppSpacing.s16),
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notes,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.s16),

              // Tags
              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.programTags,
                  hintText: "e.g., HIGH_RISK, ANAEMIC",
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.textSecondary.withAlpha(31),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : Text(AppLocalizations.of(context)!.recordVisit, style: AppTextStyles.button),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
