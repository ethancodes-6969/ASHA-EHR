// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'आशा ईएचआर';

  @override
  String get save => 'जतन करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get syncNow => 'आता सिंक करा';

  @override
  String get lastSynced => 'शेवटचे सिंक';

  @override
  String get notSyncedYet => 'अद्याप सिंक केलेले नाही';

  @override
  String get syncFailed => 'शेवटचे सिंक अयशस्वी — डेटा सुरक्षित आहे';

  @override
  String get households => 'कुटुंबे';

  @override
  String get members => 'सदस्य';

  @override
  String get visits => 'भेटी';

  @override
  String get dueVisits => 'बाकी भेटी';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get syncing => 'डेटा सिंक होत आहे...';

  @override
  String get syncComplete => 'सिंक पूर्ण झाले';

  @override
  String get confirmRestore => 'रिस्टोरची पुष्टी करा';

  @override
  String restoreConfirmMessage(Object id) {
    return 'तुम्ही नक्की ID: $id साठी डेटा रिस्टोर करू इच्छिता? सध्याचा डेटा विलीन केला जाईल.';
  }

  @override
  String get restoring => 'रिस्टोर होत आहे...';

  @override
  String get recovery => 'रिकवरी';

  @override
  String get search => 'शोधा';

  @override
  String get searchHouseholds => 'कुटुंब शोधा';

  @override
  String get searchHouseholdsHint => 'नाव किंवा ठिकाण';

  @override
  String get noResults => 'काहीही सापडले नाही.';

  @override
  String get archive => 'संग्रहित करा';

  @override
  String get edit => 'संपादित करा';

  @override
  String get archiveHousehold => 'कुटुंब संग्रहित करायचे?';

  @override
  String get archiveHouseholdConfirm =>
      'हे घर आणि त्याचे सदस्य लपवले जातील. हे केवळ ऍडमिनद्वारेच पुनर्संचयित केले जाऊ शकते.';

  @override
  String get editHousehold => 'कुटुंब संपादित करा';

  @override
  String get createHousehold => 'नवीन कुटुंब जोडा';

  @override
  String get householdDetails => 'कुटुंबाचे विवरण';

  @override
  String get familyHeadName => 'कुटुंब प्रमुखाचे नाव *';

  @override
  String get villageName => 'गाव / ठिकाणाचे नाव *';

  @override
  String get saveHousehold => 'कुटुंब जतन करा';

  @override
  String membersCount(Object count) {
    return 'सदस्य: $count';
  }

  @override
  String get dueTasks => 'बाकी कार्ये';

  @override
  String get searchMembers => 'सदस्य शोधा';

  @override
  String get noMembersFound => 'कोणीही सदस्य आढळले नाहीत.';

  @override
  String get editMember => 'सदस्य संपादित करा';

  @override
  String get createMember => 'नवीन सदस्य जोडा';

  @override
  String get personalDetails => 'वैयक्तिक माहिती';

  @override
  String get fullName => 'पूर्ण नाव *';

  @override
  String get gender => 'लिंग';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'स्त्री';

  @override
  String get dateOfBirth => 'जन्मतारीख';

  @override
  String get isPregnant => 'गरोदर आहे का?';

  @override
  String get lmpDate => 'एलएमपी तारीख';

  @override
  String get deliveryDate => 'प्रसूती तारीख';

  @override
  String get healthId => 'ABHA / हेल्थ आयडी';

  @override
  String get saveMember => 'सदस्य जतन करा';

  @override
  String get recordVisit => 'भेट नोंदवा';

  @override
  String get visitDetails => 'भेटीचे तपशील';

  @override
  String get visitDate => 'भेटीची तारीख';

  @override
  String get visitType => 'भेटीचा प्रकार';

  @override
  String get notes => 'टीप / निरीक्षणे';

  @override
  String get programTags => 'प्रोग्राम टॅग (स्वल्पविरामाने वेगळे करा)';

  @override
  String get saveVisit => 'भेट जतन करा';

  @override
  String get dangerZone => 'डेंजर झोन: डेटा पुनर्संचयित करा';

  @override
  String get restoreDataInstruction =>
      'जर तुम्ही तुमचे डिव्हाइस रिसेट केले असेल, तर तुमचा डेटा परत मिळवण्यासाठी येथे तुमचा जुना डिव्हाइस आयडी टाका. चेतावणी: यामुळे स्थानिक डेटा मिटविला जाईल.';

  @override
  String get enterOldDeviceId => 'जुना डिव्हाइस आयडी टाका';

  @override
  String get restoreData => 'डेटा पुनर्संचयित करा';

  @override
  String get idCopied => 'आयडी कॉपी केला';

  @override
  String get deviceIdentity => 'डिव्हाइस ओळख';

  @override
  String get ashaDeviceId => 'आशा डिव्हाइस आयडी';

  @override
  String errorSaving(Object error) {
    return 'जतन करताना त्रुटी: $error';
  }

  @override
  String get required => 'आवश्यक';

  @override
  String get allCaughtUp => 'सर्व काही झाले! कोणतीही कार्ये बाकी नाहीत.';

  @override
  String get todayOverview => 'आजचा आढावा';

  @override
  String get navigation => 'नेव्हिगेशन';

  @override
  String get householdsRegister => 'कुटुंब रजिस्टर';
}
