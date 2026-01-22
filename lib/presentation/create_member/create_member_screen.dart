import 'package:flutter/material.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/domain/usecases/create_member_usecase.dart';

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
  
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  Future<void> _pickDate({required bool isLmp}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isLmp) {
          _lmpDate = picked;
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
      final effectiveIsPregnant = _gender == 'F' ? _isPregnant : null; // or false? Domain says bool?, DB handles null. If Male, null is safer or false. 
      // Actually member entity has isPregnant as bool?. 
      // Logic: If gender != F, isPregnant should probably be null or false.
      // Let's settle on false or null. Database default is NULL. 
      // If I send null, it means "unknown" or "N/A".
      
      final effectiveLmp = (effectiveIsPregnant == true) ? _lmpDate?.millisecondsSinceEpoch : null;

      await createUseCase(
        householdId: widget.householdId,
        name: _nameController.text,
        gender: _gender,
        dateOfBirth: _dob?.millisecondsSinceEpoch,
        isPregnant: effectiveIsPregnant,
        lmpDate: effectiveLmp,
        // Calculate EDD? limit to scope: "optional input for these fields". 
        // I won't calculate EDD here to keep it simple unless needed.
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name *"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_dob == null 
                  ? "Date of Birth (Optional)" 
                  : "DOB: ${_dob!.day}/${_dob!.month}/${_dob!.year}"
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(isLmp: false),
              ),
              if (_gender == 'F') ...[
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Is Pregnant?"),
                  value: _isPregnant,
                  onChanged: (val) => setState(() {
                     _isPregnant = val;
                     if (!val) _lmpDate = null;
                  }),
                ),
                if (_isPregnant)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_lmpDate == null 
                      ? "Select LMP Date *" 
                      : "LMP: ${_lmpDate!.day}/${_lmpDate!.month}/${_lmpDate!.year}"
                    ),
                    trailing: const Icon(Icons.calendar_today, color: Colors.pink),
                    onTap: () => _pickDate(isLmp: true),
                  ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20, width: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2)
                        )
                      : const Text("Save Member"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
