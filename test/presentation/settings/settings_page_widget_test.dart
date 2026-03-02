import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/settings/repositories/settings_repository.dart';
import 'package:i_was_there/domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart';
import 'package:i_was_there/domain/settings/use_cases/get_last_sync_time_use_case.dart';
import 'package:i_was_there/domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart';
import 'package:i_was_there/domain/settings/use_cases/set_last_sync_time_use_case.dart';
import 'package:i_was_there/domain/sync/calendar_sync_service.dart';
import 'package:i_was_there/domain/sync/entities/google_account_info.dart';
import 'package:i_was_there/domain/sync/entities/pending_sync_item.dart';
import 'package:i_was_there/domain/sync/google_auth_service.dart';
import 'package:i_was_there/domain/sync/repositories/sync_repository.dart';
import 'package:i_was_there/domain/sync/use_cases/get_google_account_use_case.dart';
import 'package:i_was_there/domain/sync/use_cases/sign_in_with_google_use_case.dart';
import 'package:i_was_there/domain/sync/use_cases/sign_out_google_use_case.dart';
import 'package:i_was_there/domain/sync/use_cases/sync_pending_to_google_use_case.dart';
import 'package:i_was_there/l10n/app_localizations.dart';
import 'package:i_was_there/presentation/settings/bloc/settings_bloc.dart';
import 'package:i_was_there/presentation/settings/bloc/settings_event.dart';
import 'package:i_was_there/presentation/settings/bloc/settings_state.dart';
import 'package:i_was_there/presentation/settings/settings_page.dart';

void main() {
  group('SettingsPage widget test', () {
    late FakeSettingsRepository fakeRepo;
    late FakeGoogleAuthService fakeAuthService;
    late GetCalendarSyncEnabledUseCase getSyncUseCase;
    late SetCalendarSyncEnabledUseCase setSyncUseCase;
    late GetLastSyncTimeUseCase getLastSyncTimeUseCase;
    late SetLastSyncTimeUseCase setLastSyncTimeUseCase;
    late SignInWithGoogleUseCase signInUseCase;
    late SignOutGoogleUseCase signOutUseCase;
    late GetGoogleAccountUseCase getAccountUseCase;
    late SyncPendingToGoogleUseCase syncUseCase;

    setUp(() {
      fakeRepo = FakeSettingsRepository();
      fakeAuthService = FakeGoogleAuthService();
      getSyncUseCase = GetCalendarSyncEnabledUseCase(fakeRepo);
      setSyncUseCase = SetCalendarSyncEnabledUseCase(fakeRepo);
      getLastSyncTimeUseCase = GetLastSyncTimeUseCase(fakeRepo);
      setLastSyncTimeUseCase = SetLastSyncTimeUseCase(fakeRepo);
      signInUseCase = SignInWithGoogleUseCase(fakeAuthService);
      signOutUseCase = SignOutGoogleUseCase(fakeAuthService);
      getAccountUseCase = GetGoogleAccountUseCase(fakeAuthService);
      syncUseCase = SyncPendingToGoogleUseCase(
        FakeSyncRepository(),
        FakeCalendarSyncService(),
      );
    });

    Widget buildTestWidget({required SettingsBloc bloc}) {
      return MaterialApp(
        theme: buildAppTheme(isDark: false),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SettingsBloc>.value(
          value: bloc,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return SettingsPage(
                syncEnabled: state.syncEnabled,
                loading: state.loading,
                lastSyncTime: state.lastSyncTime,
                googleDisplayName: state.googleDisplayName,
                googleEmail: state.googleEmail,
                onSyncEnabledChanged: (value) => context
                    .read<SettingsBloc>()
                    .add(SettingsSyncEnabledChanged(value)),
              );
            },
          ),
        ),
      );
    }

    testWidgets('shows Sync with Google Calendar section', (
      WidgetTester tester,
    ) async {
      final bloc = SettingsBloc(
        getCalendarSyncEnabled: getSyncUseCase,
        setCalendarSyncEnabled: setSyncUseCase,
        getLastSyncTime: getLastSyncTimeUseCase,
        setLastSyncTime: setLastSyncTimeUseCase,
        signInWithGoogle: signInUseCase,
        signOutGoogle: signOutUseCase,
        getGoogleAccount: getAccountUseCase,
        syncPendingToGoogle: syncUseCase,
      )..add(SettingsLoadRequested());

      await tester.pumpWidget(buildTestWidget(bloc: bloc));
      await tester.pumpAndSettle();

      expect(find.text('Sync with Google Calendar'), findsOneWidget);
    });

    testWidgets('shows sync toggle and connected account content', (
      WidgetTester tester,
    ) async {
      final bloc = SettingsBloc(
        getCalendarSyncEnabled: getSyncUseCase,
        setCalendarSyncEnabled: setSyncUseCase,
        getLastSyncTime: getLastSyncTimeUseCase,
        setLastSyncTime: setLastSyncTimeUseCase,
        signInWithGoogle: signInUseCase,
        signOutGoogle: signOutUseCase,
        getGoogleAccount: getAccountUseCase,
        syncPendingToGoogle: syncUseCase,
      )..add(SettingsLoadRequested());

      await tester.pumpWidget(buildTestWidget(bloc: bloc));
      await tester.pumpAndSettle();

      expect(find.text('Automatic attendance logging'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('shows Language section', (WidgetTester tester) async {
      final bloc = SettingsBloc(
        getCalendarSyncEnabled: getSyncUseCase,
        setCalendarSyncEnabled: setSyncUseCase,
        getLastSyncTime: getLastSyncTimeUseCase,
        setLastSyncTime: setLastSyncTimeUseCase,
        signInWithGoogle: signInUseCase,
        signOutGoogle: signOutUseCase,
        getGoogleAccount: getAccountUseCase,
        syncPendingToGoogle: syncUseCase,
      )..add(SettingsLoadRequested());

      await tester.pumpWidget(buildTestWidget(bloc: bloc));
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
    });
  });
}

class FakeSettingsRepository implements SettingsRepository {
  bool syncEnabled = false;
  String? localeLanguageCode;

  @override
  Future<bool> getCalendarSyncEnabled() async => syncEnabled;

  @override
  Future<void> setCalendarSyncEnabled(bool enabled) async {
    syncEnabled = enabled;
  }

  @override
  Future<String?> getLocaleLanguageCode() async => localeLanguageCode;

  @override
  Future<void> setLocaleLanguageCode(String languageCode) async {
    localeLanguageCode = languageCode;
  }

  DateTime? _lastSyncTime;

  @override
  Future<DateTime?> getLastSyncTime() async => _lastSyncTime;

  @override
  Future<void> setLastSyncTime(DateTime time) async {
    _lastSyncTime = time;
  }
}

class FakeGoogleAuthService implements GoogleAuthService {
  @override
  Future<GoogleAccountInfo?> signIn() async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<GoogleAccountInfo?> getCurrentAccount() async => null;

  @override
  Future<Map<String, String>> getAuthHeaders() async => {};
}

class FakeSyncRepository implements SyncRepository {
  @override
  Future<List<PendingSyncItem>> getPendingSyncs() async => [];

  @override
  Future<void> markSynced(
    String placeId,
    DateTime date,
    String eventId,
  ) async {}

  @override
  Future<String?> getEventId(String placeId, DateTime date) async => null;

  @override
  Future<void> removeSyncRecord(String placeId, DateTime date) async {}
}

class FakeCalendarSyncService implements CalendarSyncService {
  @override
  Future<String> createEvent({
    required String placeName,
    required DateTime date,
    DateTime? firstDetectedAt,
  }) async => 'fake-event-id';

  @override
  Future<void> deleteEvent(String eventId) async {}
}
