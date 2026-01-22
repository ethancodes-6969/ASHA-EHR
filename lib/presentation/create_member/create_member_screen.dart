import 'package:flutter/material.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/domain/usecases/create_member_usecase.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/components/section_header.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';

class CreateMemberScreen extends StatefulWidget {
  final String householdId;

  const CreateMemberScreen({super.key, required this.householdId});

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
    // DOB is now optional, so no null check needed.

    setState(() => _isSaving = true);

    try {
      final createUseCase = getIt<CreateMemberUseCase>();
      
      // Cleanup: If not female, cannot be pregnant
      final effectiveIsPregnant = _gender == 'F' ? _isPregnant : null; 
      
      final effectiveLmp = (effectiveIsPregnant == true) ? _lmpDate?.millisecondsSinceEpoch : null;
      final effectiveDelivery = (_gender == 'F' && effectiveIsPregnant != true) ? _deliveryDate?.millisecondsSinceEpoch : null;

      await createUseCase(
        householdId: widget.householdId,
        name: _nameController.text,
        gender: _gender,
        dateOfBirth: _dob?.millisecondsSinceEpoch,
        isPregnant: effectiveIsPregnant,
        lmpDate: effectiveLmp,
        deliveryDate: effectiveDelivery,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving: $e")),
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
      appBar: AppBar(title: const Text("Add Member")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: "Personal Details"),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name *"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: AppSpacing.s16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: "Gender"),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text("Male")),
                  DropdownMenuItem(value: 'F', child: Text("Female")),
                  DropdownMenuItem(value: 'O', child: Text("Other")),
                ],
                onChanged: (val) => setState(() => _gender = val!),
              ),
              const SizedBox(height: AppSpacing.s16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_dob == null 
                  ? "Date of Birth (Optional)" 
                  : "DOB: ${_dob!.day}/${_dob!.month}/${_dob!.year}"
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(type: 'dob'),
              ),
              if (_gender == 'F') ...[
                const SizedBox(height: AppSpacing.s24),
                const SectionHeader(title: "Clinical Information"),
                const SizedBox(height: AppSpacing.s12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Is Pregnant?"),
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
                      ? "Select LMP Date *" 
                      : "LMP: ${_lmpDate!.day}/${_lmpDate!.month}/${_lmpDate!.year}"
                    ),
                    trailing: const Icon(Icons.calendar_today, color: Colors.pink), // Hardcoded pink allowed for logic differentiation or use AppColors.primary? Pink is standard for Maternal.
                    onTap: () => _pickDate(type: 'lmp'),
                  ),
                if (!_isPregnant)
                   ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_deliveryDate == null 
                      ? "Delivery Date (if recent)" 
                      : "Delivered: ${_deliveryDate!.day}/${_deliveryDate!.month}/${_deliveryDate!.year}"
                    ),
                    subtitle: _deliveryDate == null ? const Text("For PNC tracking") : null,
                    trailing: const Icon(Icons.child_friendly, color: AppColors.success),
                    onTap: () => _pickDate(type: 'delivery'),
                  ),
              ],
              const SizedBox(height: AppSpacing.s32),
              SizedBox(
                width: double.infinity,
                height: 52,
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
                      : const Text("Save Member", style: AppTextStyles.button),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
