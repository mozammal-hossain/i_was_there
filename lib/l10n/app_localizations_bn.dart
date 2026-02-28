// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get back => 'পিছনে';

  @override
  String get calendarSync => 'ক্যালেন্ডার সিঙ্ক';

  @override
  String get syncWithGoogleCalendar => 'Google ক্যালেন্ডারের সাথে সিঙ্ক করুন';

  @override
  String get automaticAttendanceLogging => 'স্বয়ংক্রিয় উপস্থিতি লগিং';

  @override
  String get oneWaySyncNote =>
      'একমুখী সিঙ্ক: আমরা শুধুমাত্র আপনার ক্যালেন্ডারে ইভেন্ট যোগ করি। আমরা আপনার বিদ্যমান ডেটা কখনও পড়ি বা মুছি না।';

  @override
  String get language => 'ভাষা';

  @override
  String get languageEnglish => 'ইংরেজি';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get places => 'স্থানসমূহ';

  @override
  String get calendar => 'ক্যালেন্ডার';

  @override
  String get settings => 'সেটিংস';

  @override
  String get connectedAccount => 'সংযুক্ত অ্যাকাউন্ট';

  @override
  String get changeAccountComingSoon => 'অ্যাকাউন্ট পরিবর্তন – শীঘ্রই আসছে';

  @override
  String get change => 'পরিবর্তন';

  @override
  String lastSyncedAt(String timeAgo) {
    return '$timeAgo এ সিঙ্ক হয়েছে';
  }

  @override
  String get neverSynced => 'কখনও সিঙ্ক হয়নি';

  @override
  String get connected => 'সংযুক্ত';

  @override
  String get syncDetails => 'সিঙ্ক বিবরণ';

  @override
  String get automatedEvents => 'স্বয়ংক্রিয় ইভেন্ট';

  @override
  String get visitsLoggedAs => 'ভিজিটগুলো এভাবে লগ হয়: ';

  @override
  String get presentAtLocation => '[লোকেশন]-এ উপস্থিত';

  @override
  String get inPrimaryCalendar => ' আপনার প্রাথমিক ক্যালেন্ডারে।';

  @override
  String get syncNow => 'এখনই সিঙ্ক করুন';

  @override
  String get syncing => 'সিঙ্ক হচ্ছে…';

  @override
  String get footerPrivacy =>
      'আপনার গোপনীয়তা আমাদের অগ্রাধিকার। আমরা শুধুমাত্র আপনার ফিটনেস ধারাবাহিকতা ট্র্যাক করতে ক্যালেন্ডার অ্যাক্সেস ব্যবহার করি।';

  @override
  String get appTitle => 'I Was There';

  @override
  String get whyIWasThere => 'কেন I Was There';

  @override
  String get whySubtitle =>
      'আপনার গুরুত্বপূর্ণ স্থানগুলো সংজ্ঞায়িত করুন এবং প্রতিদিন স্বয়ংক্রিয়ভাবে আপনার উপস্থিতি রেকর্ড করুন। আমরা ট্র্যাকিং পরিচালনা করি যখন আপনি আপনার ফিটনেস লক্ষ্যের দিকে মনোনিবেশ করুন।';

  @override
  String get continueButton => 'চালিয়ে যান';

  @override
  String get maybeLater => 'পরে দেখি';

  @override
  String get googleCalendarSync => 'Google ক্যালেন্ডার সিঙ্ক';

  @override
  String get googleCalendarSyncSubtitle =>
      'এক জায়গায় আপনার সব কার্যকলাপ এবং জিম সেশন দেখুন।';

  @override
  String stepNumber(int number) {
    return 'ধাপ $number';
  }

  @override
  String get howAddPlaces => 'ম্যাপে আপনার স্থানগুলো যোগ করুন';

  @override
  String get howLocationPermission =>
      'ব্যাকগ্রাউন্ড চেকের জন্য লোকেশন অনুমতি দিন';

  @override
  String get howMarksPresence =>
      'অ্যাপ স্বয়ংক্রিয়ভাবে আপনার উপস্থিতি চিহ্নিত করে';

  @override
  String get howSyncCalendar =>
      'ঐচ্ছিকভাবে Google ক্যালেন্ডারের সাথে সিঙ্ক করুন';

  @override
  String get howViewHistory =>
      'ক্যালেন্ডার ট্যাবে আপনার ইতিহাস দেখুন এবং সামঞ্জস্য করুন';

  @override
  String get enableAllowAllTheTime => '\'সব সময় অনুমতি দিন\' সক্ষম করুন';

  @override
  String get backgroundLocationBody =>
      'প্রতি ১০ মিনিটে Google ক্যালেন্ডারের সাথে আপনার শারীরিক উপস্থিতি স্বয়ংক্রিয়ভাবে সিঙ্ক করতে, অ্যাপ বন্ধ থাকলেও আমাদের ব্যাকগ্রাউন্ড লোকেশন অ্যাক্সেস প্রয়োজন।';

  @override
  String get locationPermission => 'লোকেশন অনুমতি';

  @override
  String get allowAllTheTime => 'সব সময় অনুমতি দিন';

  @override
  String get howToEnable => 'কিভাবে সক্ষম করবেন:';

  @override
  String get tapOpenSettings => 'নিচে \'সেটিংস খুলুন\' ট্যাপ করুন';

  @override
  String get goToPermissionsLocation => 'অনুমতি > লোকেশনে যান';

  @override
  String get selectAllowAllTheTime => '\'সব সময় অনুমতি দিন\' নির্বাচন করুন';

  @override
  String get openingSystemSettings => 'সিস্টেম সেটিংস খোলা হচ্ছে…';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get noPlacesYet => 'এখনও কোন স্থান নেই';

  @override
  String get addPlaceToStart =>
      'আপনার সাপ্তাহিক উপস্থিতি ট্র্যাক করতে একটি স্থান যোগ করুন।';

  @override
  String get addYourFirstPlace => 'আপনার প্রথম স্থান যোগ করুন';

  @override
  String get map => 'ম্যাপ';

  @override
  String get history => 'ইতিহাস';

  @override
  String get weeklyAttendance => 'সাপ্তাহিক উপস্থিতি';

  @override
  String get overrideLabel => 'ওভাররাইড';

  @override
  String get trackedStudios => 'ট্র্যাক করা স্টুডিও';

  @override
  String get addLocation => 'লোকেশন যোগ করুন';

  @override
  String get pleaseEnterPlaceName => 'অনুগ্রহ করে স্থানের নাম লিখুন';

  @override
  String get locationSet => 'লোকেশন সেট করা হয়েছে।';

  @override
  String couldNotGetLocation(String error) {
    return 'লোকেশন পাওয়া যায়নি: $error';
  }

  @override
  String couldNotSave(String error) {
    return 'সংরক্ষণ করা যায়নি: $error';
  }

  @override
  String get trackedPlace => 'ট্র্যাক করা স্থান';

  @override
  String get cancel => 'বাতিল';

  @override
  String get name => 'নাম';

  @override
  String get address => 'ঠিকানা';

  @override
  String get enterPlaceName => 'স্থানের নাম লিখুন';

  @override
  String get searchAddress => 'ঠিকানা খুঁজুন...';

  @override
  String get searchAddressTooltip => 'ঠিকানা খুঁজুন';

  @override
  String get useMyCurrentLocation => 'আমার বর্তমান লোকেশন ব্যবহার করুন';

  @override
  String get geoFenceDescription =>
      '২০মি জিওফেন্স গোপনীয়তা এবং ব্যাটারি দক্ষতা বজায় রেখে সঠিক উপস্থিতি ট্র্যাকিং নিশ্চিত করে।';

  @override
  String get saveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get updatesSyncWithGoogleCalendar =>
      'আপডেট Google ক্যালেন্ডারের সাথে সিঙ্ক হয়';

  @override
  String get allPlaces => 'সব স্থান';

  @override
  String get presenceHistory => 'উপস্থিতির ইতিহাস';

  @override
  String get syncComingSoon => 'সিঙ্ক – শীঘ্রই আসছে';

  @override
  String get dayDetails => 'দিনের বিবরণ';

  @override
  String get tapDayToSeeSessions =>
      'সেশন দেখতে ক্যালেন্ডারে একটি দিন ট্যাপ করুন';

  @override
  String dayDetailsTitle(String month, int day) {
    return 'দিনের বিবরণ • $month $day';
  }

  @override
  String get present => 'উপস্থিত';

  @override
  String get noSessions => 'কোন সেশন নেই';

  @override
  String get noRecordedSessionsForDay =>
      'এই দিনের জন্য কোন রেকর্ড করা সেশন নেই';

  @override
  String get unknownPlace => 'অজানা স্থান';

  @override
  String get recorded => 'রেকর্ড করা হয়েছে';

  @override
  String get sun => 'রবি';

  @override
  String get mon => 'সোম';

  @override
  String get tue => 'মঙ্গল';

  @override
  String get wed => 'বুধ';

  @override
  String get thu => 'বৃহ';

  @override
  String get fri => 'শুক্র';

  @override
  String get sat => 'শনি';

  @override
  String get noPlacesToShow => 'দেখানোর কোন স্থান নেই';

  @override
  String get addTrackedPlacesFromDashboard =>
      'সেগুলো ম্যাপে দেখতে ড্যাশবোর্ড থেকে ট্র্যাক করা স্থান যোগ করুন।';

  @override
  String get manualPresenceOverride => 'ম্যানুয়াল উপস্থিতি ওভাররাইড';

  @override
  String get changeDate => 'তারিখ পরিবর্তন করুন';

  @override
  String get syncsWithGoogleCalendar => 'GOOGLE ক্যালেন্ডারের সাথে সিঙ্ক হয়';

  @override
  String get applyChanges => 'পরিবর্তন প্রয়োগ করুন';

  @override
  String get updateRequired => 'আপডেট প্রয়োজন';

  @override
  String get forceUpdateMessage =>
      'I Was There-এর একটি নতুন সংস্করণ প্রয়োজন। চালিয়ে যেতে অনুগ্রহ করে আপডেট করুন।';

  @override
  String get update => 'আপডেট';

  @override
  String get manualPresenceUpdated => 'ম্যানুয়াল উপস্থিতি আপডেট হয়েছে';

  @override
  String get notSignedIn => 'সাইন ইন করা নেই';

  @override
  String get onboarding => 'অনবোর্ডিং';

  @override
  String get howItWorks => 'কিভাবে কাজ করে';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get illDoThisLater => 'আমি পরে করব';

  @override
  String get backgroundLocationFooterPrivacy =>
      'আপনার ডেটা শুধুমাত্র ক্যালেন্ডার সিঙ্কের জন্য ব্যবহার হয় এবং সম্পূর্ণ এনক্রিপ্টেড। আমরা কখনও তৃতীয় পক্ষের সাথে আপনার লোকেশন শেয়ার করি না।';
}
