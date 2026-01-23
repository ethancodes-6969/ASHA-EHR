import 'package:flutter/material.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/domain/entities/member.dart';
import 'package:asha_ehr/domain/usecases/create_member_usecase.dart';
import 'package:asha_ehr/domain/usecases/update_member_usecase.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/components/section_header.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';
import 'package:asha_ehr/l10n/app_localizations.dart';

class CreateMemberScreen extends StatefulWidget {
  final String householdId;
  final Member? member;

  const CreateMemberScreen({super.key, required this.householdId, this.member});

  @override
  State<CreateMemberScreen> createState() => _CreateMemberScreenState();
}

class _CreateMemberScreenState extends State<CreateMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _gender = 'M';
  DateTime? _dob;
  bool _isPregnant = false;
  DateTime? _lmpDate;
  DateTime? _deliveryDate;
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      _nameController.text = widget.member!.name;
      _gender = widget.member!.gender;
      if (widget.member!.dateOfBirth != null) {
        _dob = DateTime.fromMillisecondsSinceEpoch(widget.member!.dateOfBirth!);
      }
      _isPregnant = widget.member!.isPregnant ?? false;
      if (widget.member!.lmpDate != null) {
        _lmpDate = DateTime.fromMillisecondsSinceEpoch(widget.member!.lmpDate!);
      }
      if (widget.member!.deliveryDate != null) {
        _deliveryDate = DateTime.fromMillisecondsSinceEpoch(widget.member!.deliveryDate!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  Future<void> _pickDate({required String type}) async {
    DateTime firstDate = DateTime(1900);
    if (type == 'delivery') {
      firstDate = DateTime.now().subtract(const Duration(days: 365));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (type == 'lmp') {
          _lmpDate = picked;
        } else if (type == 'delivery') {
          _deliveryDate = picked;
        } else {
          _dob = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final effectiveIsPregnant = _gender == 'F' ? _isPregnant : null; 
      final effectiveLmp = (effectiveIsPregnant == true) ? _lmpDate?.millisecondsSinceEpoch : null;
      final effectiveDelivery = (_gender == 'F' && effectiveIsPregnant != true) ? _deliveryDate?.millisecondsSinceEpoch : null;

      if (widget.member != null) {
        // Update
        final updateUseCase = getIt<UpdateMemberUseCase>();
        await updateUseCase(
          member: widget.member!,
          name: _nameController.text,
          gender: _gender,
          dateOfBirth: _dob?.millisecondsSinceEpoch,
          isPregnant: effectiveIsPregnant,
          lmpDate: effectiveLmp,
          deliveryDate: effectiveDelivery,
        );
      } else {
        // Create
        final createUseCase = getIt<CreateMemberUseCase>();
        await createUseCase(
          householdId: widget.householdId,
          name: _nameController.text,
          gender: _gender,
          dateOfBirth: _dob?.millisecondsSinceEpoch,
          isPregnant: effectiveIsPregnant,
          lmpDate: effectiveLmp,
          deliveryDate: effectiveDelivery,
        );
      }

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
    final isEdit = widget.member != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? AppLocalizations.of(context)!.editMember : AppLocalizations.of(context)!.createMember)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: AppLocalizations.of(context)!.personalDetails, icon: Icons.person_outline),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.fullName),
                validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: AppSpacing.s16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.gender),
                items: [
                  DropdownMenuItem(value: 'M', child: Text(AppLocalizations.of(context)!.male)),
                  DropdownMenuItem(value: 'F', child: Text(AppLocalizations.of(context)!.female)),
                  const DropdownMenuItem(value: 'O', child: Text("Other")),
                ],
                onChanged: (val) => setState(() => _gender = val!),
              ),
              const SizedBox(height: AppSpacing.s16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_dob == null 
                  ? "${AppLocalizations.of(context)!.dateOfBirth} (Optional)" 
                  : "${AppLocalizations.of(context)!.dateOfBirth}: ${_dob!.day}/${_dob!.month}/${_dob!.year}"
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(type: 'dob'),
              ),
              if (_gender == 'F') ...[
                const SizedBox(height: AppSpacing.s24),
                const SectionHeader(title: "Clinical Information", icon: Icons.medical_services_outlined),
                const SizedBox(height: AppSpacing.s12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.isPregnant),
                  value: _isPregnant,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() {
                     _isPregnant = val;
                     if (!val) _lmpDate = null;
                     else _deliveryDate = null;
                  }),
                ),
                if (_isPregnant)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_lmpDate == null 
                      ? "${AppLocalizations.of(context)!.lmpDate} *" 
                      : "${AppLocalizations.of(context)!.lmpDate}: ${_lmpDate!.day}/${_lmpDate!.month}/${_lmpDate!.year}"
                    ),
                    trailing: const Icon(Icons.calendar_today, color: Colors.pink), 
                    onTap: () => _pickDate(type: 'lmp'),
                  ),
                if (!_isPregnant)
                   ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_deliveryDate == null 
                      ? "${AppLocalizations.of(context)!.deliveryDate} (if recent)" 
                      : "${AppLocalizations.of(context)!.deliveryDate}: ${_deliveryDate!.day}/${_deliveryDate!.month}/${_deliveryDate!.year}"
                    ),
                    subtitle: _deliveryDate == null ? const Text("For PNC tracking") : null,
                    trailing: const Icon(Icons.child_friendly, color: AppColors.success),
                    onTap: () => _pickDate(type: 'delivery'),
                  ),
              ],
              const SizedBox(height: AppSpacing.s32),
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
                      : Text(AppLocalizations.of(context)!.saveMember, style: AppTextStyles.button),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
