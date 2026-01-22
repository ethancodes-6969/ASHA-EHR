import 'package:flutter/material.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/domain/entities/household.dart';
import 'package:asha_ehr/domain/usecases/create_household_usecase.dart';
import 'package:asha_ehr/domain/usecases/update_household_usecase.dart';
import 'package:asha_ehr/presentation/theme/app_colors.dart';
import 'package:asha_ehr/presentation/theme/app_spacing.dart';
import 'package:asha_ehr/presentation/components/section_header.dart';
import 'package:asha_ehr/presentation/theme/app_text_styles.dart';

class CreateHouseholdScreen extends StatefulWidget {
  final Household? household;
  
  const CreateHouseholdScreen({super.key, this.household});

  @override
  State<CreateHouseholdScreen> createState() => _CreateHouseholdScreenState();
}

class _CreateHouseholdScreenState extends State<CreateHouseholdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.household != null) {
      _nameController.text = widget.household!.familyHeadName;
      _locationController.text = widget.household!.locationDescription;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      if (widget.household != null) {
        // Update
        final updateUseCase = getIt<UpdateHouseholdUseCase>();
        await updateUseCase(
          household: widget.household!,
          familyHeadName: _nameController.text,
          locationDescription: _locationController.text,
        );
      } else {
        // Create
        final createUseCase = getIt<CreateHouseholdUseCase>();
        await createUseCase(
          familyHeadName: _nameController.text,
          locationDescription: _locationController.text,
        );
      }
      
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
    final isEdit = widget.household != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Household" : "Create Household")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SectionHeader(title: "Household Details"),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Family Head Name *"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location / Landmark"),
              ),
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
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(isEdit ? "Save Changes" : "Save Household", style: AppTextStyles.button),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
