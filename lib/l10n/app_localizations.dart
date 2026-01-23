import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ASHA EHR'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced'**
  String get lastSynced;

  /// No description provided for @notSyncedYet.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get notSyncedYet;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Last sync failed — data is safe'**
  String get syncFailed;

  /// No description provided for @households.
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get households;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @dueVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits Due'**
  String get dueVisits;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing Data...'**
  String get syncing;

  /// No description provided for @syncComplete.
  ///
  /// In en, this message translates to:
  /// **'Sync Complete'**
  String get syncComplete;

  /// No description provided for @confirmRestore.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restore'**
  String get confirmRestore;

  /// No description provided for @restoreConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore data for ID: {id}? CURRENT DATA WILL BE MERGED.'**
  String restoreConfirmMessage(Object id);

  /// No description provided for @restoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// No description provided for @recovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get recovery;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHouseholds.
  ///
  /// In en, this message translates to:
  /// **'Search Households'**
  String get searchHouseholds;

  /// No description provided for @searchHouseholdsHint.
  ///
  /// In en, this message translates to:
  /// **'Name or Location'**
  String get searchHouseholdsHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResults;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @archiveHousehold.
  ///
  /// In en, this message translates to:
  /// **'Archive Household?'**
  String get archiveHousehold;

  /// No description provided for @archiveHouseholdConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will hide the household and its members. It can be restored by admin only.'**
  String get archiveHouseholdConfirm;

  /// No description provided for @editHousehold.
  ///
  /// In en, this message translates to:
  /// **'Edit Household'**
  String get editHousehold;

  /// No description provided for @createHousehold.
  ///
  /// In en, this message translates to:
  /// **'Create Household'**
  String get createHousehold;

  /// No description provided for @householdDetails.
  ///
  /// In en, this message translates to:
  /// **'Household Details'**
  String get householdDetails;

  /// No description provided for @familyHeadName.
  ///
  /// In en, this message translates to:
  /// **'Family Head Name *'**
  String get familyHeadName;

  /// No description provided for @villageName.
  ///
  /// In en, this message translates to:
  /// **'Village / Location Name *'**
  String get villageName;

  /// No description provided for @saveHousehold.
  ///
  /// In en, this message translates to:
  /// **'SAVE HOUSEHOLD'**
  String get saveHousehold;

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'Members: {count}'**
  String membersCount(Object count);

  /// No description provided for @dueTasks.
  ///
  /// In en, this message translates to:
  /// **'Due Tasks'**
  String get dueTasks;

  /// No description provided for @searchMembers.
  ///
  /// In en, this message translates to:
  /// **'Search Members'**
  String get searchMembers;

  /// No description provided for @noMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found.'**
  String get noMembersFound;

  /// No description provided for @editMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get editMember;

  /// No description provided for @createMember.
  ///
  /// In en, this message translates to:
  /// **'Create Member'**
  String get createMember;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @isPregnant.
  ///
  /// In en, this message translates to:
  /// **'Is Pregnant?'**
  String get isPregnant;

  /// No description provided for @lmpDate.
  ///
  /// In en, this message translates to:
  /// **'LMP Date'**
  String get lmpDate;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDate;

  /// No description provided for @healthId.
  ///
  /// In en, this message translates to:
  /// **'ABHA / Health ID'**
  String get healthId;

  /// No description provided for @saveMember.
  ///
  /// In en, this message translates to:
  /// **'SAVE MEMBER'**
  String get saveMember;

  /// No description provided for @recordVisit.
  ///
  /// In en, this message translates to:
  /// **'Record Visit'**
  String get recordVisit;

  /// No description provided for @visitDetails.
  ///
  /// In en, this message translates to:
  /// **'Visit Details'**
  String get visitDetails;

  /// No description provided for @visitDate.
  ///
  /// In en, this message translates to:
  /// **'Visit Date'**
  String get visitDate;

  /// No description provided for @visitType.
  ///
  /// In en, this message translates to:
  /// **'Visit Type'**
  String get visitType;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes / Observations'**
  String get notes;

  /// No description provided for @programTags.
  ///
  /// In en, this message translates to:
  /// **'Program Tags (comma separated)'**
  String get programTags;

  /// No description provided for @saveVisit.
  ///
  /// In en, this message translates to:
  /// **'SAVE VISIT'**
  String get saveVisit;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone: Restore Data'**
  String get dangerZone;

  /// No description provided for @restoreDataInstruction.
  ///
  /// In en, this message translates to:
  /// **'If you reformatted your device, paste your OLD Device ID here to recover your data. WARNING: This will overwrite local data.'**
  String get restoreDataInstruction;

  /// No description provided for @enterOldDeviceId.
  ///
  /// In en, this message translates to:
  /// **'Enter Old Device ID'**
  String get enterOldDeviceId;

  /// No description provided for @restoreData.
  ///
  /// In en, this message translates to:
  /// **'RESTORE DATA'**
  String get restoreData;

  /// No description provided for @idCopied.
  ///
  /// In en, this message translates to:
  /// **'ID Copied'**
  String get idCopied;

  /// No description provided for @deviceIdentity.
  ///
  /// In en, this message translates to:
  /// **'Device Identity'**
  String get deviceIdentity;

  /// No description provided for @ashaDeviceId.
  ///
  /// In en, this message translates to:
  /// **'ASHA Device ID'**
  String get ashaDeviceId;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String errorSaving(Object error);

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up! No due tasks.'**
  String get allCaughtUp;

  /// No description provided for @todayOverview.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Overview'**
  String get todayOverview;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @householdsRegister.
  ///
  /// In en, this message translates to:
  /// **'Households Register'**
  String get householdsRegister;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
