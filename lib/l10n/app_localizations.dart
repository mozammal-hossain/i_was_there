import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

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
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @calendarSync.
  ///
  /// In en, this message translates to:
  /// **'Calendar Sync'**
  String get calendarSync;

  /// No description provided for @syncWithGoogleCalendar.
  ///
  /// In en, this message translates to:
  /// **'Sync with Google Calendar'**
  String get syncWithGoogleCalendar;

  /// No description provided for @automaticAttendanceLogging.
  ///
  /// In en, this message translates to:
  /// **'Automatic attendance logging'**
  String get automaticAttendanceLogging;

  /// No description provided for @oneWaySyncNote.
  ///
  /// In en, this message translates to:
  /// **'One-way sync: We only add events to your calendar. We never read or delete your existing data.'**
  String get oneWaySyncNote;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageBangla;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @connectedAccount.
  ///
  /// In en, this message translates to:
  /// **'CONNECTED ACCOUNT'**
  String get connectedAccount;

  /// No description provided for @changeAccountComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Change account – coming soon'**
  String get changeAccountComingSoon;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Shown when the user last synced with Google Calendar. The timeAgo argument is a pre-formatted relative time (e.g. 12m ago).
  ///
  /// In en, this message translates to:
  /// **'Last synced {timeAgo}'**
  String lastSyncedAt(String timeAgo);

  /// Shown when the user has never synced with Google Calendar.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get neverSynced;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'CONNECTED'**
  String get connected;

  /// No description provided for @syncDetails.
  ///
  /// In en, this message translates to:
  /// **'SYNC DETAILS'**
  String get syncDetails;

  /// No description provided for @automatedEvents.
  ///
  /// In en, this message translates to:
  /// **'Automated Events'**
  String get automatedEvents;

  /// Intro text before the event format and calendar name in sync details.
  ///
  /// In en, this message translates to:
  /// **'Visits are logged as '**
  String get visitsLoggedAs;

  /// No description provided for @presentAtLocation.
  ///
  /// In en, this message translates to:
  /// **'Present at [Location]'**
  String get presentAtLocation;

  /// No description provided for @inPrimaryCalendar.
  ///
  /// In en, this message translates to:
  /// **' in your primary calendar.'**
  String get inPrimaryCalendar;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncing;

  /// No description provided for @footerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is our priority. We only use calendar access to help you track your fitness consistency.'**
  String get footerPrivacy;

  /// Application name shown in the task switcher and system UI.
  ///
  /// In en, this message translates to:
  /// **'I Was There'**
  String get appTitle;

  /// No description provided for @whyIWasThere.
  ///
  /// In en, this message translates to:
  /// **'Why I Was There'**
  String get whyIWasThere;

  /// No description provided for @whySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Define your important places and automatically record your presence each day. Focus on your fitness goals while we handle the tracking.'**
  String get whySubtitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @googleCalendarSync.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar Sync'**
  String get googleCalendarSync;

  /// No description provided for @googleCalendarSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See all your activity and gym sessions in one place.'**
  String get googleCalendarSyncSubtitle;

  /// Step number label in the onboarding flow.
  ///
  /// In en, this message translates to:
  /// **'STEP {number}'**
  String stepNumber(int number);

  /// No description provided for @howAddPlaces.
  ///
  /// In en, this message translates to:
  /// **'Add your places on the map'**
  String get howAddPlaces;

  /// No description provided for @howLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant location permission for background checks'**
  String get howLocationPermission;

  /// No description provided for @howMarksPresence.
  ///
  /// In en, this message translates to:
  /// **'The app marks your presence automatically'**
  String get howMarksPresence;

  /// No description provided for @howSyncCalendar.
  ///
  /// In en, this message translates to:
  /// **'Optionally sync with Google Calendar'**
  String get howSyncCalendar;

  /// No description provided for @howViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View and adjust your history in the Calendar tab'**
  String get howViewHistory;

  /// No description provided for @enableAllowAllTheTime.
  ///
  /// In en, this message translates to:
  /// **'Enable \'Allow all the time\''**
  String get enableAllowAllTheTime;

  /// No description provided for @backgroundLocationBody.
  ///
  /// In en, this message translates to:
  /// **'To automatically sync your physical presence with Google Calendar every 10 minutes, we need background location access even when the app is closed.'**
  String get backgroundLocationBody;

  /// No description provided for @locationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get locationPermission;

  /// No description provided for @allowAllTheTime.
  ///
  /// In en, this message translates to:
  /// **'Allow all the time'**
  String get allowAllTheTime;

  /// No description provided for @howToEnable.
  ///
  /// In en, this message translates to:
  /// **'How to enable:'**
  String get howToEnable;

  /// No description provided for @tapOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Open Settings\' below'**
  String get tapOpenSettings;

  /// No description provided for @goToPermissionsLocation.
  ///
  /// In en, this message translates to:
  /// **'Go to Permissions > Location'**
  String get goToPermissionsLocation;

  /// No description provided for @selectAllowAllTheTime.
  ///
  /// In en, this message translates to:
  /// **'Select \'Allow all the time\''**
  String get selectAllowAllTheTime;

  /// No description provided for @openingSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Opening system settings…'**
  String get openingSystemSettings;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @noPlacesYet.
  ///
  /// In en, this message translates to:
  /// **'No places yet'**
  String get noPlacesYet;

  /// No description provided for @addPlaceToStart.
  ///
  /// In en, this message translates to:
  /// **'Add a place to start tracking your weekly attendance.'**
  String get addPlaceToStart;

  /// No description provided for @addYourFirstPlace.
  ///
  /// In en, this message translates to:
  /// **'Add your first place'**
  String get addYourFirstPlace;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @weeklyAttendance.
  ///
  /// In en, this message translates to:
  /// **'Weekly Attendance'**
  String get weeklyAttendance;

  /// No description provided for @overrideLabel.
  ///
  /// In en, this message translates to:
  /// **'Override'**
  String get overrideLabel;

  /// No description provided for @trackedStudios.
  ///
  /// In en, this message translates to:
  /// **'TRACKED STUDIOS'**
  String get trackedStudios;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get addLocation;

  /// No description provided for @pleaseEnterPlaceName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a place name'**
  String get pleaseEnterPlaceName;

  /// No description provided for @locationSet.
  ///
  /// In en, this message translates to:
  /// **'Location set.'**
  String get locationSet;

  /// No description provided for @couldNotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not get location: {error}'**
  String couldNotGetLocation(String error);

  /// No description provided for @couldNotSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String couldNotSave(String error);

  /// No description provided for @trackedPlace.
  ///
  /// In en, this message translates to:
  /// **'Tracked Place'**
  String get trackedPlace;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get name;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'ADDRESS'**
  String get address;

  /// No description provided for @enterPlaceName.
  ///
  /// In en, this message translates to:
  /// **'Enter place name'**
  String get enterPlaceName;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search address...'**
  String get searchAddress;

  /// No description provided for @searchAddressTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search address'**
  String get searchAddressTooltip;

  /// No description provided for @useMyCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useMyCurrentLocation;

  /// No description provided for @geoFenceDescription.
  ///
  /// In en, this message translates to:
  /// **'A 20m geofence ensures accurate attendance tracking while maintaining privacy and battery efficiency.'**
  String get geoFenceDescription;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @updatesSyncWithGoogleCalendar.
  ///
  /// In en, this message translates to:
  /// **'Updates sync with Google Calendar'**
  String get updatesSyncWithGoogleCalendar;

  /// No description provided for @allPlaces.
  ///
  /// In en, this message translates to:
  /// **'All Places'**
  String get allPlaces;

  /// No description provided for @presenceHistory.
  ///
  /// In en, this message translates to:
  /// **'Presence History'**
  String get presenceHistory;

  /// No description provided for @syncComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Sync – coming soon'**
  String get syncComingSoon;

  /// No description provided for @dayDetails.
  ///
  /// In en, this message translates to:
  /// **'DAY DETAILS'**
  String get dayDetails;

  /// No description provided for @tapDayToSeeSessions.
  ///
  /// In en, this message translates to:
  /// **'Tap a day on the calendar to see sessions'**
  String get tapDayToSeeSessions;

  /// Day details section title with month name and day number.
  ///
  /// In en, this message translates to:
  /// **'DAY DETAILS • {month} {day}'**
  String dayDetailsTitle(String month, int day);

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'PRESENT'**
  String get present;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'NO SESSIONS'**
  String get noSessions;

  /// No description provided for @noRecordedSessionsForDay.
  ///
  /// In en, this message translates to:
  /// **'No recorded sessions for this day'**
  String get noRecordedSessionsForDay;

  /// No description provided for @unknownPlace.
  ///
  /// In en, this message translates to:
  /// **'Unknown place'**
  String get unknownPlace;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @noPlacesToShow.
  ///
  /// In en, this message translates to:
  /// **'No places to show'**
  String get noPlacesToShow;

  /// No description provided for @addTrackedPlacesFromDashboard.
  ///
  /// In en, this message translates to:
  /// **'Add tracked places from the dashboard to see them on the map.'**
  String get addTrackedPlacesFromDashboard;

  /// No description provided for @manualPresenceOverride.
  ///
  /// In en, this message translates to:
  /// **'Manual Presence Override'**
  String get manualPresenceOverride;

  /// No description provided for @changeDate.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get changeDate;

  /// No description provided for @syncsWithGoogleCalendar.
  ///
  /// In en, this message translates to:
  /// **'SYNCS WITH GOOGLE CALENDAR'**
  String get syncsWithGoogleCalendar;

  /// No description provided for @applyChanges.
  ///
  /// In en, this message translates to:
  /// **'Apply Changes'**
  String get applyChanges;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequired;

  /// No description provided for @forceUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of I Was There is required. Please update to continue.'**
  String get forceUpdateMessage;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @manualPresenceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Manual presence updated'**
  String get manualPresenceUpdated;

  /// Shown in settings when no Google account is connected for calendar sync.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboarding;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it Works'**
  String get howItWorks;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @illDoThisLater.
  ///
  /// In en, this message translates to:
  /// **'I\'ll do this later'**
  String get illDoThisLater;

  /// No description provided for @backgroundLocationFooterPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your data is only used for calendar synchronization and is fully encrypted. We never share your location with third parties.'**
  String get backgroundLocationFooterPrivacy;
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
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
