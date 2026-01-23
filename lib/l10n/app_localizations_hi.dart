// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'आशा ईएचआर';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get lastSynced => 'अंतिम सिंक';

  @override
  String get notSyncedYet => 'अभी तक सिंक नहीं हुआ';

  @override
  String get syncFailed => 'पिछला सिंक विफल - डेटा सुरक्षित है';

  @override
  String get households => 'परिवार';

  @override
  String get members => 'सदस्य';

  @override
  String get visits => 'भेंट';

  @override
  String get dueVisits => 'बकाया भेट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get syncing => 'डेटा सिंक हो रहा है...';

  @override
  String get syncComplete => 'सिंक पूर्ण';

  @override
  String get confirmRestore => 'रिस्टोर की पुष्टि करें';

  @override
  String restoreConfirmMessage(Object id) {
    return 'क्या आप ID: $id के लिए डेटा रिस्टोर करना सुनिश्चित हैं? मौजूदा डेटा मर्ज किया जाएगा।';
  }

  @override
  String get restoring => 'रिस्टोर हो रहा है...';

  @override
  String get recovery => 'रिकवरी';

  @override
  String get search => 'खोजें';

  @override
  String get searchHouseholds => 'घर खोजें';

  @override
  String get searchHouseholdsHint => 'नाम या स्थान';

  @override
  String get noResults => 'कोई परिणाम नहीं मिला।';

  @override
  String get archive => 'आर्काइव करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get archiveHousehold => 'घर आर्काइव करें?';

  @override
  String get archiveHouseholdConfirm =>
      'यह घर और उसके सदस्यों को छिपा देगा। इसे केवल एडमिन ही पुनर्स्थापित कर सकता है।';

  @override
  String get editHousehold => 'घर संपादित करें';

  @override
  String get createHousehold => 'नया घर बनाएं';

  @override
  String get householdDetails => 'घर का विवरण';

  @override
  String get familyHeadName => 'मुखिया का नाम *';

  @override
  String get villageName => 'गाँव / स्थान का नाम *';

  @override
  String get saveHousehold => 'घर सहेजें';

  @override
  String membersCount(Object count) {
    return 'सदस्य: $count';
  }

  @override
  String get dueTasks => 'बकाया कार्य';

  @override
  String get searchMembers => 'सदस्य खोजें';

  @override
  String get noMembersFound => 'कोई सदस्य नहीं मिला।';

  @override
  String get editMember => 'सदस्य संपादित करें';

  @override
  String get createMember => 'नया सदस्य जोड़ें';

  @override
  String get personalDetails => 'व्यक्तिगत विवरण';

  @override
  String get fullName => 'पूरा नाम *';

  @override
  String get gender => 'लिंग';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get isPregnant => 'क्या गर्भवती है?';

  @override
  String get lmpDate => 'एलएमपी तिथि';

  @override
  String get deliveryDate => 'प्रसव तिथि';

  @override
  String get healthId => 'ABHA / हेल्थ आईडी';

  @override
  String get saveMember => 'सदस्य सहेजें';

  @override
  String get recordVisit => 'भेंट दर्ज करें';

  @override
  String get visitDetails => 'भेंट का विवरण';

  @override
  String get visitDate => 'भेंट की तिथि';

  @override
  String get visitType => 'भेंट का प्रकार';

  @override
  String get notes => 'नोट्स / अवलोकन';

  @override
  String get programTags => 'प्रोग्राम टैग (अल्पविराम से अलग करें)';

  @override
  String get saveVisit => 'भेंट सहेजें';

  @override
  String get dangerZone => 'डेंजर ज़ोन: डेटा पुनर्स्थापित करें';

  @override
  String get restoreDataInstruction =>
      'यदि आपने अपना डिवाइस रीसेट किया है, तो अपना डेटा वापस पाने के लिए यहां अपना पुराना डिवाइस आईडी पेस्ट करें। चेतावनी: यह स्थानीय डेटा को मिटा देगा।';

  @override
  String get enterOldDeviceId => 'पुराना डिवाइस आईडी दर्ज करें';

  @override
  String get restoreData => 'डेटा पुनर्स्थापित करें';

  @override
  String get idCopied => 'आईडी कॉपी की गई';

  @override
  String get deviceIdentity => 'डिवाइस पहचान';

  @override
  String get ashaDeviceId => 'आशा डिवाइस आईडी';

  @override
  String errorSaving(Object error) {
    return 'सहेजने में त्रुटि: $error';
  }

  @override
  String get required => 'अनिवार्य है';

  @override
  String get allCaughtUp => 'सब हो गया! कोई कार्य शेष नहीं।';

  @override
  String get todayOverview => 'आज का अवलोकन';

  @override
  String get navigation => 'नेविगेशन';

  @override
  String get householdsRegister => 'परिवार रजिस्टर';
}
