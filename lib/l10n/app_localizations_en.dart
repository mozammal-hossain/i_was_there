// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get back => 'Back';

  @override
  String get calendarSync => 'Calendar Sync';

  @override
  String get syncWithGoogleCalendar => 'Sync with Google Calendar';

  @override
  String get automaticAttendanceLogging => 'Automatic attendance logging';

  @override
  String get oneWaySyncNote =>
      'One-way sync: We only add events to your calendar. We never read or delete your existing data.';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get places => 'Places';

  @override
  String get calendar => 'Calendar';

  @override
  String get settings => 'Settings';

  @override
  String get connectedAccount => 'CONNECTED ACCOUNT';

  @override
  String get changeAccountComingSoon => 'Change account – coming soon';

  @override
  String get change => 'Change';

  @override
  String lastSyncedAt(String timeAgo) {
    return 'Last synced $timeAgo';
  }

  @override
  String get neverSynced => 'Never synced';

  @override
  String get connected => 'CONNECTED';

  @override
  String get syncDetails => 'SYNC DETAILS';

  @override
  String get automatedEvents => 'Automated Events';

  @override
  String get visitsLoggedAs => 'Visits are logged as ';

  @override
  String get presentAtLocation => 'Present at [Location]';

  @override
  String get inPrimaryCalendar => ' in your primary calendar.';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get syncing => 'Syncing…';

  @override
  String get footerPrivacy =>
      'Your privacy is our priority. We only use calendar access to help you track your fitness consistency.';

  @override
  String get appTitle => 'I Was There';

  @override
  String get whyIWasThere => 'Why I Was There';

  @override
  String get whySubtitle =>
      'Define your important places and automatically record your presence each day. Focus on your fitness goals while we handle the tracking.';

  @override
  String get continueButton => 'Continue';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get googleCalendarSync => 'Google Calendar Sync';

  @override
  String get googleCalendarSyncSubtitle =>
      'See all your activity and gym sessions in one place.';

  @override
  String stepNumber(int number) {
    return 'STEP $number';
  }

  @override
  String get howAddPlaces => 'Add your places on the map';

  @override
  String get howLocationPermission =>
      'Grant location permission for background checks';

  @override
  String get howMarksPresence => 'The app marks your presence automatically';

  @override
  String get howSyncCalendar => 'Optionally sync with Google Calendar';

  @override
  String get howViewHistory =>
      'View and adjust your history in the Calendar tab';

  @override
  String get enableAllowAllTheTime => 'Enable \'Allow all the time\'';

  @override
  String get backgroundLocationBody =>
      'To automatically sync your physical presence with Google Calendar every 10 minutes, we need background location access even when the app is closed.';

  @override
  String get locationPermission => 'Location Permission';

  @override
  String get allowAllTheTime => 'Allow all the time';

  @override
  String get howToEnable => 'How to enable:';

  @override
  String get tapOpenSettings => 'Tap \'Open Settings\' below';

  @override
  String get goToPermissionsLocation => 'Go to Permissions > Location';

  @override
  String get selectAllowAllTheTime => 'Select \'Allow all the time\'';

  @override
  String get openingSystemSettings => 'Opening system settings…';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get noPlacesYet => 'No places yet';

  @override
  String get addPlaceToStart =>
      'Add a place to start tracking your weekly attendance.';

  @override
  String get addYourFirstPlace => 'Add your first place';

  @override
  String get map => 'Map';

  @override
  String get history => 'History';

  @override
  String get weeklyAttendance => 'Weekly Attendance';

  @override
  String get overrideLabel => 'Override';

  @override
  String get trackedStudios => 'TRACKED STUDIOS';

  @override
  String get addLocation => 'Add Location';

  @override
  String get pleaseEnterPlaceName => 'Please enter a place name';

  @override
  String get locationSet => 'Location set.';

  @override
  String couldNotGetLocation(String error) {
    return 'Could not get location: $error';
  }

  @override
  String couldNotSave(String error) {
    return 'Could not save: $error';
  }

  @override
  String get trackedPlace => 'Tracked Place';

  @override
  String get cancel => 'Cancel';

  @override
  String get name => 'NAME';

  @override
  String get address => 'ADDRESS';

  @override
  String get enterPlaceName => 'Enter place name';

  @override
  String get searchAddress => 'Search address...';

  @override
  String get searchAddressTooltip => 'Search address';

  @override
  String get useMyCurrentLocation => 'Use my current location';

  @override
  String get geoFenceDescription =>
      'A 20m geofence ensures accurate attendance tracking while maintaining privacy and battery efficiency.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get updatesSyncWithGoogleCalendar =>
      'Updates sync with Google Calendar';

  @override
  String get allPlaces => 'All Places';

  @override
  String get presenceHistory => 'Presence History';

  @override
  String get syncComingSoon => 'Sync – coming soon';

  @override
  String get dayDetails => 'DAY DETAILS';

  @override
  String get tapDayToSeeSessions => 'Tap a day on the calendar to see sessions';

  @override
  String dayDetailsTitle(String month, int day) {
    return 'DAY DETAILS • $month $day';
  }

  @override
  String get present => 'PRESENT';

  @override
  String get noSessions => 'NO SESSIONS';

  @override
  String get noRecordedSessionsForDay => 'No recorded sessions for this day';

  @override
  String get unknownPlace => 'Unknown place';

  @override
  String get recorded => 'Recorded';

  @override
  String get sun => 'Sun';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get noPlacesToShow => 'No places to show';

  @override
  String get addTrackedPlacesFromDashboard =>
      'Add tracked places from the dashboard to see them on the map.';

  @override
  String get manualPresenceOverride => 'Manual Presence Override';

  @override
  String get changeDate => 'Change date';

  @override
  String get syncsWithGoogleCalendar => 'SYNCS WITH GOOGLE CALENDAR';

  @override
  String get applyChanges => 'Apply Changes';

  @override
  String get updateRequired => 'Update required';

  @override
  String get forceUpdateMessage =>
      'A new version of I Was There is required. Please update to continue.';

  @override
  String get update => 'Update';

  @override
  String get manualPresenceUpdated => 'Manual presence updated';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get onboarding => 'Onboarding';

  @override
  String get howItWorks => 'How it Works';

  @override
  String get getStarted => 'Get Started';

  @override
  String get illDoThisLater => 'I\'ll do this later';

  @override
  String get backgroundLocationFooterPrivacy =>
      'Your data is only used for calendar synchronization and is fully encrypted. We never share your location with third parties.';
}
