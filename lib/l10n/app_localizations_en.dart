// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ASHA EHR';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get lastSynced => 'Last synced';

  @override
  String get notSyncedYet => 'Not synced yet';

  @override
  String get syncFailed => 'Last sync failed — data is safe';

  @override
  String get households => 'Households';

  @override
  String get members => 'Members';

  @override
  String get visits => 'Visits';

  @override
  String get dueVisits => 'Visits Due';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get retry => 'Retry';

  @override
  String get syncing => 'Syncing Data...';

  @override
  String get syncComplete => 'Sync Complete';

  @override
  String get confirmRestore => 'Confirm Restore';

  @override
  String restoreConfirmMessage(Object id) {
    return 'Are you sure you want to restore data for ID: $id? CURRENT DATA WILL BE MERGED.';
  }

  @override
  String get restoring => 'Restoring...';

  @override
  String get recovery => 'Recovery';

  @override
  String get search => 'Search';

  @override
  String get searchHouseholds => 'Search Households';

  @override
  String get searchHouseholdsHint => 'Name or Location';

  @override
  String get noResults => 'No results found.';

  @override
  String get archive => 'Archive';

  @override
  String get edit => 'Edit';

  @override
  String get archiveHousehold => 'Archive Household?';

  @override
  String get archiveHouseholdConfirm =>
      'This will hide the household and its members. It can be restored by admin only.';

  @override
  String get editHousehold => 'Edit Household';

  @override
  String get createHousehold => 'Create Household';

  @override
  String get householdDetails => 'Household Details';

  @override
  String get familyHeadName => 'Family Head Name *';

  @override
  String get villageName => 'Village / Location Name *';

  @override
  String get saveHousehold => 'SAVE HOUSEHOLD';

  @override
  String membersCount(Object count) {
    return 'Members: $count';
  }

  @override
  String get dueTasks => 'Due Tasks';

  @override
  String get searchMembers => 'Search Members';

  @override
  String get noMembersFound => 'No members found.';

  @override
  String get editMember => 'Edit Member';

  @override
  String get createMember => 'Create Member';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get fullName => 'Full Name *';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get isPregnant => 'Is Pregnant?';

  @override
  String get lmpDate => 'LMP Date';

  @override
  String get deliveryDate => 'Delivery Date';

  @override
  String get healthId => 'ABHA / Health ID';

  @override
  String get saveMember => 'SAVE MEMBER';

  @override
  String get recordVisit => 'Record Visit';

  @override
  String get visitDetails => 'Visit Details';

  @override
  String get visitDate => 'Visit Date';

  @override
  String get visitType => 'Visit Type';

  @override
  String get notes => 'Notes / Observations';

  @override
  String get programTags => 'Program Tags (comma separated)';

  @override
  String get saveVisit => 'SAVE VISIT';

  @override
  String get dangerZone => 'Danger Zone: Restore Data';

  @override
  String get restoreDataInstruction =>
      'If you reformatted your device, paste your OLD Device ID here to recover your data. WARNING: This will overwrite local data.';

  @override
  String get enterOldDeviceId => 'Enter Old Device ID';

  @override
  String get restoreData => 'RESTORE DATA';

  @override
  String get idCopied => 'ID Copied';

  @override
  String get deviceIdentity => 'Device Identity';

  @override
  String get ashaDeviceId => 'ASHA Device ID';

  @override
  String errorSaving(Object error) {
    return 'Error saving: $error';
  }

  @override
  String get required => 'Required';

  @override
  String get allCaughtUp => 'All caught up! No due tasks.';

  @override
  String get todayOverview => 'Today\'s Overview';

  @override
  String get navigation => 'Navigation';

  @override
  String get householdsRegister => 'Households Register';
}
